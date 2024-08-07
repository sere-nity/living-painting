Shader "Custom/QuadDepthStencil"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthMap ("Depth Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenSpace : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _DepthMap;
            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenSpace = ComputeScreenPos(o.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, i.uv);
                float2 screenSpaceUV = i.screenSpace.xy / i.screenSpace.w;
                float sceneDepth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screenSpaceUV));
                // return float4(depth, depth, depth, 1.0); // Visualize depth as grayscale
                float quadDepth = tex2D(_DepthMap, i.uv).r;
                
                // Write to the stencil buffer based on depth map
                if (sceneDepth < quadDepth)
                {
                    discard; // Do not write anything if condition not met
                }
                return texColor;

                // Blend factor based on depth comparison
                float blendFactor = quadDepth < sceneDepth ? 1.0 : 0.0;

     

                // Blend the quad texture with a transparent color based on depth
                return lerp(float4(0, 0, 0, 0), texColor, blendFactor);
            }
            ENDCG
        }
    }
}

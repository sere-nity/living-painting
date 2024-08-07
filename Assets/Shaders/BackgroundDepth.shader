Shader "Custom/BackgroundDepth" {
    Properties {
        _MainTex("Diffuse", 2D) = "white" {}
        _Normal("Normal", 2D) = "bump" {}
        _DepthMap("Depth", 2D) = "white" {}
        _Shadow("Shadow", 2D) = "black" {}
        _Specular("Specular", 2D) = "black" {}
        _HeightScale("Height Scale", Float) = 0.1
        _ShadowBlend("Shadow Blend", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma multi_compile_fwdbase
        #include "UnityCG.cginc"
        #include "AutoLight.cginc"

        sampler2D _MainTex, _Normal, _Shadow, _Specular, _DepthMap;
        sampler2D _CameraDepthTexture;
        float _HeightScale;
        float _ShadowBlend;

        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
            SHADOW_COORDS(4)
        };

        void surf(Input IN, inout SurfaceOutputStandard o) {

            
            // Adjust UV based on depth map
            float2 adjustedUV = IN.uv_MainTex + tex2D(_DepthMap, IN.uv_MainTex).rg * _HeightScale;

            // Sample textures
            fixed4 bakedShadowColor = tex2D(_Shadow, IN.uv_MainTex);

            // Calculate shadow attenuation for dynamic shadows
            half shadowAtten = SHADOW_ATTENUATION(IN);

            // Blend the dynamic shadow with the baked shadow
            fixed4 dynamicShadowColor = fixed4(1.0, 1.0, 1.0, 1.0) * shadowAtten;
            fixed4 blendedShadowColor = lerp(bakedShadowColor, dynamicShadowColor, _ShadowBlend);

            // Sample base color and normal map
            fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex) * blendedShadowColor;
            o.Albedo = baseColor.rgb;
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));
            o.Alpha = baseColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

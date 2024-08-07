Shader "Custom/BackgroundShadow" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
        _Shininess ("Shininess", Range(0, 10)) = 6
        _MainTex ("Base (RGB), Gloss (A)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _BumpPower ("Bump Power", Range(-10, 10)) = 1
        _ShadowMap ("Shadow Map", 2D) = "white" {} 
        _DepthMap ("Depth Map", 2D) = "white" {}
        _SpecMap ("Specular Map", 2D) = "black" {} 
        _DepthOffset ("DeptOffset", Range(-1, 5)) = 0

    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            Name "BASE"
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 pos : TEXCOORD2;
                float4 vertex : SV_POSITION;
                float4 screenSpace : TEXCOORD3;
                SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            sampler2D _BumpMap;
            sampler2D _ShadowMap;
            sampler2D _SpecMap;
            sampler2D _DepthMap;
            float4 _Color;
            float _Shininess, _DepthOffset;
            float _BumpPower;
            sampler2D _CameraDepthTexture;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                o.uv = v.uv;
                o.pos = mul(UNITY_MATRIX_MV, v.vertex).xyz;
                o.screenSpace = ComputeScreenPos(o.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }

          half4 frag(v2f i) : SV_Target {

            float4 texColor = tex2D(_MainTex, i.uv);


            float2 screenSpaceUV = i.screenSpace.xy / i.screenSpace.w;
            float sceneDepth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screenSpaceUV));
            float quadDepth = tex2D(_DepthMap, i.uv).r;
            
            // Write to the stencil buffer based on depth map
            if ((sceneDepth + _DepthOffset) < quadDepth)
            {
                discard; // Do not write anything if condition not met
            }

         
              
            float shadow = tex2D(_ShadowMap, i.uv).r;
            float4 specMap = tex2D(_SpecMap, i.uv);

            float3 baseColor = texColor.rgb * _Color.rgb;

            // Normal mapping
            float3 normalTex = UnpackNormal(tex2D(_BumpMap, i.uv));
            float3 normal = normalize(i.normal + normalTex * _BumpPower);

            // Lighting
            float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
            float diff = max(dot(normal, lightDir), 0.0) * shadow;
            float3 diffuse = baseColor * _LightColor0.rgb * diff;

            // Specular using Color Dodge
            float3 viewDir = normalize(-i.pos);
            float3 reflectDir = reflect(-lightDir, normal);
            float rawSpec = pow(max(dot(viewDir, reflectDir), 0.0), _Shininess);
            float3 colorDodgeSpec = specMap.rgb / (1.0 - min(_LightColor0.rgb * rawSpec, 1.0));
            float3 specular = min(colorDodgeSpec, 1.0);  // Clamping to prevent over-blowing

            // Combine results
            float3 finalColor = diffuse + specular;
            return half4(finalColor, texColor.a);
        }
            ENDCG
        }
    }

}

Shader "Custom/Background(Obsolete)" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
        _Shininess ("Shininess", Range(0.03, 1)) = 0.5
        _MainTex ("Base (RGB), Gloss (A)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _BumpPower ("Bump Power", Range(-10, 10)) = 1
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
                SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            sampler2D _BumpMap;
            float4 _Color;
           // float4 _SpecColor;
            float _Shininess;
            float _BumpPower;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                o.uv = v.uv;
                o.pos = mul(UNITY_MATRIX_MV, v.vertex).xyz;
                TRANSFER_SHADOW(o);
                return o;
            }

            half4 frag(v2f i) : SV_Target {

                float4 texColor = tex2D(_MainTex, i.uv);

                // if we want to add a texture to the background later, we need o use
                // a mask of some sort to contain this alpha value (I'm not sure if you can encode the alpha
                // in a normal map probably not) 
                if (texColor.a == 0.0) {
                    return texColor; // Return the original texture color without any lighting
                }
                
                float3 baseColor = texColor.rgb * _Color.rgb;

                // Normal mapping
                float3 normalTex = UnpackNormal(tex2D(_BumpMap, i.uv));
                float3 normal = normalize(i.normal + normalTex * _BumpPower);

                // Lighting
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diff = max(dot(normal, lightDir), 0.0);
                float3 diffuse = baseColor * _LightColor0.rgb * diff;

                // Specular
                float3 viewDir = normalize(-i.pos);
                float3 reflectDir = reflect(-lightDir, normal);
                float spec = pow(max(dot(viewDir, reflectDir), 0.0), _Shininess) * _SpecColor.a;
                float3 specular = _SpecColor.rgb * _LightColor0.rgb * spec;

                // Combine results
                float3 finalColor = diffuse + specular;
                return half4(finalColor, texColor.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

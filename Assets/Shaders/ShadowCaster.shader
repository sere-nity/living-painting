Shader "Custom/TransparentShadowReceiver" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        
         Pass {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            LOD 80
            Cull Off

            CGPROGRAM
            #pragma vertex vertShadow
            #pragma fragment fragShadow
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2fShadow {
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2fShadow vertShadow(appdata_base v) {
                v2fShadow o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 fragShadow(v2fShadow i) : SV_Target {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }

        Pass {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite On

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_SHADOW(o, v.vertex);
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                half4 col = tex2D(_MainTex, i.uv);
                half shadowAtten = SHADOW_ATTENUATION(i);

                // Set alpha to the inverse of shadow attenuation
                col.a = 1.0 - shadowAtten;

                // Return the color with adjusted alpha
                return half4(col.rgb, col.a);
            }
            ENDCG
        }

       
    }
    FallBack "Diffuse"
}

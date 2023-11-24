Shader "Unlit/My First Lighting Shader"
{
    Properties
    {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "white" {}
        // [NoScaleOffset] _HeightMap ("Heights", 2D) = "gray" {}
        [NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
        // _SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _BumpScale ("Bump Scale", Float) = 1
        _DetailTex ("Detail Texture", 2D) = "gray" {}
    }
    SubShader
    {
        Pass
        {
            Tags {
				"LightMode" = "ForwardBase"
			}
            CGPROGRAM

            #pragma target 3.0
            
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            // #include "UnityCG.cginc"
            // #include "UnityStandardBRDF.cginc"
			// #include "UnityStandardUtils.cginc"
            #include "UnityPBSLighting.cginc"

            float4 _Tint;
            sampler2D _MainTex, _DetailTex;
            float4 _MainTex_ST, _DetailTex_ST;
            // float4 _SpecularTint;
            float _Metallic;
            float _Smoothness;
            // sampler2D _HeightMap;
            // float4 _HeightMap_TexelSize;
            sampler2D _NormalMap;
            float _BumpScale;

            struct Interpolators{
                float4 position : SV_POSITION;
                // float2 uv : TEXCOORD0;
                float4 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            struct VertexData{
                float4 position : POSITION;
                float3 normal : NORMAL;
                float4 uv : TEXCOORD0;
            };

            Interpolators MyVertexProgram(VertexData v)
            {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
                // i.normal = v.normal;
                // i.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                // i.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
                // i.normal = mul(
				// 	transpose((float3x3)unity_WorldToObject),
				// 	v.normal
				// );
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
	            i.uv.zw = TRANSFORM_TEX(v.uv, _DetailTex);
                // i.normal = normalize(i.normal);
                return i;
            }

            void InitializeFragmentNormal(inout Interpolators i) {
                // i.normal = tex2D(_NormalMap, i.uv).rgb;
                // float2 du = float2(_HeightMap_TexelSize.x * 0.5, 0);
                // float u1 = tex2D(_HeightMap, i.uv - du);
                // float u2 = tex2D(_HeightMap, i.uv + du);
                // // float3 tu = float3(1, u2 - u1, 0);

                // float2 dv = float2(0, _HeightMap_TexelSize.y * 0.5);
                // float v1 = tex2D(_HeightMap, i.uv - dv);
                // float v2 = tex2D(_HeightMap, i.uv + dv);
                // // float3 tv = float3(0, v2 - v1, 1);

                // i.normal = float3(u1 - u2, 1, v1 - v2);
                // i.normal.xy = tex2D(_NormalMap, i.uv).wy * 2 - 1;
                // i.normal.xy *= _BumpScale;
	            // i.normal.z = sqrt(1 - saturate(dot(i.normal.xy, i.normal.xy)));
                i.normal = UnpackScaleNormal(tex2D(_NormalMap, i.uv.xy), _BumpScale);
                i.normal = i.normal.xzy;
                i.normal = normalize(i.normal);
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                InitializeFragmentNormal(i); // mobile optimization choice
                // return float4(i.normal * 0.5 + 0.5, 1);
                // return dot(float3(0, 1, 0), i.normal);
                // return max(0, dot(float3(0, 1, 0), i.normal));
                // return DotClamped(0, dot(float3(0, 1, 0), i.normal));
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 lightColor = _LightColor0.rgb;
                float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Tint.rgb;
                albedo *= tex2D(_DetailTex, i.uv.zw) * unity_ColorSpaceDouble;
                // albedo *= tex2D(_HeightMap, i.uv);
				// albedo *= 1 - _SpecularTint.rgb;
                // albedo *= 1 -
				// 	max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b));
                // float3 specularTint = albedo *_Metallic;
                // float oneMinusReflectivity = 1 - _Metallic;
                float3 specularTint;
                float oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(
					albedo, _Metallic, specularTint, oneMinusReflectivity
				);
                // float oneMinusReflectivity;
				// albedo = EnergyConservationBetweenDiffuseAndSpecular(
				// 	albedo, _SpecularTint.rgb, oneMinusReflectivity
				// );
				float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
				// return float4(diffuse, 1);
                // float3 reflectionDir = reflect(-lightDir, i.normal);
                float3 halfVector = normalize(lightDir + viewDir);
				// return float4(reflectionDir * 0.5 + 0.5, 1);
                // return DotClamped(viewDir, reflectionDir);
                float3 specular = specularTint * lightColor * pow(
                    // DotClamped(viewDir, reflectionDir),
                    DotClamped(halfVector, i.normal),
                    _Smoothness * 100
                );
                return float4(diffuse + specular, 1);
            }

            ENDCG
        }
    }
}

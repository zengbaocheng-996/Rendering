#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;
float _Metallic;
float _Smoothness;

struct Interpolators{
    float4 position : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 worldPos : TEXCOORD2;

    #if defined(VERTEXLIGHT_ON)
		float3 vertexLightColor : TEXCOORD3;
	#endif
};

struct VertexData{
    float4 position : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

UnityIndirect CreateIndirectLight (Interpolators i) {
	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;

	#if defined(VERTEXLIGHT_ON)
		indirectLight.diffuse = i.vertexLightColor;
	#endif
	return indirectLight;
}

Interpolators MyVertexProgram(VertexData v)
{
    Interpolators i;
    i.position = UnityObjectToClipPos(v.position);
    i.uv = TRANSFORM_TEX(v.uv, _MainTex);
    i.worldPos = mul(unity_ObjectToWorld, v.position);
    i.normal = UnityObjectToWorldNormal(v.normal);
    ComputeVertexLightColor(i);
    return i;
}

UnityLight CreateLight (Interpolators i)
{
    UnityLight light;

    #if defined(POINT) || defined(SPOT)
        light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    #else
        light.dir = _WorldSpaceLightPos0.xyz;
    #endif
    
    light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    light.color = _LightColor0.rgb;
    light.ndotl = DotClamped(i.normal, light.dir);
    return light;
}

float4 MyFragmentProgram(Interpolators i) : SV_TARGET
{
    i.normal = normalize(i.normal); // mobile optimization choice

    // float3 lightDir = _WorldSpaceLightPos0.xyz;
    // float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
    // float3 lightColor = _LightColor0.rgb;
    // float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos;
	// float attenuation = 1 / (1 + dot(lightVec, lightVec));
    UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
	light.color = _LightColor0.rgb * attenuation;
    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

    float3 specularTint;
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic(
        albedo, _Metallic, specularTint, oneMinusReflectivity
    );

    // UnityLight light;
    // light.color = lightColor;
    // light.dir = lightDir;
    // light.ndotl = DotClamped(i.normal, lightDir);

    // UnityIndirect indirectLight;
    // indirectLight.diffuse = 0;
    // indirectLight.specular = 0;

    return UNITY_BRDF_PBS(
        albedo, specularTint,
        oneMinusReflectivity, _Smoothness,
        i.normal, viewDir,
        CreateLight(i), CreateIndirectLight(i)
    );
}

#endif
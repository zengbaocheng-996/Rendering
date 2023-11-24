// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Textured With Detail"
{
    Properties
    {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "black" {}
        _DetailTex ("Detail Texture", 2D) = "gray" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "UnityCG.cginc"

            float4 _Tint;
            sampler2D _MainTex, _DetailTex;
			float4 _MainTex_ST, _DetailTex_ST;

            struct Interpolators{
                float4 position : SV_POSITION;
                // float3 localPosition : TEXCOORD0;
                float2 uv : TEXCOORD0;
                float2 uvDetail : TEXCOORD1;
            };

            struct VertexData{
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators MyVertexProgram(VertexData v)
            {
                Interpolators i;
                // i.localPosition = v.position.xyz;
                i.position = UnityObjectToClipPos(v.position);
                // i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                // return _Tint;
                // return float4(i.localPosition + 0.5, 1) * _Tint;
                // return float4(i.localPosition, 1) * _Tint;
                // return float4(i.uv, 1, 1);
                // return tex2D(_MainTex, i.uv);
                float4 color = tex2D(_MainTex, i.uv) * _Tint;
                // color *= tex2D(_MainTex, i.uv * 10) * 2;
                color *= tex2D(_MainTex, i.uvDetail) * unity_ColorSpaceDouble;
                return color;
            }

            ENDCG
        }
    }
}

Shader "Unlit/shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex("Second Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                // 存储额外的uv2 存储于TEXCOORD1中
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SecondTex;
            float4 _SecondTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // 修改 uv
                // v.uv *= 2;
                // 偏移 uv
                // v.uv += float2(0.5, 0.5);
                // 旋转 以弧度制计算
                // float rad = -0.5;
                // float sinx = sin(rad);
                // float cosx = cos(rad);
                // v.uv = mul(float2x2(cosx, -sinx, sinx, cosx), v.uv);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // 计算针对_SecondTex采样使用的uv2
                o.uv2 = TRANSFORM_TEX(v.uv, _SecondTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col0 = tex2D(_MainTex, i.uv);
                fixed4 col1 = tex2D(_SecondTex, i.uv2);
                float4 col = col0 * col1.r;
                return col;
            }
            ENDCG
        }
    }
}

Shader "Unlit/Blur"
{
    Properties
    {
        [HideInInspector]_MainTex ("WebCam Texture", 2D) = "white" {}
        _BlurSize ("Blur Size", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        ZWrite Off
        ZTest Always


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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _BlurSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv.x = 1.0 - i.uv.x; // 左右反転
                i.uv.y = 1.0 - i.uv.y; // 上下反転

                // float2 offset = float2(_MainTex_ST.x * _BlurSize, 0);
                // fixed4 col = tex2D(_MainTex, i.uv) * 0.4;
                // col += tex2D(_MainTex, i.uv + offset * 2.0) * 0.25;
                // col += tex2D(_MainTex, i.uv - offset * 2.0) * 0.25;
                // col += tex2D(_MainTex, i.uv + offset * 4.0) * 0.05;
                // col += tex2D(_MainTex, i.uv - offset * 4.0) * 0.05;

                // 水平方向のぼかしを行う
                float2 offset = float2(_BlurSize / _MainTex_ST.x, 0.0);
                fixed4 col = tex2D(_MainTex, i.uv) * 0.2; // 中心の色
                col += tex2D(_MainTex, i.uv + offset) * 0.2; // 右
                col += tex2D(_MainTex, i.uv - offset) * 0.2; // 左
                col += tex2D(_MainTex, i.uv + offset * 2.0) * 0.2; // 右2
                col += tex2D(_MainTex, i.uv - offset * 2.0) * 0.2; // 左2
                col += tex2D(_MainTex, i.uv + offset * 3.0) * 0.2; // 右3
                col += tex2D(_MainTex, i.uv - offset * 3.0) * 0.2; // 左3
                return col;
            }
            ENDCG
        }
    }
}
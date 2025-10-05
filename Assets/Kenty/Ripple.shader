Shader "Unlit/Ripple"
{
    Properties
    {
        _MainTex ("WebCam Texture", 2D) = "white" {}
        _Strength ("Ripple Strength", Float) = 0.2
        _Speed ("Ripple Speed", Float) = 2.0
        _Frequency ("Ripple Frequency", Float) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
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
            float _Strength;
            float _Speed;
            float _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                i.uv.x = 1.0 - i.uv.x;
                i.uv.y = 1.0 - i.uv.y;
                float2 center = float2(0.5, 0.5);

                // UV座標と波紋の中心との距離を計算
                float2 uvOffset = i.uv - center;
                float distance = length(uvOffset);

                // 時間と中心からの距離に基づいて波紋を作成
                float wave = sin(distance * _Frequency - _Time.y * _Speed);
                wave *= _Strength;

                // 波紋効果を適用
                i.uv.x += wave * uvOffset.x;
                i.uv.y += wave * uvOffset.y;

                // 元のテクスチャの色を取得
                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}
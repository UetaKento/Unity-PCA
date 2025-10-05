Shader "Unlit/ReplaceTexture"
{
    Properties
    {
        [HideInInspector]_MainTex ("WebCam Texture", 2D) = "white" {}
        _ReplaceTex ("Texture to Replace", 2D) = "white" {}
        _ReplaceColor ("Color to Replace", Color) = (0, 0, 0, 1)
        _Threshold ("Clip Threshold", Float) = 0.001 // この値が小さいほど指定した色に近い色のみが指定したテクスチャに置き換わる。
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
            sampler2D _ReplaceTex;
            float4 _ReplaceColor;
            float _Threshold;

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
                fixed4 col = tex2D(_MainTex, i.uv);

                // 指定した色（例：黒色）と一致する部分を置き換え
                if (distance(col.rgb, _ReplaceColor.rgb) < _Threshold) // 色の近似度（距離）を使って判定
                {
                    // 置き換え用のテクスチャを適用
                    col = tex2D(_ReplaceTex, i.uv);
                }

                return col;
            }
            ENDCG
        }
    }
}

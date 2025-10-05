Shader "Unlit/RGBShift"
{
    Properties
    {
        [HideInInspector]_MainTex ("WebCam Texture", 2D) = "white" {}
        _ShiftAmount ("Shift Amount", Float) = 0.1
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
            float _ShiftAmount;

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

                // RGBシフトを加える
                float2 redOffset = float2(_ShiftAmount, 0.0);
                float2 greenOffset = float2(0.0, _ShiftAmount);
                float2 blueOffset = float2(-_ShiftAmount, 0.0);

                // 各チャネルにオフセットを適用
                fixed4 redCol = tex2D(_MainTex, i.uv + redOffset);
                fixed4 greenCol = tex2D(_MainTex, i.uv + greenOffset);
                fixed4 blueCol = tex2D(_MainTex, i.uv + blueOffset);

                // オフセットされた色を元に戻す
                col.r = redCol.r;
                col.g = greenCol.g;
                col.b = blueCol.b;

                return col;
            }
            ENDCG
        }
    }
}
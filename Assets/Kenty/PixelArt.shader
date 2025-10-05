Shader "Unlit/PixelArt"
{
    Properties
    {
        [HideInInspector]_MainTex ("WebCam Texture", 2D) = "white" {}
        _PixelSize ("Pixel Size", Float) = 64
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
            float _PixelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv.x = 1.0 - i.uv.x; // ç∂âEîΩì]
                i.uv.y = 1.0 - i.uv.y; // è„â∫îΩì]
                float2 pixelCoords = floor(i.uv * _PixelSize) / _PixelSize;
                fixed4 col = tex2D(_MainTex, pixelCoords);
                return col;
            }
            ENDCG
        }
    }
}
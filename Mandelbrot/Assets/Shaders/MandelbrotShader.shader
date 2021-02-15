Shader "Custom/MandelbrotShader"
{
    Properties
    {
		_PositionX ("Position X", Range(-2, 2)) = 0
		_PositionY ("Position Y", Range(-2, 2)) = 0
		
		_Zoom ("Zoom", Range(0.001, 1.15)) = 1

		_Iterations ("Number of iterations", Int) = 1

		_RampTexture ("Ramp texture", 2D) = "white" {}
    }

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
	
			float _PositionX;
			float _PositionY;
			float _Zoom;
			int _Iterations;
			sampler2D _RampTexture;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

			float mandelbrot(float2 c)
			{
				_Iterations /= pow(_Zoom, 2.5);

				float2 z = 0;

				c.x = 1.3333 * (c.x - 0.5) * pow(_Zoom, 10) + _PositionX;
				c.y = (c.y - 0.5) * pow(_Zoom, 10) + _PositionY;

				float2 zNext;

				int i;
				for (i = 0; i < _Iterations; i++)
				{
					zNext.x = z.x * z.x - z.y * z.y + c.x;
					zNext.y = 2 * z.x * z.y + c.y;

					z = zNext;

					if (zNext.x * zNext.x + zNext.y * zNext.y > 4.0)
					{
						break;
					}
				}

				return i / float(_Iterations);
			}

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f input) : SV_Target
            {
				float value = mandelbrot(input.uv);

				float4 ramp = tex2D(_RampTexture, value);

                return value * ramp;
            }

            ENDCG
        }
    }
}

Shader "Hidden/GameOfLife"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			
			#include "UnityCG.cginc"

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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float random (float2 texCoord, int seed)
			{
				return frac(sin(dot(texCoord.xy, float2(12.9898, 78.233)) + seed) * 43758.5453);
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float brightness = random(i.uv, i.vertex.x);
				return float4(brightness, brightness, brightness, 1);
			}
			ENDCG
		}

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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float dx = _MainTex_TexelSize.x;
				float dy = _MainTex_TexelSize.y;
				
				float sum = 0.0;
				sum += tex2D(_MainTex, i.uv + float2( -dx,  dy));
				sum += tex2D(_MainTex, i.uv + float2(   0,  dy));
				sum += tex2D(_MainTex, i.uv + float2(  dx,  dy));
				sum += tex2D(_MainTex, i.uv + float2( -dx,   0));
				sum += tex2D(_MainTex, i.uv + float2(  dx,   0));
				sum += tex2D(_MainTex, i.uv + float2( -dx, -dy));
				sum += tex2D(_MainTex, i.uv + float2(   0, -dy));
				sum += tex2D(_MainTex, i.uv + float2( dx,   dy));

				float brightness;
				float4 current = tex2D(_MainTex, i.uv);
				brightness = current.x == 0.0 ? (sum == 3.0 ? 1.0 : 0.0) : ((sum >= 2.0 && sum <= 3.0) ? 1.0 : 0.0);
				return float4(brightness, brightness, brightness, 1.0);
			}
			ENDCG
		}
	}
}

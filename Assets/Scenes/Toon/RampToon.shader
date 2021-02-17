Shader "Custom/RampToon"
{
	Properties
	{
		//_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_RampTex("Ramp (RGB)", 2D) = "white" {}
		_Param1("Param1", float) = 0.5
		_Param2("Param2", float) = 0.5
	}

		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf _CustomLight noambient

		sampler2D _MainTex;
		sampler2D _RampTex;

		float _Param1;
		float _Param2;

		struct Input
		{
			float2 uv_MainTex;
		};

		//fixed4 _Color;
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);// *_Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			//o.Albedo = _Color;
		}

		float4 Lighting_CustomLight(SurfaceOutput s, float3 lightDir, float viewDir, float atten)
		{
			//float nl = saturate(dot(s.Normal, lightDir) * 0.5 + 0.5);
			float nl = saturate(dot(s.Normal, lightDir) * _Param1 + _Param2);
			//float nl = dot(s.Normal, lightDir);// *_Param1 + _Param2;

			//float v = saturate(dot(s.Normal, viewDir));

			// nl은 half lambert라 0 ~ 1
			float4 retColor;
			retColor.rgb = tex2D(_RampTex, float2(nl, 0.9)) * s.Albedo;
			retColor.a = s.Alpha;
			return retColor;
		}

		ENDCG
	}

		FallBack "Diffuse"
}

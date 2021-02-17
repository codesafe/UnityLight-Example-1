Shader "Custom/SurfaceToon"
{

	Properties
	{
		//[HDR]
		_Color("Color", Color) = (1,1,1,1)
		//_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Param1("Param1", float) = 0.5
		_Param2("Param2", float) = 0.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf _CustomLight noambient 

		sampler2D _MainTex;
		float _Param1;
		float _Param2;

		struct Input
		{
			float2 uv_MainTex;
		};

		fixed4 _Color;
		void surf(Input IN, inout SurfaceOutput o)
		{
			//fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
			//o.Alpha = c.a;
			o.Albedo = _Color;
		}

		float4 Lighting_CustomLight(SurfaceOutput s, float3 lightDir, float atten)
		{
			//float nl = saturate(dot(s.Normal, lightDir) * 0.7 + 0.3);
			float nl = dot(s.Normal, lightDir) * _Param1 + _Param2;

			if (nl > 0.7)
				nl = 1;
			else if (nl > 0.5)
				nl = 0.5;
			else
				nl = 0.2;

			float4 retColor;
			retColor.rgb = s.Albedo * nl * /*_LightColor0.rgb **/ atten;
			retColor.a = 1.0f;
			return retColor;
		}

		ENDCG
	}

		FallBack "Diffuse"
}

Shader "Custom/Rim"
{
		Properties
		{
			//[HDR]
			_Color("Color", Color) = (1,1,1,1)
			_RimColor("RimColor", Color) = (1,1,1,1)
			_RimPower("RimPower", Range(0, 10)) = 0
		}

		SubShader
		{
			//Tags { "RenderType" = "Opaque" }
			//Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
			Tags { "Queue" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma surface surf _CustomLight noambient keepalpha


			struct Input
			{
				float2 uv_MainTex;
				float3 viewDir;
			};

			fixed4 _Color;
			fixed4 _RimColor;
			float _RimPower;

			// order #0
			void surf(Input IN, inout SurfaceOutput o)
			{
				half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
				rim = pow(rim, _RimPower);
				float3 coloredRim = rim * _RimColor;

				//o.Albedo = _Color.rgb;
				o.Albedo = coloredRim;
				o.Alpha = _Color.a;
				//o.Emission = coloredRim;
			}

			// order #1
			float4 Lighting_CustomLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
			{
				//float fFresnel = 1-dot(s.Normal, viewDir);
				//fFresnel = pow(fFresnel, _RimPower);

				float4 fFinalColor;
				//fFinalColor.rgb = s.Albedo + _RimColor*fFresnel;
				fFinalColor.rgb = s.Albedo;
				fFinalColor.a = s.Alpha;
				return fFinalColor;
			}

			ENDCG
		}

		FallBack "Diffuse"
}

Shader "Custom/CustomLight"
{

	Properties 
	{
		//[HDR]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularPower("SpecularPower", float) = 60.0
    }
    
	SubShader 
	{
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf _CustomLight noambient

        sampler2D _MainTex;
		float _SpecularPower;
 
        struct Input 
		{
            float2 uv_MainTex;
        };
 
        fixed4 _Color;
        void surf (Input IN, inout SurfaceOutput o) 
		{
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
		
		/*
			Blinn-Phong 공식
			dot(Normal-Vector, Half-Vector)
			Half-Vector = LightVector와 ViewVector 합의 정규화
			Half-Vector = normalize(LightVecotr + ViewVector);
			Specular = dot(Normal-Vector, Half-Vector);
		*/

		float4 Lighting_CustomLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
			float nl = saturate( dot(s.Normal, lightDir) * 0.5 + 0.5 );
			float3 halfVector = 0.0f;
			float specular = 0.0f;
		
			if (nl > 0)
			{
				halfVector = normalize(lightDir + viewDir);
				specular = saturate(dot(s.Normal, halfVector));
				specular = pow(specular, _SpecularPower);
			}
			
			//float fFresnel = 1 - dot(s.Normal, viewDir);
            //fFresnel = pow(fFresnel, 10);

			float4 retColor;
			retColor.rgb = ( s.Albedo * nl * _LightColor0.rgb + (specular * _LightColor0) ) * atten;
			//retColor.rgb = (s.Albedo * nl * atten * _LightColor0.rgb) + (specular * _LightColor0) + (fFresnel * _LightColor0 * atten);
			
			retColor.a = 1.0f;
 			return retColor;
        }
		
        ENDCG
    }

    FallBack "Diffuse"
}

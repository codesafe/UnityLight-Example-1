Shader "Custom/Reflect"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump" {}
		_CubeMap ("CubeMap", cube) = "" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _CubeMap;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldRefl;
			INTERNAL_DATA	// for normal map
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * 0.5;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

			//o.Emission = texCUBE(_CubeMap, IN.worldRefl).rgb;
			o.Emission = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/CustomLightToon"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		// Ambient light is applied uniformly to all surfaces on the object.
		//[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
	}
	
	SubShader
	{
			/*
		Pass 
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual

			CGPROGRAM
			//#pragma target 3.0
			//#pragma glsl
			//#pragma exclude_renderers gles

			// -------------------------------------

			//#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma multi_compile_shadowcaster

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
			*/
		Pass
		{
			// Setup our pass to use Forward rendering, and only receive
			// data on the main directional light and ambient light.
			Tags
			{
				"LightMode" = "ForwardBase"
				//"PassFlags" = "OnlyDirectional"
			}

			Cull Back
			//ZTest LEqual
			ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// Compile multiple versions of this shader depending on lighting settings.
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			// Files below include macros and functions to assist
			// with lighting and shadows.
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;				
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;	
				// Macro found in Autolight.cginc. Declares a vector4
				// into the TEXCOORD2 semantic with varying precision 
				// depending on platform target.
				SHADOW_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);		
				o.viewDir = WorldSpaceViewDir(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				// Defined in Autolight.cginc. Assigns the above shadow coordinate
				// by transforming the vertex from world space to shadow-map space.
				
				TRANSFER_SHADOW(o)
				return o;
			}
			
			float4 _Color;
			float4 _AmbientColor;


			float4 frag (v2f i) : SV_Target
			{
				float3 normal = normalize(i.worldNormal);
				float3 viewDir = normalize(i.viewDir);
				float NdotL = dot(_WorldSpaceLightPos0, normal) * 0.5 + 0.5;

				// Samples the shadow map, returning a value in the 0...1 range,
				// where 0 is in the shadow, and 1 is not.
				//float shadow = SHADOW_ATTENUATION(i);
				
				// Partition the intensity into light and dark, smoothly interpolated
				// between the two to avoid a jagged break.
				//float lightIntensity = smoothstep(0, 0.05, NdotL * shadow);	
				float lightIntensity = step(0.8, NdotL);

/*
				NdotL = NdotL / 2;
				float lightIntensity = floor(NdotL);

				float change = fwidth(NdotL);
				float smoothing = smoothstep(0, change, frac(NdotL));
				lightIntensity = lightIntensity + smoothing;
*/

				
				// Multiply by the main directional light's intensity and color.
				float4 light = lightIntensity * _LightColor0;
				float4 sample = tex2D(_MainTex, i.uv);

				float attenuation = LIGHT_ATTENUATION(i);

				return ((light + _AmbientColor) * _Color * sample) * attenuation;
			}
			ENDCG
		}
	}

	// for shadow cast
	Fallback "VertexLit"
}


Shader "Custom/UnlitTextureOpaque"
{
	Properties 
	{
		_MainTex ("MainTex", 2D) = "white" {}
	}

	SubShader 
	{
	
		Pass {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
           
            ZWrite On ZTest LEqual
 
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            // TEMPORARY: GLES2.0 temporarily disabled to prevent errors spam on devices without textureCubeLodEXT
            #pragma exclude_renderers gles
           
            // -------------------------------------
 
 
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma multi_compile_shadowcaster
 
            #pragma vertex vertShadowCaster
            #pragma fragment fragShadowCaster
 
            #include "UnityStandardShadow.cginc"
 
            ENDCG
        }

		Pass 
		{
			Tags { "LightMode" = "ForwardBase" "RenderType"="Opaque" "Queue"="Geometry" }
			//Tags { "LightMode" = "ShadowCaster" }
			
			Cull Back 		
			//ZWrite On
			Lighting On

		
			CGPROGRAM
		
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			//#include "AutoLight.cginc"

			struct appdata_t 
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				//LIGHTING_COORDS(3,4)
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			//float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.texcoord);
				return c;
			}
			ENDCG
	

		}
	}

  FallBack "Diffuse"	
}


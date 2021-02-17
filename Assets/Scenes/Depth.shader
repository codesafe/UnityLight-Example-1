﻿
Shader "Custom/CustomDepth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_DepthDistance("DepthDistance", float) = 25
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" "DepthRender" = "Opaque" }
        Cull Off
		ZWrite On
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			//float4 _MainTex_TexelSize;

			sampler2D_float _CameraDepthTexture;	//! 카메라로부터 뎁스텍스처를 받아옴
			half _DepthDistance;

            fixed4 frag (v2f i) : SV_Target
            {
				float4 retColor;
				float fDepthData = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(float4(i.uv, 1, 1))).r;	//! 텝스텍스처 샘플러에서 텍셀정보를 가져옴
				float fSceneZ = LinearEyeDepth(fDepthData);		//! DepthData를 0~1 Linear데이터로 변환(0 = 카메라, 1 = 먼거리)
				float fCalc_Depth = 1 - saturate(fSceneZ / _DepthDistance);		//! 거리 값 조절용 계산
				
				retColor.rgb = fCalc_Depth;
				retColor.a = 1;
				
				//return fCalc_Depth;
				return retColor;

				/*
				float depth = tex2D(_CameraDepthTexture, i.uv).r;
				//linear depth between camera and far clipping plane
				depth = Linear01Depth(depth);
				return depth;
				*/

            }
            ENDCG
        }
    }
}

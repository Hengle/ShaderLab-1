// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lab_Zero/toProjSpace" {

	Properties {
		_X("X",range(0,1))=0
		_Y("Y",range(0,1))=0
		_Z("Z",range(0,1))=0
		_Scal("scale",range(1,2))=1
	}
	SubShader {
		pass{
	//Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _X,_Y,_Z,_Scal;
		uniform float3 viewPos;
		struct v2f {
			float4 pos:SV_POSITION;
			//float3 pjPos:TEXCOORD0;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
		//float c=pow(i.pjPos.x,4)*_X+i.pjPos.y*_Y-i.pjPos.z*_Z;
		float3 pjPos=TransformViewToProjection(viewPos);
		float c=pjPos.x*_X+pjPos.y*_Y;//-i.pjPos.z*_Z;
		//float c=pjPos.z*_Z;
		//if(pjPos.z>2)
			//c=-1;
			return (c)/(_Scal);
		}
		ENDCG
		}//end Forward Base
	} 
	//FallBack "Diffuse"
}

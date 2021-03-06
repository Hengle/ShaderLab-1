// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/BuildInShadow/Caster_2.1" {
Properties {
	_MainTex("MainTex",2D)="white"{}
    _v("v value",range(0,6))=0.2
}

SubShader {
	//normal pass to render object
		pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
	
			struct vertOut {
				float4 oPos:SV_POSITION;
			};
			vertOut vert(appdata_base v)
			{
				vertOut o;
				float4 pos=UnityObjectToClipPos(v.vertex);
				o.oPos=pos;
				return o;
			}
			float4 frag(vertOut i):COLOR
			{
				float4 c;
				c=float4(0.3,0.3,0.3,0.3);
				c.g=0.6;
				return c;
			}
			ENDCG
		}
    // Pass to render object as a shadow caster
    Pass {
       Name "ShadowCaster"
       Tags { "LightMode" = "ShadowCaster" }

       Fog {Mode Off}
       ZWrite On ZTest Less Cull Off
       //Offset [_ShadowBias], [_ShadowBiasSlope]

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile SHADOWS_NATIVE SHADOWS_CUBE
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		float _v;
		
		struct v2f { 
		    //V2F_SHADOW_CASTER;
		    float4 pos : SV_POSITION; 
		    float4 hpos : TEXCOORD1;
		    float3 vec : TEXCOORD0;
		    float2 uv:TEXCOORD2;
		};
		
		v2f vert( appdata_base v )
		{
		    v2f o;
		    //TRANSFER_SHADOW_CASTER(o)
		    float4 vPos=v.vertex;
		    o.vec = mul( unity_ObjectToWorld, vPos).xyz - _LightPositionRange.xyz;//顶点到光源的距离
		    o.pos = UnityObjectToClipPos(vPos);
		    //
		    o.pos.z += unity_LightShadowBias.x; 
		    //float clamped = max(o.pos.z, 0.0);
		    float clamped = max(o.pos.z, -o.pos.w);
		    o.pos.z = lerp(o.pos.z, clamped, unity_LightShadowBias.y); 
		    o.hpos = o.pos;
		    o.uv=v.texcoord.xy;
		    return o;
		}
		
		float4 frag( v2f i ) : COLOR
		{
		    //SHADOW_CASTER_FRAGMENT(i)
		    float4 c=tex2D(_MainTex,i.uv);
		    return EncodeFloatRGBA( length(i.vec) *( _LightPositionRange.w)*_v*c.a);//.............
		}
		ENDCG

    }//endpass
	}
}


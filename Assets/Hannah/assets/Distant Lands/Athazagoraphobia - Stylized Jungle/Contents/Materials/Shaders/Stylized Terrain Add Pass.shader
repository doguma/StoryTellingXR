// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Terrain Add Pass"
{
	Properties
	{
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		[HideInInspector]_Specular0("Specular0", Color) = (0,0,0,0)
		[HideInInspector]_Specular2("Specular2", Color) = (0,0,0,0)
		[HideInInspector]_Specular3("Specular3", Color) = (0,0,0,0)
		[HideInInspector]_Specular1("Specular1", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest-99" "IgnoreProjector"="True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#define TERRAIN_SPLAT_ADDPASS
		#define TERRAIN_STANDARD_SHADER
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma surface surf Standard keepalpha  decal:add
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Mask2;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask1;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapScale1;
		uniform float4 _MaskMapRemapOffset0;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset3;
		uniform sampler2D _Mask3;
		uniform float4 _MaskMapRemapScale3;
		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform sampler2D _Normal0;
		uniform sampler2D _Splat0;
		uniform float4 _Splat0_ST;
		uniform sampler2D _Normal1;
		uniform sampler2D _Splat1;
		uniform float4 _Splat1_ST;
		uniform sampler2D _Normal2;
		uniform sampler2D _Splat2;
		uniform float4 _Splat2_ST;
		uniform sampler2D _Normal3;
		uniform sampler2D _Splat3;
		uniform float4 _Splat3_ST;
		uniform float _Smoothness0;
		uniform float4 _Specular0;
		uniform float _Smoothness1;
		uniform float4 _Specular1;
		uniform float _Smoothness2;
		uniform float4 _Specular2;
		uniform float _Smoothness3;
		uniform float4 _Specular3;
		uniform sampler2D _TerrainHolesTexture;
		uniform float4 _TerrainHolesTexture_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g69 = tex2D( _Control, uv_Control );
			float dotResult20_g69 = dot( tex2DNode5_g69 , float4(1,1,1,1) );
			float SplatWeight22_g69 = dotResult20_g69;
			float localSplatClip74_g69 = ( SplatWeight22_g69 );
			float SplatWeight74_g69 = SplatWeight22_g69;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight74_g69 == 0.0f ? -1 : 1);
			#endif
			}
			float4 SplatControl26_g69 = ( tex2DNode5_g69 / ( localSplatClip74_g69 + 0.001 ) );
			float4 temp_output_59_0_g69 = SplatControl26_g69;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g69 = temp_output_59_0_g69;
			float4 weightedBlend8_g69 = ( weightedBlendVar8_g69.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g69.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g69.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g69.w*tex2D( _Normal3, uv_Splat3 ) );
			float3 temp_output_61_0_g69 = UnpackNormal( weightedBlend8_g69 );
			o.Normal = temp_output_61_0_g69;
			float4 appendResult33_g69 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 tex2DNode4_g69 = tex2D( _Splat0, uv_Splat0 );
			float4 appendResult258_g69 = (float4(_Specular0.rgb , 1.0));
			float4 tintLayer0253_g69 = appendResult258_g69;
			float4 temp_output_35_0_g69 = ( appendResult33_g69 * tex2DNode4_g69 * tintLayer0253_g69 );
			float4 temp_output_2_0_g70 = temp_output_35_0_g69;
			float4 appendResult36_g69 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 tex2DNode3_g69 = tex2D( _Splat1, uv_Splat1 );
			float4 appendResult261_g69 = (float4(_Specular1.rgb , 1.0));
			float4 tintLayer1254_g69 = appendResult261_g69;
			float4 temp_output_38_0_g69 = ( appendResult36_g69 * tex2DNode3_g69 * tintLayer1254_g69 );
			float4 break20_g70 = temp_output_59_0_g69;
			float4 lerpResult14_g70 = lerp( temp_output_2_0_g70 , temp_output_38_0_g69 , ( break20_g70.g >= max( max( break20_g70.r , break20_g70.b ) , break20_g70.a ) ? 1.0 : 0.0 ));
			float4 appendResult39_g69 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 tex2DNode6_g69 = tex2D( _Splat2, uv_Splat2 );
			float4 appendResult263_g69 = (float4(_Specular2.rgb , 1.0));
			float4 tintLayer2255_g69 = appendResult263_g69;
			float4 temp_output_41_0_g69 = ( appendResult39_g69 * tex2DNode6_g69 * tintLayer2255_g69 );
			float4 lerpResult8_g70 = lerp( lerpResult14_g70 , temp_output_41_0_g69 , ( break20_g70.b >= max( max( break20_g70.r , break20_g70.g ) , break20_g70.a ) ? 1.0 : 0.0 ));
			float4 appendResult42_g69 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 tex2DNode7_g69 = tex2D( _Splat3, uv_Splat3 );
			float4 appendResult265_g69 = (float4(_Specular3.rgb , 1.0));
			float4 tintLayer3256_g69 = appendResult265_g69;
			float4 temp_output_44_0_g69 = ( appendResult42_g69 * tex2DNode7_g69 * tintLayer3256_g69 );
			float4 lerpResult13_g70 = lerp( lerpResult8_g70 , temp_output_44_0_g69 , ( break20_g70.a >= max( max( break20_g70.r , break20_g70.g ) , break20_g70.b ) ? 1.0 : 0.0 ));
			float4 MixDiffuse28_g69 = saturate( lerpResult13_g70 );
			float4 temp_output_60_0_g69 = MixDiffuse28_g69;
			float4 localClipHoles100_g69 = ( temp_output_60_0_g69 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g69 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g69 = holeClipValue99_g69;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g69 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = localClipHoles100_g69.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18909
165.5;95;907;461;1413.607;468.2071;3.060591;True;False
Node;AmplifyShaderEditor.FunctionNode;21;-607.0939,91.94017;Inherit;False;Four Splats First Pass Terrain;0;;69;37452fdfb732e1443b7e39720d05b708;2,102,1,85,0;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;7;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19;FLOAT3;17
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-70.20002,49.4;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Terrain Add Pass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;False;-99;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;28;-1;-1;-1;1;IgnoreProjector=True;False;0;0;False;-1;-1;0;False;-1;2;Define;TERRAIN_SPLAT_ADDPASS;False;;Custom;Define;TERRAIN_STANDARD_SHADER;False;;Custom;1;decal:add;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;21;0
WireConnection;0;1;21;14
ASEEND*/
//CHKSM=150BDB7FC648FA822F21E5CEB7AD07ECA5CA53C8
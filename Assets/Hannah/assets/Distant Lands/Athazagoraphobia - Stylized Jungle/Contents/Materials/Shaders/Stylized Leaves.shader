// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stlylized Leaves"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_AlphaClip("Alpha Clip", Float) = 1
		[HDR]_TopColor("Top Color", Color) = (0,0,0,0)
		[HDR]_BottomColor("Bottom Color", Color) = (0.3614275,0.5849056,0.3748917,0)
		_WindNoiseSize("Wind Noise Size", Float) = 0.1
		_GradientSmoothness("Gradient Smoothness", Float) = 0
		_WindStrength("Wind Strength", Float) = 1
		_GradientOffset("Gradient Offset", Float) = 0
		_WindSpeed("Wind Speed", Float) = 1
		_UpperLightTransmission("Upper Light Transmission", Float) = 0
		_WindDirection("Wind Direction", Vector) = (0,0,0,0)
		_FlutterAmount("Flutter Amount", Float) = 3
		_LowerLightTransmission("Lower Light Transmission", Float) = 0
		_FlutterScale("Flutter Scale", Float) = 0
		_FlutterSpeed("Flutter Speed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _FlutterSpeed;
		uniform float _WindSpeed;
		uniform float _FlutterScale;
		uniform float _FlutterAmount;
		uniform float3 _WindDirection;
		uniform float _WindNoiseSize;
		uniform float _WindStrength;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _AlphaClip;
		uniform float4 _BottomColor;
		uniform float4 _TopColor;
		uniform float _GradientOffset;
		uniform float _GradientSmoothness;
		uniform float _LowerLightTransmission;
		uniform float _UpperLightTransmission;


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 hsvTorgb101 = RGBToHSV( v.color.rgb );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime28 = _Time.y * 3.0;
			float2 uv_TexCoord29 = v.texcoord.xy + ( ase_worldPos + ( _FlutterSpeed * mulTime28 * _WindSpeed ) ).xy;
			float simplePerlin2D27 = snoise( uv_TexCoord29*_FlutterScale );
			float4 transform108 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult113 = (float2(( ( transform108.x + transform108.z ) / 10.0 ) , ( _WindSpeed * _Time.y )));
			float2 uv_TexCoord114 = v.texcoord.xy * float2( 0,0 ) + appendResult113;
			float simplePerlin2D122 = snoise( uv_TexCoord114*_WindNoiseSize );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_117_0 = ( _WindDirection * simplePerlin2D122 * ( 0.1 * ase_vertex3Pos.y ) );
			float3 MainWind124 = ( _WindStrength * temp_output_117_0 );
			float3 FinalWind126 = ( ( hsvTorgb101.z * simplePerlin2D27 * _FlutterAmount * temp_output_117_0 ) + MainWind124 );
			float3 worldToObjDir141 = mul( unity_WorldToObject, float4( FinalWind126, 0 ) ).xyz;
			v.vertex.xyz += worldToObjDir141;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode84 = tex2D( _Texture, uv_Texture );
			clip( tex2DNode84.a - _AlphaClip);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult13 = clamp( ( ( ase_vertex3Pos.y - _GradientOffset ) * _GradientSmoothness ) , 0.0 , 1.0 );
			float SunDirection97 = clampResult13;
			float4 lerpResult7 = lerp( _BottomColor , _TopColor , SunDirection97);
			o.Albedo = ( tex2DNode84 * lerpResult7 ).rgb;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult72 = lerp( ( ( _LowerLightTransmission * ase_lightColor ) * _BottomColor ) , ( ( _UpperLightTransmission * ase_lightColor ) * _TopColor ) , SunDirection97);
			o.Emission = ( tex2DNode84 * lerpResult72 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18909
15;145.5;772;593;5205.757;2573.874;6.092217;True;False
Node;AmplifyShaderEditor.CommentaryNode;107;-4159.107,1381.891;Inherit;False;2556.385;1135.515;;17;124;119;116;118;117;120;122;115;114;121;113;112;142;110;111;109;108;Wind Pass 1;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;108;-4080.264,1654.294;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;109;-3975.272,2111.253;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-3843.13,1734.128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-3994.671,1984.126;Inherit;False;Property;_WindSpeed;Wind Speed;8;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;142;-3693.701,1782.416;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-3722.758,1992.241;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-3528.412,1849.292;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;121;-3142.249,2186.285;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;-3329.531,1800.61;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-3322.024,1987.478;Inherit;False;Property;_WindNoiseSize;Wind Noise Size;4;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-4148.655,337.655;Inherit;False;2252.941;810.2963;;16;126;36;143;101;27;60;100;30;29;39;38;33;34;28;144;145;Wind Pass 2;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-4075.976,873.2702;Inherit;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;122;-3021.918,1820.781;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;119;-2796.179,1667.281;Inherit;False;Property;_WindDirection;Wind Direction;10;0;Create;True;0;0;0;False;0;False;0,0,0;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2709.295,2047.761;Inherit;False;2;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-4076.263,783.2023;Inherit;False;Property;_FlutterSpeed;Flutter Speed;14;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-2530.735,1806.765;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;38;-3889.44,624.4289;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-3846.972,830.8922;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2507.79,1568.3;Inherit;False;Property;_WindStrength;Wind Strength;6;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-3702.267,757.8762;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-2194.221,1599.14;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-2684.235,-2046.845;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-2672.811,-1867.762;Inherit;False;Property;_GradientOffset;Gradient Offset;7;0;Create;True;0;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-1863.174,1607.901;Inherit;False;MainWind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-3547.914,752.5209;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;100;-3273.021,463.2006;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-3526.373,999.8748;Inherit;False;Property;_FlutterScale;Flutter Scale;13;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2520.61,-1743.911;Inherit;False;Property;_GradientSmoothness;Gradient Smoothness;5;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-2454.603,-1931.525;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;101;-3092.447,467.9185;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-3225.842,744.8248;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2906.644,826.4692;Inherit;False;Property;_FlutterAmount;Flutter Amount;11;0;Create;True;0;0;0;False;0;False;3;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2250.944,-1885.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-2814.219,1047.43;Inherit;False;124;MainWind;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;74;-3582.873,-1529.707;Inherit;False;1016.464;1311.306;Lerp between two colors for the color of the leaves;13;7;72;21;16;98;23;1;19;6;17;22;18;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-2601.313,733.6399;Inherit;True;4;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;17;-3459.283,-1253.742;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;145;-2444.352,978.5878;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;13;-2086.443,-1936.091;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3504.872,-1380.209;Inherit;False;Property;_UpperLightTransmission;Upper Light Transmission;9;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3497.561,-864.0447;Inherit;False;Property;_LowerLightTransmission;Lower Light Transmission;12;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;22;-3465.286,-722.8598;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3231.949,-1262.763;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3237.952,-731.8823;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-2369.456,826.9582;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1817.772,-1925.523;Inherit;False;SunDirection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-3481.918,-1101.716;Inherit;False;Property;_TopColor;Top Color;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0.9895288,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-3472.227,-529.3893;Inherit;False;Property;_BottomColor;Bottom Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0.3614275,0.5849056,0.3748917,0;0.7254902,0.4747972,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3132.692,-1103.063;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-3172.166,-355.9932;Inherit;False;97;SunDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3157.389,-528.8862;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1823.514,-861.5269;Inherit;False;Property;_AlphaClip;Alpha Clip;1;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-1965.964,-1065.296;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;3d82b277f375b7c448230e39e7e4b28f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-2145.202,824.2262;Inherit;False;FinalWind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;72;-2810.151,-888.7062;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1685.648,-87.70827;Inherit;False;126;FinalWind;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClipNode;85;-1613.313,-925.8422;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;-2808.774,-665.8043;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1353.265,-767.9702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;141;-1435.37,-204.9131;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1363.52,-589.4005;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1175.457,-721.2207;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stlylized Leaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;0;108;1
WireConnection;111;1;108;3
WireConnection;142;0;111;0
WireConnection;112;0;110;0
WireConnection;112;1;109;0
WireConnection;113;0;142;0
WireConnection;113;1;112;0
WireConnection;114;1;113;0
WireConnection;122;0;114;0
WireConnection;122;1;115;0
WireConnection;120;1;121;2
WireConnection;117;0;119;0
WireConnection;117;1;122;0
WireConnection;117;2;120;0
WireConnection;33;0;34;0
WireConnection;33;1;28;0
WireConnection;33;2;110;0
WireConnection;39;0;38;0
WireConnection;39;1;33;0
WireConnection;118;0;116;0
WireConnection;118;1;117;0
WireConnection;124;0;118;0
WireConnection;29;1;39;0
WireConnection;12;0;8;2
WireConnection;12;1;11;0
WireConnection;101;0;100;0
WireConnection;27;0;29;0
WireConnection;27;1;30;0
WireConnection;9;0;12;0
WireConnection;9;1;10;0
WireConnection;36;0;101;3
WireConnection;36;1;27;0
WireConnection;36;2;60;0
WireConnection;36;3;117;0
WireConnection;145;0;143;0
WireConnection;13;0;9;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;23;0;20;0
WireConnection;23;1;22;0
WireConnection;144;0;36;0
WireConnection;144;1;145;0
WireConnection;97;0;13;0
WireConnection;16;0;19;0
WireConnection;16;1;6;0
WireConnection;21;0;23;0
WireConnection;21;1;1;0
WireConnection;126;0;144;0
WireConnection;72;0;21;0
WireConnection;72;1;16;0
WireConnection;72;2;98;0
WireConnection;85;0;84;0
WireConnection;85;1;84;4
WireConnection;85;2;86;0
WireConnection;7;0;1;0
WireConnection;7;1;6;0
WireConnection;7;2;98;0
WireConnection;88;0;85;0
WireConnection;88;1;72;0
WireConnection;141;0;127;0
WireConnection;87;0;85;0
WireConnection;87;1;7;0
WireConnection;0;0;87;0
WireConnection;0;2;88;0
WireConnection;0;11;141;0
ASEEND*/
//CHKSM=A99946986EF269310E71261C80C24656F7527B8E
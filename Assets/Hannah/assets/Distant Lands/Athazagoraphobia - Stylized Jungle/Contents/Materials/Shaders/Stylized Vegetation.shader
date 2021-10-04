// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Vegetation"
{
	Properties
	{
		_NoiseScale("Noise Scale", Float) = 1
		_BounceAmount("Bounce Amount", Float) = 1
		_Texture("Texture", 2D) = "white" {}
		_NoiseSpeed("Noise Speed", Float) = 1
		_AlphaClip("Alpha Clip", Float) = 1
		_SwayAmount("Sway Amount", Float) = 1
		[HDR]_TopColor("Top Color", Color) = (0,0,0,0)
		[HDR]_BottomColor("Bottom Color", Color) = (0.3614275,0.5849056,0.3748917,0)
		_GradientSmoothness("Gradient Smoothness", Float) = 0
		_GradientOffset("Gradient Offset", Float) = 0
		_UpperLightTransmission("Upper Light Transmission", Float) = 0
		_LowerLightTransmission("Lower Light Transmission", Float) = 0
		_MainWindSpeed("Main Wind Speed", Float) = 0
		_MainWindScale("Main Wind Scale", Float) = 0
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
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _BounceAmount;
		uniform float _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float _SwayAmount;
		uniform float _MainWindSpeed;
		uniform float _MainWindScale;
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


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break88 = ase_vertex3Pos;
			float3 appendResult89 = (float3(break88.x , 0.0 , break88.z));
			float4 transform90 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 appendResult71 = (float4(v.color.b , v.color.r , v.color.g , v.color.a));
			float4 normalizeResult11_g30 = normalize( appendResult71 );
			float3 hsvTorgb22_g30 = RGBToHSV( normalizeResult11_g30.rgb );
			float2 appendResult3_g30 = (float2(( _NoiseSpeed * _Time.y ) , ( ( transform90 * float4( 0.5,0.5,0.5,0 ) ).x + ( hsvTorgb22_g30.x * 100.0 ) )));
			float simplePerlin2D4_g30 = snoise( appendResult3_g30*_NoiseScale );
			float4 normalizeResult11_g29 = normalize( v.color );
			float3 hsvTorgb22_g29 = RGBToHSV( normalizeResult11_g29.rgb );
			float2 appendResult3_g29 = (float2(( _NoiseSpeed * _Time.y ) , ( transform90.x + ( hsvTorgb22_g29.x * 100.0 ) )));
			float simplePerlin2D4_g29 = snoise( appendResult3_g29*_NoiseScale );
			float3 rotatedValue24 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, normalize( float3( 0,1,0 ) ), ( ( simplePerlin2D4_g29 / 2.0 ) * _SwayAmount ) );
			float3 SubtleWind92 = ( ( float3(0,1,0) * distance( appendResult89 , float3( 0,0,0 ) ) * _BounceAmount * ( simplePerlin2D4_g30 / 2.0 ) ) + ( rotatedValue24 - ase_vertex3Pos ) );
			float4 transform104 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult100 = (float2(transform104.x , transform104.z));
			float simplePerlin2D91 = snoise( ( abs( appendResult100 ) + ( _Time.y * _MainWindSpeed ) )*_MainWindScale );
			simplePerlin2D91 = simplePerlin2D91*0.5 + 0.5;
			v.vertex.xyz += ( SubtleWind92 * simplePerlin2D91 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode45 = tex2D( _Texture, uv_Texture );
			clip( tex2DNode45.a - _AlphaClip);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult33 = clamp( ( ( ase_vertex3Pos.y - _GradientOffset ) * _GradientSmoothness ) , 0.0 , 1.0 );
			float SunDirection39 = clampResult33;
			float4 lerpResult48 = lerp( _BottomColor , _TopColor , SunDirection39);
			o.Albedo = ( tex2DNode45 * lerpResult48 ).rgb;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult46 = lerp( ( ( _LowerLightTransmission * ase_lightColor ) * _BottomColor ) , ( ( _UpperLightTransmission * ase_lightColor ) * _TopColor ) , SunDirection39);
			o.Emission = ( tex2DNode45 * lerpResult46 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
0;1080;2194;606;1764.52;309.3141;1.041298;True;False
Node;AmplifyShaderEditor.RangedFloatNode;27;-1664.852,-1251.726;Inherit;False;Property;_GradientOffset;Gradient Offset;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;26;-1676.276,-1430.81;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;90;-2513.564,1801.595;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-2370.39,1704.934;Inherit;False;Property;_NoiseScale;Noise Scale;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2370.333,1630.027;Inherit;False;Property;_NoiseSpeed;Noise Speed;3;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;63;-2186.66,1197.526;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;6;-2377.212,1462.771;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-2095.305,1745.416;Inherit;False;Property;_SwayAmount;Sway Amount;5;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;88;-2004.202,1197.878;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;105;-2154.615,1598.269;Inherit;False;VertexColorSway;-1;;29;84e5bf8746e63854c96b10ec528cd529;0;4;10;COLOR;0,0,0,0;False;7;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-1446.644,-1315.489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1512.651,-1127.875;Inherit;False;Property;_GradientSmoothness;Gradient Smoothness;8;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1242.985,-1269.664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-1893.202,1199.878;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-1862.314,1708.908;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-2461.016,-990.1154;Inherit;False;1016.464;1311.306;Lerp between two colors for the color of the leaves;13;51;48;46;43;42;41;40;38;37;36;35;34;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-2158.883,1415.399;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1857.177,1598.423;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2270.03,1805.983;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.5,0.5,0.5,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;33;-1078.484,-1320.055;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1770.247,1308.166;Inherit;False;Property;_BounceAmount;Bounce Amount;1;0;Create;True;0;0;0;False;0;False;1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;104;-1154.503,416.5203;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;75;-1750.868,1069.516;Inherit;False;Constant;_VectorY;Vector Y;12;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;34;-2383.015,-840.6173;Inherit;False;Property;_UpperLightTransmission;Upper Light Transmission;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;36;-2343.429,-183.2682;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;106;-1980.783,1410.199;Inherit;False;VertexColorSway;-1;;30;84e5bf8746e63854c96b10ec528cd529;0;4;10;COLOR;0,0,0,0;False;7;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2375.704,-324.4532;Inherit;False;Property;_LowerLightTransmission;Lower Light Transmission;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;32;-2337.427,-714.1503;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;62;-1719.441,1214.277;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;24;-1658.28,1574.592;Inherit;False;True;4;0;FLOAT3;0,1,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-1093.261,595.5598;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-2350.37,10.2021;Inherit;False;Property;_BottomColor;Bottom Color;7;1;[HDR];Create;True;0;0;0;False;0;False;0.3614275,0.5849056,0.3748917,0;0.02803489,0.2830189,0.04503381,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-809.8123,-1309.487;Inherit;False;SunDirection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-1118.261,673.5598;Inherit;False;Property;_MainWindSpeed;Main Wind Speed;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-1304.168,1653.972;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;40;-2360.062,-562.1243;Inherit;False;Property;_TopColor;Top Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.1344177,0.509434,0.1225525,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2116.095,-192.2908;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1540.808,1263.774;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2110.092,-723.1713;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;-964.5024,464.0203;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2035.532,10.70515;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2010.835,-563.4713;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-889.2606,587.5598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;102;-843.5024,504.5203;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-1061.921,1461.886;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2050.309,183.5982;Inherit;False;39;SunDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-1352.912,-449.4433;Inherit;True;Property;_Texture;Texture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-1210.462,-245.6744;Inherit;False;Property;_AlphaClip;Alpha Clip;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-831.2606,717.5598;Inherit;False;Property;_MainWindScale;Main Wind Scale;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1688.294,-349.1147;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-727.5024,528.5203;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-888.9463,1460.914;Inherit;False;SubtleWind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;48;-1686.917,-126.2128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClipNode;47;-1000.261,-309.9895;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;91;-576.7449,530.6915;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-534.3878,446.4088;Inherit;False;92;SubtleWind;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;52;-1220.249,-142.4389;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;53;-1226.753,-20.17215;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-740.2128,-152.1175;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-336.7682,482.4429;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-770.6404,-33.61302;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-175.2,-43.69999;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Distant Lands/Stylized Vegetation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;88;0;63;0
WireConnection;105;10;6;0
WireConnection;105;7;22;0
WireConnection;105;5;3;0
WireConnection;105;1;90;0
WireConnection;29;0;26;2
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;31;1;28;0
WireConnection;89;0;88;0
WireConnection;89;2;88;2
WireConnection;71;0;6;3
WireConnection;71;1;6;1
WireConnection;71;2;6;2
WireConnection;71;3;6;4
WireConnection;23;0;105;0
WireConnection;23;1;18;0
WireConnection;87;0;90;0
WireConnection;33;0;31;0
WireConnection;106;10;71;0
WireConnection;106;7;22;0
WireConnection;106;5;3;0
WireConnection;106;1;87;0
WireConnection;62;0;89;0
WireConnection;24;1;23;0
WireConnection;24;3;25;0
WireConnection;39;0;33;0
WireConnection;61;0;24;0
WireConnection;61;1;25;0
WireConnection;38;0;35;0
WireConnection;38;1;36;0
WireConnection;65;0;75;0
WireConnection;65;1;62;0
WireConnection;65;2;64;0
WireConnection;65;3;106;0
WireConnection;37;0;34;0
WireConnection;37;1;32;0
WireConnection;100;0;104;1
WireConnection;100;1;104;3
WireConnection;43;0;38;0
WireConnection;43;1;41;0
WireConnection;42;0;37;0
WireConnection;42;1;40;0
WireConnection;96;0;97;0
WireConnection;96;1;98;0
WireConnection;102;0;100;0
WireConnection;73;0;65;0
WireConnection;73;1;61;0
WireConnection;46;0;43;0
WireConnection;46;1;42;0
WireConnection;46;2;51;0
WireConnection;103;0;102;0
WireConnection;103;1;96;0
WireConnection;92;0;73;0
WireConnection;48;0;41;0
WireConnection;48;1;40;0
WireConnection;48;2;51;0
WireConnection;47;0;45;0
WireConnection;47;1;45;4
WireConnection;47;2;44;0
WireConnection;91;0;103;0
WireConnection;91;1;99;0
WireConnection;52;0;46;0
WireConnection;53;0;48;0
WireConnection;50;0;47;0
WireConnection;50;1;52;0
WireConnection;94;0;93;0
WireConnection;94;1;91;0
WireConnection;49;0;47;0
WireConnection;49;1;53;0
WireConnection;0;0;49;0
WireConnection;0;2;50;0
WireConnection;0;11;94;0
ASEEND*/
//CHKSM=B9F3A95ACB7EDADD1F91370E5FCFFAB2A234F35C
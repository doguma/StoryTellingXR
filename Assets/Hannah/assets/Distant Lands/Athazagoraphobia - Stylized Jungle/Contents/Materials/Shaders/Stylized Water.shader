// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stlylized Water"
{
	Properties
	{
		_SurfaceColor("Surface Color", Color) = (0,0,0,0)
		_WaterNormals("Water Normals", 2D) = "bump" {}
		_NormalDepth("Normal Depth", Float) = 0
		_DepthColor("Depth Color", Color) = (0,0,0,0)
		_AbsorptionStrength("Absorption Strength", Range( 0 , 10)) = 0
		_Murkiness("Murkiness", Range( 0 , 10)) = 0
		_FoamColor("Foam Color", Color) = (1,1,1,0)
		_Distortion("Distortion", Float) = 0.5
		_FoamScale("Foam Scale", Float) = 10
		_CausticScale("Caustic Scale", Float) = 0
		_CrestScale("Crest Scale", Float) = 0
		_CausticTexture("Caustic Texture", 2D) = "white" {}
		_WaveCrest("Wave Crest", 2D) = "white" {}
		_FoamScrollSpeed("Foam Scroll Speed", Float) = 1
		_CausticSpeed("Caustic Speed", Float) = 0
		_WaveColor("Wave Color", Color) = (0,0,0,0)
		_WaveCrestIntensity("Wave Crest Intensity", Range( 0 , 1)) = 0
		_CrestSpeed("Crest Speed", Float) = 0
		_CausticIntensity("Caustic Intensity", Float) = 0
		_FoamIntensity("Foam Intensity", Float) = 1
		_NormalScale("Normal Scale", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+100" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		ZWrite On
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard keepalpha exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform sampler2D _WaterNormals;
		uniform float _NormalScale;
		uniform float _NormalDepth;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float4 _DepthColor;
		uniform float4 _WaveColor;
		uniform sampler2D _WaveCrest;
		uniform float _CrestSpeed;
		uniform float _CrestScale;
		uniform float _WaveCrestIntensity;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Distortion;
		uniform float _AbsorptionStrength;
		uniform float4 _SurfaceColor;
		uniform sampler2D _CausticTexture;
		uniform float _CausticSpeed;
		uniform float _CausticScale;
		uniform float _CausticIntensity;
		uniform float _Murkiness;
		uniform float4 _FoamColor;
		uniform float _FoamScrollSpeed;
		uniform float _FoamScale;
		uniform float _FoamIntensity;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult374 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_377_0 = ( 1.0 / _NormalScale );
			float2 panner368 = ( 1.0 * _Time.y * float2( -0.03,0 ) + (appendResult374*temp_output_377_0 + 0.0));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth392 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth392 = abs( ( screenDepth392 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float lerpResult391 = lerp( _NormalDepth , 0.0 , saturate( ( 1.0 - ( _NormalScale * 0.03 * distanceDepth392 ) ) ));
			float2 panner369 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + (appendResult374*( temp_output_377_0 * 3.0 ) + 0.0));
			float3 depthNormals385 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormals, panner368 ), lerpResult391 ) , UnpackScaleNormal( tex2D( _WaterNormals, panner369 ), lerpResult391 ) );
			o.Normal = depthNormals385;
			float2 temp_output_350_0 = (ase_worldPos).xz;
			float2 panner101 = ( 1.0 * _Time.y * ( float2( -1,1 ) * float2( 1,1 ) * _CrestSpeed ) + temp_output_350_0);
			float temp_output_100_0 = ( 0.01 / _CrestScale );
			float2 panner108 = ( 1.0 * _Time.y * ( float2( 1.5,-0.5 ) * float2( 1,1 ) * _CrestSpeed ) + temp_output_350_0);
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float screenDepth14 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth14 = abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float temp_output_8_0 = exp2( ( distanceDepth14 * -_AbsorptionStrength ) );
			float temp_output_11_0 = ( 1.0 - temp_output_8_0 );
			float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( depthNormals385 * _Distortion * temp_output_11_0 ) ).xy);
			float2 temp_output_358_0 = (ase_worldPos).xz;
			float2 panner145 = ( 1.0 * _Time.y * ( float2( -0.2,0 ) * float2( 15,15 ) * _CausticSpeed ) + temp_output_358_0);
			float temp_output_142_0 = ( 1.0 / _CausticScale );
			float2 panner146 = ( 1.0 * _Time.y * ( float2( 0.2,-0.1 ) * float2( 15,15 ) * _CausticSpeed ) + temp_output_358_0);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float clampResult19 = clamp( ( temp_output_8_0 / _Murkiness ) , 0.0 , 1.0 );
			float4 lerpResult17 = lerp( ( _DepthColor + ( _WaveColor * ( min( tex2D( _WaveCrest, (panner101*temp_output_100_0 + 0.0) ) , tex2D( _WaveCrest, (panner108*( 4.0 * temp_output_100_0 ) + 0.0) ) ).r > ( 1.0 - _WaveCrestIntensity ) ? 1.0 : 0.0 ) ) ) , ( ( screenColor1 - ( ( 1.0 - _SurfaceColor ) * temp_output_11_0 ) ) + ( min( tex2D( _CausticTexture, (panner145*( temp_output_142_0 * 0.01 ) + 0.0) ) , tex2D( _CausticTexture, (panner146*( temp_output_142_0 * 0.02 ) + 0.0) ) ) * _CausticIntensity * ase_lightColor ) ) , clampResult19);
			float temp_output_203_0 = ( ( 0.1 / _FoamScale ) * 2.0 );
			float simplePerlin3D196 = snoise( float3( ( (ase_worldPos).xz + ( _Time.y * float2( -1,1 ) * _FoamScrollSpeed ) ) ,  0.0 )*temp_output_203_0 );
			simplePerlin3D196 = simplePerlin3D196*0.5 + 0.5;
			float simplePerlin3D209 = snoise( float3( ( (ase_worldPos).xz + ( _Time.y * _FoamScrollSpeed * float2( 1.5,-0.5 ) ) ) ,  0.0 )*( temp_output_203_0 * 2.0 ) );
			simplePerlin3D209 = simplePerlin3D209*0.5 + 0.5;
			float4 lerpResult364 = lerp( lerpResult17 , _FoamColor , ( ( 1.0 * min( simplePerlin3D196 , simplePerlin3D209 ) * _FoamIntensity ) > ( 1.0 - temp_output_8_0 ) ? 1.0 : 0.0 ));
			o.Albedo = lerpResult364.rgb;
			o.Smoothness = 1.0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
165.5;95;907;462;3472.244;106.7446;3.572838;True;False
Node;AmplifyShaderEditor.CommentaryNode;365;-2141.886,-2376.209;Inherit;False;2021.087;580.4468;Blend panning normals to fake noving ripples;19;385;372;370;371;367;369;368;376;373;375;374;377;391;392;394;395;396;397;398;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;392;-2051.849,-1924.058;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-2145.11,-2048.954;Inherit;False;Property;_NormalScale;Normal Scale;21;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;-1740.379,-1935.692;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;373;-2062.43,-2306.958;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;377;-1961.035,-2156.179;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;-1827.273,-2132.671;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;396;-1604.46,-1933.177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;374;-1870.594,-2270.7;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;376;-1673.991,-2279.13;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;367;-1522.443,-2006.201;Float;False;Property;_NormalDepth;Normal Depth;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;397;-1676.024,-2157.587;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;395;-1454.18,-1926.889;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;391;-1280.937,-1991.432;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;338;-6244.23,-116.7326;Inherit;False;2654.676;1066.229;Controls Wave Crest Decals;23;135;134;110;104;103;105;102;101;108;183;177;175;100;170;169;176;97;133;132;180;136;349;350;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3213.576,-729.2469;Inherit;False;Property;_AbsorptionStrength;Absorption Strength;5;0;Create;True;0;0;0;False;0;False;0;1.03;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;368;-1395.078,-2251.366;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;369;-1392.777,-2138.868;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-6168.433,669.4111;Inherit;False;Property;_CrestSpeed;Crest Speed;18;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;371;-1051.078,-2243.067;Inherit;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Instance;370;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;370;-1038.177,-2033.167;Inherit;True;Property;_WaterNormals;Water Normals;2;0;Create;True;0;0;0;False;0;False;-1;None;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;169;-6187.075,361.9513;Inherit;False;Constant;_CrestSpeed1;Crest Speed 1;19;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;10;-2892.054,-767.3133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;14;-3092.335,-924.1727;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;170;-6179.583,521.1192;Inherit;False;Constant;_CrestSpeed2;Crest Speed 2;19;0;Create;True;0;0;0;False;0;False;1.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;349;-6208.689,77.68319;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;97;-5953.235,798.437;Inherit;False;Property;_CrestScale;Crest Scale;11;0;Create;True;0;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;139;-3886.562,-1743.556;Inherit;False;Constant;_CausticVector1;Caustic Vector 1;12;0;Create;True;0;0;0;False;0;False;-0.2,0;0.01,0.004;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;138;-3891.537,-1459.491;Inherit;False;Property;_CausticSpeed;Caustic Speed;15;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-5831.323,397.3644;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;350;-5961.717,228.3375;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;372;-611.1747,-2098.568;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-3544.502,-1391.717;Inherit;False;Property;_CausticScale;Caustic Scale;10;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2743.111,-830.6972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;359;-3799.109,-1947.178;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-5833.429,525.3841;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;140;-3884.358,-1624.63;Inherit;False;Constant;_CausticVector2;Caustic Vector 2;12;0;Create;True;0;0;0;False;0;False;0.2,-0.1;0.01,0.004;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;-5711.407,738.8711;Inherit;False;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;108;-5605.229,484.4031;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;358;-3540.469,-1857.72;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3577.792,-1591.735;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;15,15;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-3577.836,-1713.962;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;15,15;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;142;-3296.727,-1448.948;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;385;-335.0729,-2099.213;Inherit;False;depthNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Exp2OpNode;8;-2566.646,-800.9084;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-5535.167,761.979;Inherit;False;2;2;0;FLOAT;4;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;384;-4328.414,-683.0389;Inherit;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;6;383;381;380;379;378;386;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;101;-5603.823,300.7496;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-2696.031,175.0888;Inherit;False;Property;_FoamScale;Foam Scale;9;0;Create;True;0;0;0;False;0;False;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;146;-3235.341,-1643.7;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;379;-4284.307,-623.681;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;102;-5362.365,248.7296;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;145;-3227.968,-1776.951;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;105;-5374.62,494.6502;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;197;-3302.526,-10.90146;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-3422.077,398.7757;Inherit;False;Property;_FoamScrollSpeed;Foam Scroll Speed;14;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;217;-3307.17,639.7548;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;356;-3272.566,-256.8128;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-3044.622,-1610.32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-3056.384,-1447.943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;202;-2682.001,250.7381;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;220;-3425.502,140.7375;Inherit;False;Constant;_FoamSpeed1;Foam Speed 1;19;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;378;-4227.976,-371.9097;Float;False;Property;_Distortion;Distortion;8;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;219;-3372.604,781.4751;Inherit;False;Constant;_FoamSpeed2;Foam Speed 2;19;0;Create;True;0;0;0;False;0;False;1.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;386;-4266.705,-452.5625;Inherit;False;385;depthNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;351;-3032.412,396.481;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;11;-2391.384,-843.5942;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-4837.84,241.7613;Inherit;True;Property;_WaveCrest;Wave Crest;13;0;Create;True;0;0;0;False;0;False;-1;None;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;104;-4837.641,481.0792;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;103;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;149;-2884.373,-1764.55;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;148;-2871.591,-1543.76;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-4720.743,116.0152;Inherit;False;Property;_WaveCrestIntensity;Wave Crest Intensity;17;0;Create;True;0;0;0;False;0;False;0;0.537;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-2671.006,-1072.347;Inherit;False;Property;_SurfaceColor;Surface Color;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.380392,1,0.895139,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;352;-3017.065,540.4695;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-3123.063,113.6534;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;355;-3050.739,-104.6468;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-3055.385,696.9936;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;383;-4001.543,-572.8809;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;380;-3907.412,-461.0388;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-2687.406,358.4222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;354;-2837.576,8.265647;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMinOpNode;110;-4484.397,334.4713;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;180;-4435.726,156.3702;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;381;-3754.313,-527.9389;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;151;-2603.266,-1790.985;Inherit;True;Property;_CausticTexture;Caustic Texture;12;0;Create;True;0;0;0;False;0;False;-1;None;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;353;-2803.904,653.3817;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;150;-2590.485,-1570.196;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;151;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-2687.585,456.933;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-2394.071,-1026.868;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2622.325,-582.7263;Inherit;False;Property;_Murkiness;Murkiness;6;0;Create;True;0;0;0;False;0;False;0;6.08;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;196;-2329.617,107.9051;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;1;-2197.488,-793.4714;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;132;-4093.169,-31.9875;Inherit;False;Property;_WaveColor;Wave Color;16;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4738341,0.7083009,0.8301887,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2167.261,-935.1252;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-2325.47,-1333.981;Inherit;False;Property;_CausticIntensity;Caustic Intensity;19;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;135;-4222.925,192.5035;Inherit;True;2;4;0;COLOR;0,0,0,0;False;1;FLOAT;0.745283;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;209;-2314.181,488.4021;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;187;-2313.037,-1232.017;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMinOpNode;152;-2210.889,-1652.9;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;362;-2834.672,-465.8484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-2022.067,-1343.928;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-1937.761,556.821;Inherit;False;Property;_FoamIntensity;Foam Intensity;20;0;Create;True;0;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;210;-1931.003,344.1906;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-3805.774,42.03719;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-1995.418,-817.6652;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;-2217.005,-442.9695;Inherit;False;Property;_DepthColor;Depth Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.211354,0.2352941,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-2335.98,-613.2263;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;360;-1782.752,-468.7943;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-1876.388,-1100.766;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;19;-2154.321,-581.2038;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-1714.916,233.3983;Inherit;True;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;361;-1634.475,60.16425;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-1480.799,-596.3593;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-1316.127,-93.20251;Inherit;False;Property;_FoamColor;Foam Color;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.6297169,0.8168723,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;221;-1312.624,254.9343;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-780.6512,229.0499;Inherit;False;Constant;_Smoothness;Smoothness;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;364;-907.2347,-68.20303;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;134;-4065.9,435.3544;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;387;-800.3076,143.084;Inherit;False;385;depthNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-546.0744,97.51329;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Distant Lands/Stlylized Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;1;False;-1;0;False;-1;False;0;Custom;0.5;True;False;100;True;Opaque;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;394;0;375;0
WireConnection;394;2;392;0
WireConnection;377;1;375;0
WireConnection;398;0;377;0
WireConnection;396;0;394;0
WireConnection;374;0;373;1
WireConnection;374;1;373;3
WireConnection;376;0;374;0
WireConnection;376;1;377;0
WireConnection;397;0;374;0
WireConnection;397;1;398;0
WireConnection;395;0;396;0
WireConnection;391;0;367;0
WireConnection;391;2;395;0
WireConnection;368;0;376;0
WireConnection;369;0;397;0
WireConnection;371;1;368;0
WireConnection;371;5;391;0
WireConnection;370;1;369;0
WireConnection;370;5;391;0
WireConnection;10;0;7;0
WireConnection;175;0;169;0
WireConnection;175;2;176;0
WireConnection;350;0;349;0
WireConnection;372;0;371;0
WireConnection;372;1;370;0
WireConnection;9;0;14;0
WireConnection;9;1;10;0
WireConnection;177;0;170;0
WireConnection;177;2;176;0
WireConnection;100;1;97;0
WireConnection;108;0;350;0
WireConnection;108;2;177;0
WireConnection;358;0;359;0
WireConnection;141;0;140;0
WireConnection;141;2;138;0
WireConnection;143;0;139;0
WireConnection;143;2;138;0
WireConnection;142;1;137;0
WireConnection;385;0;372;0
WireConnection;8;0;9;0
WireConnection;183;1;100;0
WireConnection;101;0;350;0
WireConnection;101;2;175;0
WireConnection;146;0;358;0
WireConnection;146;2;141;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;145;0;358;0
WireConnection;145;2;143;0
WireConnection;105;0;108;0
WireConnection;105;1;183;0
WireConnection;192;0;142;0
WireConnection;147;0;142;0
WireConnection;202;1;201;0
WireConnection;11;0;8;0
WireConnection;103;1;102;0
WireConnection;104;1;105;0
WireConnection;149;0;145;0
WireConnection;149;1;192;0
WireConnection;148;0;146;0
WireConnection;148;1;147;0
WireConnection;352;0;351;0
WireConnection;199;0;197;0
WireConnection;199;1;220;0
WireConnection;199;2;200;0
WireConnection;355;0;356;0
WireConnection;216;0;217;0
WireConnection;216;1;200;0
WireConnection;216;2;219;0
WireConnection;383;0;379;0
WireConnection;380;0;386;0
WireConnection;380;1;378;0
WireConnection;380;2;11;0
WireConnection;203;0;202;0
WireConnection;354;0;355;0
WireConnection;354;1;199;0
WireConnection;110;0;103;0
WireConnection;110;1;104;0
WireConnection;180;0;136;0
WireConnection;381;0;383;0
WireConnection;381;1;380;0
WireConnection;151;1;149;0
WireConnection;353;0;352;0
WireConnection;353;1;216;0
WireConnection;150;1;148;0
WireConnection;211;0;203;0
WireConnection;4;0;3;0
WireConnection;196;0;354;0
WireConnection;196;1;203;0
WireConnection;1;0;381;0
WireConnection;12;0;4;0
WireConnection;12;1;11;0
WireConnection;135;0;110;0
WireConnection;135;1;180;0
WireConnection;209;0;353;0
WireConnection;209;1;211;0
WireConnection;152;0;151;0
WireConnection;152;1;150;0
WireConnection;362;0;8;0
WireConnection;185;0;152;0
WireConnection;185;1;186;0
WireConnection;185;2;187;0
WireConnection;210;0;196;0
WireConnection;210;1;209;0
WireConnection;133;0;132;0
WireConnection;133;1;135;0
WireConnection;2;0;1;0
WireConnection;2;1;12;0
WireConnection;22;0;8;0
WireConnection;22;1;21;0
WireConnection;360;0;15;0
WireConnection;360;1;133;0
WireConnection;154;0;2;0
WireConnection;154;1;185;0
WireConnection;19;0;22;0
WireConnection;198;1;210;0
WireConnection;198;2;208;0
WireConnection;361;0;362;0
WireConnection;17;0;360;0
WireConnection;17;1;154;0
WireConnection;17;2;19;0
WireConnection;221;0;198;0
WireConnection;221;1;361;0
WireConnection;364;0;17;0
WireConnection;364;1;25;0
WireConnection;364;2;221;0
WireConnection;0;0;364;0
WireConnection;0;1;387;0
WireConnection;0;4;194;0
ASEEND*/
//CHKSM=F9E03F1F08BF7F374733B663248B69070D8000EC
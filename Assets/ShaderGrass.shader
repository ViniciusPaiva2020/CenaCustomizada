Shader "Unlit/ShaderGrass"
{
	Properties{

	}
	SubShader
	{
	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
	Pass
	{
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"



	float4 vec4(float x,float y,float z,float w) {
return float4(x,y,z,w);
}
float4 vec4(float x) {
return float4(x,x,x,x);
}
float4 vec4(float2 x,float2 y) {
return float4(float2(x.x,x.y),float2(y.x,y.y));
}
float4 vec4(float3 x,float y) {
return float4(float3(x.x,x.y,x.z),y);
}


float3 vec3(float x,float y,float z) {
return float3(x,y,z);
}
float3 vec3(float x) {
return float3(x,x,x);
}
float3 vec3(float2 x,float y) {
return float3(float2(x.x,x.y),y);
}

float2 vec2(float x,float y) {
return float2(x,y);
}
float2 vec2(float x) {
return float2(x,x);
}

float vec(float x) {
return float(x);
}



struct VertexInput {
float4 vertex : POSITION;
float2 uv:TEXCOORD0;
float4 tangent : TANGENT;
float3 normal : NORMAL;
//VertexInput
};
struct VertexOutput {
float4 pos : SV_POSITION;
float2 uv:TEXCOORD0;
//VertexOutput
};


VertexOutput vert(VertexInput v)
{
VertexOutput o;
o.pos = UnityObjectToClipPos(v.vertex);
o.uv = v.uv;
//VertexFactory
return o;
}

#define BLADES 6
#define BLADE_SEED 1.0

float4 grass(float2 p, float x)
{
	float s = 0.8;//lerp(0.7, 2.0, 0.5 + sin(x * 12.0) * 0.5);
	p.x += pow(1.0 + p.y, 2.0) * 0.1 * cos(x + _Time.y * 0.1);
	p.x *= s;
	p.y = (1.0 + p.y) * s - 1.0;
	float m = 1.0 - smoothstep(0.0, clamp(1.0 - p.y * 1.5, 0.01, 0.6) * 0.2 * s, pow(abs(p.x) * 19.0, 1.5) + p.y - 0.6);
	return vec4(lerp(vec3(0.05, 0.1, 0.0) * 0.8, vec3(0.0, 0.3, 0.0), (p.y + 1.0) * 0.5 + abs(p.x)), m * smoothstep(-1.0, -0.9, p.y));
}





	fixed4 frag(VertexOutput vertex_output) : SV_Target
	{

	float3 ct = vec3(0.0, 1.0, 5.0);
	float3 cp = vec3(0.0, 0.1, 0.0);
	float3 cw = normalize(cp - ct);
	float3 cu = cross(cw, vec3(0.0, 1.0, 0.0));
	float3 cv = cross(cu, cw);

	float2 uv = (vertex_output.uv / 1) * 2.0 - vec2(1.0);
	float2 t = uv;
	t.x *= 1 / 1;


	float3 ro = cp, rd = vec3(t, -1.1);

	float3 fcol = vec3(0.0);

	[unroll(100)]
for (int i = 0; i < BLADES; i++)
	{
		float z = -(float(BLADES - i) * 0.1 + 1.0);
		float4 pln = vec4(0.0, 0.0, -1.3, z);
		float2 tc = ro.xy + rd.xy;

		tc.x += cos(float(i) + BLADE_SEED);

		float cell = floor(tc.x);

		tc.x = (tc.x - cell) - 0.9;

		float4 c = grass(tc, float(i) + cell * 11.0);

		fcol = lerp(fcol, c.rgb, c.w);
	}

	fcol = pow(fcol * 1.1, vec3(0.8));

	float4 color = float4(fcol * 1.8, 1);

	return (color);
	//fragColor.rgb = fcol * 1.8;
	//fragColor.a = 1.0;

	}
	ENDCG
	}
	}
}

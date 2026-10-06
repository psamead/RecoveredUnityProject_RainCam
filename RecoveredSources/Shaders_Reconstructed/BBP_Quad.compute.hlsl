// ---- Created with 3Dmigoto v1.3.16 on Wed Oct  7 01:37:12 2026
struct u1_t {
  float val[6];
};
RWStructuredBuffer<u1_t> u1 : register(u1);

struct u0_t {
  float val[7];
};
RWStructuredBuffer<u0_t> u0 : register(u0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 256, 1, 1
  r0.x = u0[vThreadID.x].val[0/4];
  r0.y = u0[vThreadID.x].val[0/4+1];
  r0.z = u0[vThreadID.x].val[0/4+2];
  r0.w = u0[vThreadID.x].val[0/4+3];
  r1.x = u0[vThreadID.x].val[16/4];
  r1.y = u0[vThreadID.x].val[16/4+1];
  r1.z = u0[vThreadID.x].val[16/4+2];
  r2.x = -cb0[0].x + r1.z;
  r3.xy = cb0[0].yz;
  r3.zw = float2(0,0);
  r4.xyz = r3.xyw + -r0.xyz;
  r1.z = dot(r4.xyz, r4.xyz);
  r1.z = rsqrt(r1.z);
  r1.w = r0.w;
  r2.yzw = r4.xyz * r1.zzz + r1.wxy;
  r1.xyz = cb0[0].xxx * r2.yzw;
  r0.xyz = r1.xyz * float3(0.00999999978,0.00999999978,0.00999999978) + r0.xyz;
  r0.w = r2.y;
  u0[vThreadID.x].val[0/4] = r0.x;
  u0[vThreadID.x].val[0/4+1] = r0.y;
  u0[vThreadID.x].val[0/4+2] = r0.z;
  u0[vThreadID.x].val[0/4+3] = r0.w;
  u0[vThreadID.x].val[16/4] = r2.z;
  u0[vThreadID.x].val[16/4+1] = r2.w;
  u0[vThreadID.x].val[16/4+2] = r2.x;
  r1.x = cmp(r2.x < 0);
  if (r1.x != 0) {
    u0[vThreadID.x].val[0/4] = r3.x;
    u0[vThreadID.x].val[0/4+1] = r3.y;
    u0[vThreadID.x].val[0/4+2] = r3.z;
    u0[vThreadID.x].val[0/4+3] = r3.w;
    u0[vThreadID.x].val[16/4] = 0;
    u0[vThreadID.x].val[16/4+1] = 0;
    u0[vThreadID.x].val[16/4+2] = 4;
    r1.xy = cb0[0].yz;
    r0.z = 0;
    r2.x = 4;
  } else {
    r1.xy = r0.xy;
  }
  r1.z = (int)vThreadID.x * 6;
  r0.xy = -cb0[0].ww + r1.xy;
  u1[r1.z].val[0/4] = r0.x;
  u1[r1.z].val[0/4+1] = r0.y;
  u1[r1.z].val[0/4+2] = r0.z;
  u1[r1.z].val[20/4] = r2.x;
  r1.z = mad((int)vThreadID.x, 6, 1);
  r3.xy = cb0[0].ww + r1.yx;
  r0.w = r3.x;
  u1[r1.z].val[0/4] = r0.x;
  u1[r1.z].val[0/4+1] = r0.w;
  u1[r1.z].val[0/4+2] = r0.z;
  u1[r1.z].val[20/4] = r2.x;
  r1.xyzw = mad((int4)vThreadID.xxxx, int4(6,6,6,6), int4(2,3,4,5));
  r3.zw = r0.zy;
  u1[r1.x].val[0/4] = r3.y;
  u1[r1.x].val[0/4+1] = r3.x;
  u1[r1.x].val[0/4+2] = r3.z;
  u1[r1.x].val[20/4] = r2.x;
  u1[r1.y].val[0/4] = r0.x;
  u1[r1.y].val[0/4+1] = r0.y;
  u1[r1.y].val[0/4+2] = r0.z;
  u1[r1.y].val[20/4] = r2.x;
  u1[r1.z].val[0/4] = r3.y;
  u1[r1.z].val[0/4+1] = r3.x;
  u1[r1.z].val[0/4+2] = r3.z;
  u1[r1.z].val[20/4] = r2.x;
  u1[r1.w].val[0/4] = r3.y;
  u1[r1.w].val[0/4+1] = r3.w;
  u1[r1.w].val[0/4+2] = r3.z;
  u1[r1.w].val[20/4] = r2.x;
  return;
}
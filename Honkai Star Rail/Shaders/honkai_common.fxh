#pragma once

namespace Honkai {
    texture texNormals : NORMALS;
    sampler2D<float4> sNormals {
        Texture = texNormals; 
        MagFilter = POINT;
        MinFilter = POINT;
        MipFilter = POINT;
    };
    
    texture texNativeMotionVectors : MOTIONVECTORS;
    sampler sNativeMotionVectorTex { Texture = texNativeMotionVectors; };
    
    uniform float4x4 matView < source = "mat_View"; >;
   
    // https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/
    float2 _octWrap( float2 v )
    {
        //return ( 1.0 - abs( v.yx ) ) * ( v.xy >= 0.0 ? 1.0 : -1.0 );
        return float2((1.0 - abs( v.y ) ) * ( v.x >= 0.0 ? 1.0 : -1.0),
            (1.0 - abs( v.x ) ) * ( v.y >= 0.0 ? 1.0 : -1.0));
    }
    
    float2 _encode( float3 n )
    {
        n /= ( abs( n.x ) + abs( n.y ) + abs( n.z ) );
        n.xy = n.z >= 0.0 ? n.xy : _octWrap( n.xy );
        n.xy = n.xy * 0.5 + 0.5;
        return n.xy;
    }
    
    float3 _decode( float2 f )
    {
        f = f * 2.0 - 1.0;
        float3 n = float3( f.x, f.y, 1.0 - abs( f.x ) - abs( f.y ) );
        float t = saturate( -n.z );
        n.xy += n.xy >= 0.0 ? -t : t;
        return normalize( n );
    }
    
    float3 get_normal(float2 texcoord)
    {
        float4 normal = tex2Dlod(sNormals, float4(texcoord, 0, 0));
        float3x3 matV = float3x3(matView[0].xyz, matView[1].xyz, matView[2].xyz);
        
        float4 r0 = 0;
        float4 r1 = 0;
        float4 r2 = 0;
  
        normal.xy = normal.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
        normal.z = dot(float2(1.0, 1.0), abs(normal.xy));
        r1.z = 1.0 - normal.z;
        r2.xy = float2(1.0, 1.0) - abs(normal.yx);
        r2.xy = float2(normal.x >= 0 ? r2.x : -r2.x, normal.y >= 0 ? r2.y : -r2.y);
        normal.z = r1.z < 0 ? 1.000000 : 0;
        r2.xy = r2.xy + -normal.xy;
        r1.xy = normal.zz * r2.xy + normal.xy;
        normal.x = dot(r1.xyz, r1.xyz);
        normal.x = rsqrt(normal.x);
        r1.xyw = r1.xyz * normal.xxx;
        
        normal.rgb = mul(matV, r1.xyw);
        
        return normal.rgb;
    }
    
    float2 get_motion(float2 texcoord)
    {
        return tex2Dlod(sNativeMotionVectorTex, float4(texcoord, 0, 0)).rg;
    }
}
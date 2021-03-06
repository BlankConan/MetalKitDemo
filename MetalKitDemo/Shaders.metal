//
//  Shaders.metal
//  MetalKitDemo
//
//  Created by liugangyi on 2019/2/2.
//  Copyright © 2019年 liugangyi. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float4 color;
};

vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]], uint vid [[vertex_id]]) {
    return vertices[vid];
}

fragment float4 fragment_func(Vertex vert [[stage_in]]) {
    return vert.color;
}

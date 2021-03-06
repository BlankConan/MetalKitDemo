//
//  MKView.swift
//  MetalKitDemo
//
//  Created by liugangyi on 2019/2/2.
//  Copyright © 2019年 liugangyi. All rights reserved.
//

import UIKit
import MetalKit

struct Vertex {
    var position: vector_float4
    var color: vector_float4
};

class MKView: MTKView {
    
    var vertex_buffer: MTLBuffer!
    var rps: MTLRenderPipelineState! = nil
    
    
    
    override func draw() {
        super.draw()
        render()
    }
    
    func render() {
      
        device = MTLCreateSystemDefaultDevice();
        
        createBuffer()
        registerShaders()
        sendToGPU()
        
        let rpd = MTLRenderPassDescriptor()
        let bleen = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
        rpd.colorAttachments[0].texture = currentDrawable!.texture
        rpd.colorAttachments[0].clearColor = bleen
        rpd.colorAttachments[0].loadAction = .clear
        let commandQueue = device!.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let command_encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
        
        // 绘制三角形
        self.dingDianZhuoSeQi(command_encoder: command_encoder!)
        
        command_encoder?.endEncoding()
        commandBuffer?.present(currentDrawable!)
        commandBuffer?.commit()
        
        
        
        self.isPaused = true
        self.enableSetNeedsDisplay = false
    }


    // 创建数据
    func createBuffer() {
        let vertex_data = [Vertex(position: [-1.0, -1.0, 0.0, 1.0], color: [1, 0, 0, 1]),
                           Vertex(position: [1.0, -1.0, 0.0, 1.0], color: [0, 1, 0, 1]),
                           Vertex(position: [0.0, 1.0 , 0.0, 1.0], color: [0, 0, 1, 1])
                           ]
        vertex_buffer = device!.makeBuffer(bytes: vertex_data, length: MemoryLayout<Vertex>.size, options: [])
        
    }
    
    // 着色器
    func registerShaders() {
        let library = device!.makeDefaultLibrary()!
        let vertex_func = library.makeFunction(name: "vertex_func")
        let frag_func = library.makeFunction(name: "fragment_func")
        
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vertex_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try rps = device!.makeRenderPipelineState(descriptor: rpld)
        } catch let error {
            print("\(error)")
        }
    }
    
    // 提交到GPU
    func sendToGPU() {
        
        if let rpd = currentRenderPassDescriptor, let drawable = currentDrawable {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1.0)
            let command_buffer = device!.makeCommandQueue()?.makeCommandBuffer()!
            let command_encoder = command_buffer?.makeRenderCommandEncoder(descriptor: rpd)
            command_encoder?.setRenderPipelineState(rps)
            command_encoder?.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
            command_encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            command_encoder?.endEncoding()
            command_buffer?.present(drawable)
            command_buffer?.commit()
            
        }
        
    }
    
}

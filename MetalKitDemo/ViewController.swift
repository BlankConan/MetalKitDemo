//
//  ViewController.swift
//  MetalKitDemo
//
//  Created by liugangyi on 2019/2/2.
//  Copyright © 2019年 liugangyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        let mkview = MKView(frame: self.view.bounds)
        self.view.addSubview(mkview)
        
    }
}

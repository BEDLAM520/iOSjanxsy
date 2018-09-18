//
//  ViewController.swift
//  CoreAnimation
//
//  Created by  user on 2018/5/29.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var layerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        exampleTwo()
    }

    private func exampleTwo() {
        let image = UIImage(named: "cocacoola")
        layerView.layer.contents = image?.cgImage
        layerView.layer.contentsGravity = kCAGravityCenter
        layerView.layer.contentsScale = UIScreen.main.scale
        layerView.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
    }

    private func exampleOne() {

        // 注意查看两个层级关系

        let layer = CALayer()
        layer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        layerView.layer.addSublayer(layer)

        //        let subview = UIView()
        //        subview.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        //        subview.backgroundColor = UIColor.red
        //        layerView.addSubview(subview)
    }


}




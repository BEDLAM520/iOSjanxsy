//
//  CircleProgressView.swift
//  Animation
//
//  Created by  user on 2018/1/15.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {

    var drawColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let lineWidth: CGFloat = 5
        let boundscenter = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.width * 0.5)
        let radius = bounds.width * 0.5 - lineWidth
        let color = drawColor.cgColor
        // out
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setStrokeColor(color)

        // in
        let endangle = (progress + 0.0) * 2 * .pi
        context.addArc(center: boundscenter, radius: radius, startAngle: 0, endAngle: endangle, clockwise: false)
        context.strokePath()
    }

}

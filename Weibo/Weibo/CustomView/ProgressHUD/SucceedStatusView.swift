//
//  SucceedStatusView.swift
//  Animation
//
//  Created by  user on 2018/1/16.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class SucceedStatusView: UIView {

    var titleLabel: UILabel?
    var color = UIColor.cyan

    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 2
        addSubview(label)
        titleLabel = label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.frame = CGRect(x: 15, y: 90, width: frame.width - 30, height: 40)
    }

    func addSucceedAnimation() {

        let radius: CGFloat = 30
        let circleCenter = CGPoint(x: bounds.width * 0.5, y: 20 + radius)

        // circle
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round

        // ✅
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: circleCenter.x - 20, y: circleCenter.y))
        checkPath.addLine(to: CGPoint(x: circleCenter.x - 5, y: circleCenter.y + 15))
        checkPath.addLine(to: CGPoint(x: circleCenter.x + 20, y: circleCenter.y - 10))

        circlePath.append(checkPath)

        //add layer
        let alayer = CAShapeLayer()
        alayer.path = circlePath.cgPath
        alayer.fillColor = UIColor.clear.cgColor
        alayer.strokeColor = color.cgColor
        alayer.lineWidth = 3
        layer.addSublayer(alayer)

        // animation
        let animation = CABasicAnimation()
        animation.duration = 1.2
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        alayer.add(animation, forKey: "strokeEnd")
    }

}

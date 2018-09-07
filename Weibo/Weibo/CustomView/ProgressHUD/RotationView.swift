//
//  RotationView.swift
//  Animation
//
//  Created by  user on 2018/1/9.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class RotationView: UIView {

    private var backLayer: CALayer!
    private var circlelayer: CAShapeLayer!
    private var titleL: UILabel!
    private var leftgradientLayer: CAGradientLayer!
    private var rightgradientLayer: CAGradientLayer!

    var drawColor: UIColor? = UIColor.gray {
        didSet {
            setGlobalColors()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        settupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func leftColors() -> [CGColor] {
        return [drawColor!.withAlphaComponent(0.9).cgColor, drawColor!.withAlphaComponent(0.3).cgColor]
    }
    private func rightColors() -> [CGColor] {
         return [UIColor.white.cgColor, drawColor!.withAlphaComponent(0.3).cgColor]
    }

    private func setGlobalColors() {
        leftgradientLayer.colors = leftColors()
        rightgradientLayer.colors = rightColors()
        titleL.textColor = drawColor!.withAlphaComponent(0.5)
    }

    private func settupViews() {

        backLayer = CALayer()
        backLayer.frame = bounds
        backLayer.backgroundColor = UIColor.white.cgColor

        // circle
        let radius = (bounds.width - 5 ) * 0.5
        let ovalPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                    radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        let circlelayer = CAShapeLayer()
        circlelayer.path = ovalPath.cgPath
        circlelayer.frame = bounds
        circlelayer.strokeColor = UIColor.white.cgColor
        circlelayer.fillColor = UIColor.clear.cgColor
        circlelayer.lineWidth = 2
        circlelayer.lineCap = kCALineCapRound

        // gradient layer
        leftgradientLayer = CAGradientLayer()
        leftgradientLayer.shadowPath = ovalPath.cgPath
        leftgradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * 0.5, height: bounds.width)
        leftgradientLayer.startPoint = CGPoint(x: 0, y: 0)
        leftgradientLayer.endPoint = CGPoint(x: 0, y: 1)

        rightgradientLayer = CAGradientLayer()
        rightgradientLayer.shadowPath = ovalPath.cgPath
        rightgradientLayer.frame = CGRect(x: bounds.width * 0.5, y: 0, width: bounds.width * 0.5, height: bounds.width)
        rightgradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        rightgradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        // title
        titleL = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width * 0.7, height: bounds.width * 0.7))
        titleL.text = "¥"
        titleL.center = CGPoint(x: bounds.midX, y: bounds.midX)
        titleL.font = UIFont.systemFont(ofSize: 15)
        titleL.textAlignment = .center

        setGlobalColors()
        backLayer.addSublayer(leftgradientLayer)
        backLayer.addSublayer(rightgradientLayer)
        backLayer.mask = circlelayer
        layer.addSublayer(backLayer)
        addSubview(titleL)

        startLoading()
    }

    private func startLoading() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: .pi * 2.0)
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT
        backLayer.add(animation, forKey: "rotate-layer")
    }
}

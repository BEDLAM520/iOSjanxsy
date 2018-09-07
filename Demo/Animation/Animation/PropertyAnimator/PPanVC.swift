//
//  PPanVC.swift
//  Animation
//
//  Created by  user on 2018/8/29.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit

class PPanVC: UIViewController {
    
    var circleCenter: CGPoint!
    var circleAnimator: UIViewPropertyAnimator!
    let animationDuration = 4.0
    var circle: UIView!
    var state = 1
    
    deinit {
        print(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加可拖动视图
        circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green
        
        // 添加拖动手势
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
        
        self.view.addSubview(circle)
    }
    
    func settupAnimator() {
        switch state {
        case 2:
            circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)
        default:
            break
        }
    }
    
    @IBAction func normalMove(_ sender: Any) {
        state = 1
        settupAnimator()
    }
    
    @IBAction func boundsMove(_ sender: Any) {
        state = 2
        settupAnimator()
    }
    
    @IBAction func dampMove(_ sender: Any) {
        state = 3
        settupAnimator()
    }
    
    @objc func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch state {
        case 1:
            switch gesture.state {
            case .began, .ended:
                circleCenter = target.center
            case .changed:
                let translation = gesture.translation(in: self.view)
                target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            default: break
            }
        case 2:
            switch gesture.state {
            case .began, .ended:
                circleCenter = target.center
                
                let durationFactor = circleAnimator.fractionComplete // 记录完成进度
                // 在原始进度上增加新动画
                circleAnimator.stopAnimation(false)
                circleAnimator.finishAnimation(at: .current)
                
                if (gesture.state == .began) {
                    circleAnimator.addAnimations({
                        target.backgroundColor = UIColor.green
                        target.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    })
                } else {
                    circleAnimator.addAnimations({
                        target.backgroundColor = UIColor.green
                        target.transform = CGAffineTransform.identity
                    })
                }
                
                circleAnimator.startAnimation()
                circleAnimator.pauseAnimation()
                // 剩余时间完成新动画
                circleAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
            case .changed:
                let translation = gesture.translation(in: self.view)
                target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            default: break
            }
        case 3:
            switch gesture.state {
            case .began:
                if circleAnimator != nil && circleAnimator!.isRunning {
                    circleAnimator!.stopAnimation(false)
                }
                circleCenter = target.center
            case .changed:
                let translation = gesture.translation(in: self.view)
                target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            case .ended:
                let v = gesture.velocity(in: target)
                // 500 这个随机值看起来比较合适，你也可以基于设备宽度动态设置
                // y 轴的速度分量通常被忽略，不过操作视图中心时需要使用
                let velocity = CGVector(dx: v.x / 500, dy: v.y / 500)
                let springParameters = UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: velocity)
                circleAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
                
                circleAnimator!.addAnimations({
                    target.center = self.view.center
                })
                circleAnimator!.startAnimation()
            default: break
            }
        default:
            break
        }
    }
}

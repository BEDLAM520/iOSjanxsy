//
//  PSimpleMoveVC.swift
//  Animation
//
//  Created by  user on 2018/8/29.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit

class PSimpleMoveVC: UIViewController {

    @IBOutlet weak var moveView: UIView!
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var dampView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func action(_ sender: Any) {
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
            self.moveView.center = self.view.center
        }
        animator.addAnimations {
            self.moveView.alpha = 0
        }
        animator.startAnimation()
    }
    
    @IBAction func curveMoveAction(_ sender: Any) {
        let animator = UIViewPropertyAnimator(duration: 15, controlPoint1: CGPoint(x: 0.2, y: -0.48), controlPoint2: CGPoint(x: 0.79, y: 1.41)) {
            self.curveView.center = CGPoint(x: 50, y: 500)
        }
        animator.startAnimation()
    }
    
    @IBAction func dampAction(_ sender: Any) {
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5) {
            self.dampView.center = self.view.center
        }
        animator.startAnimation()
    }
    
    @IBAction func dampString(_ sender: Any) {
        let springTimingParameters = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0))
        let animator = UIViewPropertyAnimator(duration: 4.0, timingParameters: springTimingParameters)
        animator.addAnimations {
            self.dampView.center.x -= 150
        }
        animator.startAnimation()
    }
    
    @IBAction func circleMove(_ sender: Any) {
        let radius = CGFloat(100.0)
        let center = CGPoint(x: 150.0, y: 150.0)
        let animationDuration: TimeInterval = 3.0
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [.calculationModeLinear], animations: {
                let points = 1000
                let slice = 2 * CGFloat.pi / CGFloat(points)
                
                for i in 0..<points {
                    let angle = slice * CGFloat(i)
                    let x = center.x + radius * CGFloat(sin(angle))
                    let y = center.y + radius * CGFloat(cos(angle))
                    
                    let duration = 1.0/Double(points)
                    let startTime = duration * Double(i)
                    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: duration) {
                        self.dampView.center = CGPoint(x: x, y: y)
                    }
                }
            })
        }
        animator.startAnimation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

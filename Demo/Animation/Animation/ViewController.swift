//
//  ViewController.swift
//  Animation
//
//  Created by  user on 2018/1/9.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit
import WebKit
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/AdoptingCocoaDesignPatterns.html#//apple_ref/doc/uid/TP40014216-CH7-ID12

class ViewController: UIViewController {
    
    let cellIDF = "cellIDF"
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var dataArray = ["移动", "旋转", "动画组", "轨迹动画", "rect action",
                     "wraggle action", "Transform3D", "propertyAnimator", "", "", "", "", ""]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIDF)
    }

    @IBAction func showHud(_ sender: Any) {

    }
    
    
    @IBAction func hideHud(_ sender: Any) {

    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIDF, for: indexPath)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            positionAnimation()
        case 1:
            rotationAnimation()
        case 2:
            animationGroup()
        case 3:
            handPathAnimation()
        case 4:
            rectMove()
        case 5:
            waggleAction()
        case 6:
            ATransform3DAndCAKeyframeAnimation()
        case 7:
            let vc = PropertyAnimatorVC(nibName: "PropertyAnimatorVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
        
    }
}

// 基本动画
extension ViewController{
    
    // position
    func positionAnimation(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 2
        animation.repeatCount = 2
        animation.beginTime = CACurrentMediaTime() + 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.fromValue = NSValue(cgPoint: CGPoint(x: 10, y: 10))
        animation.toValue = NSValue(cgPoint: CGPoint(x: 200, y: 200))
        showView.layer.add(animation, forKey: "move-layer")
    }
    
    func rotationAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 2.5
        animation.repeatCount = 3
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: .pi * 10.0)
        showView.layer.add(animation, forKey: "rotate-layer")
    }
    
    func animationGroup(){
        let animation01 = CABasicAnimation(keyPath: "position")
        animation01.fromValue = NSValue(cgPoint: CGPoint(x: 10, y: 10))
        animation01.toValue = NSValue(cgPoint: CGPoint(x: 200, y: 200))
        
        let animation02 = CABasicAnimation(keyPath: "transform.rotation")
        animation02.fromValue = NSNumber(value: 0)
        animation02.toValue = NSNumber(value: .pi * 10.0)
        
        let animation03 = CABasicAnimation(keyPath: "transform.scale")
        animation03.fromValue = NSNumber(value: 1.0)
        animation03.toValue = NSNumber(value: 1.5)
        
        let group = CAAnimationGroup()
        group.duration = 3.0
        group.repeatCount = 5
        
        group.animations = [animation01,animation02,animation03]
        showView.layer.add(group, forKey: "group-layer")
    }
    
}

// 轨迹动画
extension ViewController {
    func handPathAnimation () {
        let ovalStartAngle = CGFloat(90.01 * .pi / 180.0)
        let ovalEndAngle = CGFloat(90 * .pi / 180.0)
        let ovalRect = CGRect(x: 97.5, y: 58.5, width: 125, height: 125)
        print(ovalRect.midX)
        print(ovalRect.maxY)
        
        let ovalPath = UIBezierPath()
        
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width, startAngle: ovalStartAngle, endAngle: ovalEndAngle, clockwise: true)
        
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.cgPath
        progressLine.strokeColor = UIColor.blue.cgColor
        progressLine.fillColor = UIColor.clear.cgColor
        progressLine.lineWidth = 10.0
        progressLine.lineCap = kCALineCapRound
        self.view.layer.addSublayer(progressLine)
        
        //        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        //        animateStrokeEnd.duration = 3.0
        //        animateStrokeEnd.fromValue = 0.0
        //        animateStrokeEnd.toValue = 1.0
        //        animateStrokeEnd.isRemovedOnCompletion = true
        //
        //        progressLine.add(animateStrokeEnd, forKey: "animite stroke")
        
    }
}

// 关键帧动画
extension ViewController{
    func rectMove(){
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 150, height: 150))
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path.cgPath
        animation.duration = 4
        animation.isAdditive = true
        animation.repeatCount = MAXFLOAT
        animation.calculationMode = kCAAnimationPaced
        
        animation.rotationMode = kCAAnimationRotateAuto
        showView.layer.add(animation, forKey: "ani")
        
    }
    
    func waggleAction(){
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        // values 是 any, 网上类似下面这段代码说这会在很多时间在类型检查上(我没有去测试)，所以swift的安全机制会报错，所以下面的正确使用姿势是先算出数组,而且要声明类型哦，在赋值
        // http://manjusaka.itscoder.com/2016/08/02/%E8%AF%A6%E8%A7%A3Swift%E7%9A%84%E7%B1%BB%E5%9E%8B%E6%A3%80%E6%9F%A5%E5%99%A8/
        let values:[NSNumber] = [NSNumber(value:0), NSNumber(value:10), NSNumber(value:-10), NSNumber(value:10), NSNumber(value:0)]
        let keyTimes = [NSNumber(value:0), NSNumber(value:1.0/6.0), NSNumber(value:3.0/6.0), NSNumber(value:4.0/6.0), NSNumber(value:1)]
        animation.values = values
        animation.keyTimes = keyTimes
        animation.duration  = 0.4
        animation.isAdditive = true
        
        showView.layer.add(animation, forKey: "an")
    }
    
    
    func ATransform3DAndCAKeyframeAnimation(){
        
        let keyAnim = CAKeyframeAnimation(keyPath: "transform")
        let rotaion1 = CATransform3DMakeRotation(30.0 * .pi / 180.0, 0, 0, -1)
        let rotaion2 = CATransform3DMakeRotation(60.0 * .pi / 180.0, 0, 0, -1)
        let rotaion3 = CATransform3DMakeRotation(90.0 * .pi / 180.0, 0, 0, -1)
        let rotaion4 = CATransform3DMakeRotation(120.0 * .pi / 180.0, 0, 0, -1)
        let rotaion5 = CATransform3DMakeRotation(150.0 * .pi / 180.0, 0, 0, -1)
        let rotaion6 = CATransform3DMakeRotation(180.0 * .pi / 180.0, 0, 0, -1)
        
        let values:[NSValue] = [NSValue(caTransform3D: rotaion1), NSValue(caTransform3D: rotaion2), NSValue(caTransform3D: rotaion3), NSValue(caTransform3D: rotaion4), NSValue(caTransform3D: rotaion5), NSValue(caTransform3D: rotaion6)]
        let keyTimes = [NSNumber(value:0.0), NSNumber(value:0.2), NSNumber(value:0.6), NSNumber(value:0.8), NSNumber(value:1.0)]
        keyAnim.values = values
        keyAnim.keyTimes = keyTimes
        keyAnim.duration = 4
        keyAnim.fillMode = kCAFillModeForwards
        keyAnim.isRemovedOnCompletion = false
        showView.layer.add(keyAnim, forKey: "an")
    }
    
    
}

//
//  NGCircleSlider.swift
//  CircleSlider
//
//  Created by liaonaigang on 2017/12/29.
//  Copyright © 2017年 ngliao. All rights reserved.
//

import UIKit

class NGCircleSlider: UIControl {
    
    fileprivate let lineWidth:CGFloat = 5
    var value:CGFloat = 0
    var angle:CGFloat = 180
    fileprivate var circleRadius:CGFloat = 0
    fileprivate let image = UIImage(named: "loan_circleball")
    fileprivate var startCenter = CGPoint.zero
    fileprivate var ballWidth:CGFloat = 0
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
//        circleRadius = self.frame.width * 0.5 - lineWidth * 2 - 1
//        startCenter = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - lineWidth - 5)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configViews()
    }
    
    fileprivate func configViews(){
        backgroundColor = UIColor.white
        ballWidth = lineWidth * 5
        circleRadius = self.frame.width * 0.5 - ballWidth * 0.5
        startCenter = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - ballWidth * 0.5)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        // backgroud
//        context?.addArc(center: startCenter, radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI) * 2.0, clockwise: false)
//        RGBA(240, 240, 240, 1).setStroke()
//        context?.setLineWidth(lineWidth)
//        context?.setLineCap(.round)
//        context?.drawPath(using: .stroke)
//
//
//        // progress
//        context?.addArc(center: startCenter, radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: ToRad(), clockwise: false)
//        APPMainColor.setStroke()
//        context?.drawPath(using: .stroke)
        
        // image
        let ballCenter = pointFromAngle()
        guard let dimage = image else {
            return
        }

        let rect = CGRect(x: ballCenter.x, y: ballCenter.y, width: ballWidth, height: ballWidth)
        dimage.draw(in: rect)
    }
    
    
    ///
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        
        if atBallRange(touchPoint) == false {
            return true
        }
        
        let canMove = ballMove(touchPoint)
        if canMove {
            self.sendActions(for: .valueChanged)
//            print("====\(angle)")
//            print("----\((angle - 180)/180)")
            value = (angle - 180)/180
        }
        return true
    }
}

extension NGCircleSlider{
    
    func setAngleByRatio(_ value: CGFloat){
        angle = value * 180 + 180
        setNeedsDisplay()
    }
    
    fileprivate func ToRad()->CGFloat{
        return CGFloat(M_PI) * angle / 180.0
    }
    
    fileprivate func pointFromAngle()->CGPoint{
        let centerPoint = CGPoint(x: self.frame.width * 0.5 - ballWidth * 0.5, y: self.frame.height - ballWidth)
        
        let x = centerPoint.x + circleRadius * cos(ToRad())
        let y = centerPoint.y + circleRadius * sin(ToRad())
        return CGPoint(x: x, y: y)
    }
    
    fileprivate func atBallRange(_ point: CGPoint)->Bool{
        let anglePoint = pointFromAngle()
        let distance = sqrt(pow(anglePoint.x - point.x, 2.0) + pow(anglePoint.y - point.y, 2.0))
        let addEdge:CGFloat = 10.0
        return distance < (ballWidth + addEdge)
    }
    
    fileprivate func ballMove(_ point: CGPoint)->Bool{
        var canMove = false
        
        //计算中心点到任意点的角度
        let currentAngle = angleOfCenterAndOnePoint(startCenter, point)
        var angleInt = floor(currentAngle);
        
        let leftEdge:CGFloat = 1
        let rightEdge:CGFloat = 2
        // 临界点
        if (angleInt >= 180 - leftEdge && angleInt <= 360) || (angleInt >= 0 && angleInt <= rightEdge){
            canMove = true
            if angleInt < 180 && angleInt > 170{
                angleInt = 180
            }
            if angleInt > 360{
                angleInt = 360
            }
            if angleInt >= 0 && angleInt <= rightEdge{
                angleInt = 360
            }
            angle = angleInt
            //重新绘制
            setNeedsDisplay()
        }
        
        if ((angleInt >= 180 - 1 && angleInt <= 360) || (angleInt >= 0 && angleInt <= 2)){
            canMove = true
            angle = angleInt
            //重新绘制
            setNeedsDisplay()
        }
        return canMove
    }
    
    fileprivate func angleOfCenterAndOnePoint(_ pointOne: CGPoint, _ pointTwo:CGPoint)->CGFloat{
        var point = CGPoint(x: pointTwo.x - pointOne.x, y: pointTwo.y - pointOne.y)
        let vmag = sqrt(pow(point.x, 2.0) + pow(point.y, 2.0));
        point.x /= vmag
        point.y /= vmag
        let radians = atan2(point.y,point.x)
        let result = ((180.0 * (radians)) / CGFloat(M_PI))
        return (result >= 0 ? result : result + 360.0)
    }
}

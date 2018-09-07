//
//  UIView+Extensions.swift
//  Loan123
//
//  Created by  user on 2017/12/12.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

extension UIView {
    
    public func addConstraint(item view1: UIView, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: UIView?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat) -> () {
        view1.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c))
    }
    
    public func addmoreEqualConstrain(item view1: UIView, toItem view2: UIView?, attribute attrs: NSLayoutAttribute...) -> () {
        view1.translatesAutoresizingMaskIntoConstraints = false
        for attr in attrs {
            addConstraint(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0))
        }
    }
    
    public func addFixedValueConstraint(item view: UIView, attribute attr: NSLayoutAttribute, constant c: CGFloat) -> () {
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: view, attribute: attr, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: c))
    }
}


extension UIView {
    
    public var width:CGFloat{
        get{
            return frame.width
        }
        set{
            var fm = self.frame
            fm.size.width = newValue
            self.frame = fm
        }
    }
    
    public var height:CGFloat{
        get{
            return frame.height
        }
        set{
            var fm = self.frame
            fm.size.height = newValue
            self.frame = fm
        }
    }
    
    public var top:CGFloat{
        get{
            return frame.origin.y
        }
        set{
            var fm = self.frame
            fm.origin.y = newValue
            self.frame = fm
        }
    }
    
    public var left:CGFloat{
        get{
            return frame.origin.x
        }
        set{
            var fm = self.frame
            fm.origin.x = newValue
            self.frame = fm
        }
    }
    
    public var bottom:CGFloat{
        get{
            return frame.origin.y + frame.height
        }
    }
    
    public var right:CGFloat{
        get{
            return frame.origin.x + frame.width
        }
    }
    
    public var centerX:CGFloat{
        get{
            return center.x
        }
        set{
            var cn = self.center
            cn.x = newValue
            self.center = cn
        }
    }
    
    public var centerY:CGFloat{
        get{
            return center.y
        }
        set{
            var cn = self.center
            cn.y = newValue
            self.center = cn
        }
    }
    
    public var size:CGSize{
        get{
            return frame.size
        }
        set{
            var fm = self.frame
            fm.size = newValue
            self.frame = fm
        }
    }
    
    public var viewController:UIViewController? {
        get{
            var view:UIView?
            var vc:UIViewController?
            
            view = self
            repeat{
                if let v = view {
                    let nextResponder = v.next
                    if let responder = nextResponder {
                        if responder.isKind(of: UIViewController.self) {
                            vc = responder as? UIViewController
                        }
                    }
                }
                view = view?.superview
            }while(view != nil)
            return vc
        }
    }
    

    public func removeAllSubViews(){
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
}

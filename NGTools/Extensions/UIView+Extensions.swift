//
//  UIView+Extensions.swift
//

import UIKit

extension UIView {
    
    // default constain function
    open func addConstraint(item view1: UIView, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, toItem view2: UIView?, attribute attr2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant c: CGFloat) -> () {
        view1.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c))
    }
    
    open func addmoreEqualConstrain(item view1: UIView, toItem view2: UIView?, attribute attrs: NSLayoutConstraint.Attribute...) -> () {
        view1.translatesAutoresizingMaskIntoConstraints = false
        for attr in attrs {
            addConstraint(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0))
        }
    }
    
    open func addFixedValueConstraint(item view: UIView, attribute attr: NSLayoutConstraint.Attribute, constant c: CGFloat) -> () {
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: view, attribute: attr, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: c))
    }
    
    
    // make constain function
    open func makeConstraint(attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, toItem view2: UIView?, attribute attr2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant c: CGFloat) -> () {
        if let superv = superview {
            translatesAutoresizingMaskIntoConstraints = false
            superv.addConstraint(NSLayoutConstraint(item: self, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c))
        }
        
    }
    
    open func makeMoreEqualConstrain(toItem view2: UIView?, attribute attrs: NSLayoutConstraint.Attribute...) -> () {
        if let superv = superview {
            translatesAutoresizingMaskIntoConstraints = false
            for attr in attrs {
                superv.addConstraint(NSLayoutConstraint(item: self, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0))
            }
        }
        
    }
    
    open func makeFixedValueConstraint(attribute attr: NSLayoutConstraint.Attribute, constant c: CGFloat) -> () {
        if let superv = superview {
            translatesAutoresizingMaskIntoConstraints = false
            superv.addConstraint(NSLayoutConstraint(item: self, attribute: attr, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: c))
        }
        
    }
    
}


extension UIView {
    
    open var width:CGFloat{
        get{
            return frame.width
        }
        set{
            var fm = self.frame
            fm.size.width = newValue
            self.frame = fm
        }
    }
    
    open var height:CGFloat{
        get{
            return frame.height
        }
        set{
            var fm = self.frame
            fm.size.height = newValue
            self.frame = fm
        }
    }
    
    open var top:CGFloat{
        get{
            return frame.origin.y
        }
        set{
            var fm = self.frame
            fm.origin.y = newValue
            self.frame = fm
        }
    }
    
    open var left:CGFloat{
        get{
            return frame.origin.x
        }
        set{
            var fm = self.frame
            fm.origin.x = newValue
            self.frame = fm
        }
    }
    
    open var bottom:CGFloat{
        get{
            return frame.origin.y + frame.height
        }
    }
    
    open var right:CGFloat{
        get{
            return frame.origin.x + frame.width
        }
    }
    
    open var centerX:CGFloat{
        get{
            return center.x
        }
        set{
            var cn = self.center
            cn.x = newValue
            self.center = cn
        }
    }
    
    open var centerY:CGFloat{
        get{
            return center.y
        }
        set{
            var cn = self.center
            cn.y = newValue
            self.center = cn
        }
    }
    
    open var size:CGSize{
        get{
            return frame.size
        }
        set{
            var fm = self.frame
            fm.size = newValue
            self.frame = fm
        }
    }
    
    open var viewController:UIViewController? {
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
    

    open func removeAllSubViews(){
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
}

extension UIView {
    func shake(){
        let frame = CAKeyframeAnimation(keyPath: "position.x")
        frame.duration = 0.3
        let x = self.layer.position.x
        frame.values = [(x + 30), (x - 30), (x + 20), (x - 20), (x + 10), (x - 10), (x + 5), (x - 5)]
        layer.add(frame, forKey: "position.x")
    }
}

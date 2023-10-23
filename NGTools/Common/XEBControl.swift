//
//  ZEBControl.swift
//  Loan123
//
//  Created by seirra on 2017/11/3.
//  Copyright © 2017年 Jason. All rights reserved.
//

import UIKit

class XEBControl {
    
    class func getImageView(name: String) ->UIImageView {
        
        let view :UIImageView = UIImageView()
        view.image = UIImage(named: name)
        return view
    }

    
    class func getLable(fontsize:CGFloat,textcolor:UIColor,textalign:NSTextAlignment) ->UILabel {
        
        let label :UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: fontsize)
        label.textColor = textcolor
        label.textAlignment = textalign
        
        return label
    }
    
    class func getUITextField(fontsize:CGFloat,textcolor:UIColor,placeholder:String) -> UITextField {
        
        let txt :UITextField = UITextField()
        txt.placeholder = placeholder
        txt.font = UIFont.systemFont(ofSize: fontsize)
        
        return txt
    }
    
    class func getUITextField(fontsize:CGFloat,placeholder:String) -> UITextField {
        
        let txt :UITextField = UITextField()
        txt.placeholder = placeholder
        txt.font = UIFont.systemFont(ofSize: fontsize)
        
        return txt
    }
    
    class func getButton(title:String,titlecolor:UIColor,fontsize:CGFloat,bgcolor:UIColor) -> UIButton {
        
        let btn : UIButton = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titlecolor, for: .normal)
        btn.backgroundColor = bgcolor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontsize)
        
        //btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        
        return btn
    }
    
    // 本app统一提交按钮风格
    class func xeb_getSubmitButton(title:String,target:Any?,selector:Selector) -> UIButton {
        
        let btn : UIButton = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = XEB_BUTTON_COLOR
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        btn.addTarget(target, action: selector, for: .touchUpInside)
        
        btn.roundCorners(radius: 5)
        
        return btn
    }


}

//
//  UIButton+Extensions.swift
//

import UIKit

extension UIButton {
    
    func roundCorners(radius: CGFloat) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
    
    func roundBorderCorners(radius: CGFloat,borderwidth:CGFloat,bordercolor:UIColor)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderwidth
        self.layer.borderColor = bordercolor.cgColor
    
    }
    
    func xzb_roundBorderCorners()
    {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = XEB_BUTTON_COLOR.cgColor
        
    }
    
    func xeb_ButtonNormal()
    {

        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
        //self.layer.borderColor = XEBCOLOR.cgColor
        self.layer.backgroundColor = XEB_BUTTON_COLOR.cgColor
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(XEB_BUTTON_SELECTED_TITLE_COLOR, for: .highlighted)
        
        let image = getImageWithColor(color: XEB_BUTTON_SELECTED_COLOR)
        self.setBackgroundImage(image, for: .highlighted)
    }
    
    func xeb_ButtonGrayNormal()
    {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
        //self.layer.borderColor = XEBCOLOR.cgColor
        self.layer.backgroundColor = XEB_BUTTON_GRAYCOLOR.cgColor
        self.setTitleColor(UIColor.orange, for: .normal)
        
        self.setBackgroundImage(nil, for: .highlighted)
    }
    
    func xeb_ButtonEnableNormal()
    {

        self.layer.backgroundColor = XEB_BUTTON_COLOR.cgColor
        
        let image = getImageWithColor(color: XEB_BUTTON_SELECTED_COLOR)
        self.setBackgroundImage(image, for: .highlighted)
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(XEB_BUTTON_SELECTED_TITLE_COLOR, for: .highlighted)
        
        self.isEnabled = true
    }
    
    func xeb_ButtonDisableNormal()
    {
        
        self.layer.backgroundColor = XEB_DISABLE_BGCOLOR.cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        
        self.setBackgroundImage(nil, for: .highlighted)
        
        self.isEnabled = false
    }
    
    /// 将颜色转换为图片
    ///
    /// - Parameter color: <#color description#>
    /// - Returns: <#return value description#>
    func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

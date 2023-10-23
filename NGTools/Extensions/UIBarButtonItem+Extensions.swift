//
//  UIBarButtonItem+Extensions.swift
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建 UIBarButtonItem
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize，默认 16 号
    /// - parameter target:   target
    /// - parameter action:   action
    /// - parameter isBack:   是否是返回按钮，如果是加上箭头
    ///
    /// - returns: UIBarButtonItem
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false) {
//        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        let btn = UIButton()

        if isBack {
            let imageName = "navigationbar_back_withtext"

//            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)

            btn.sizeToFit()
        }

        btn.addTarget(target, action: action, for: .touchUpInside)

        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
        self.init(customView: UIButton())
    }
}

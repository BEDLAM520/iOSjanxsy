//
//

import UIKit

/*
 该控制器配合全局隐藏原NavigationBar的导航控制器自定义NavigationBar
 */
class NGOpaqueBarViewController: NGBaseViewController {
    
    
    open var naviBar: UINavigationBar?
    open var navTitle: String? {
        didSet {
            if let navi = naviBar, let tempTitle = navTitle {
                let naviItem = UINavigationItem(title: tempTitle)
                navi.pushItem(naviItem, animated: false)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBar = UINavigationBar()
        naviBar?.barTintColor = APPMainColor
        naviBar?.isTranslucent = false;         // 重置解决该透明问题
        naviBar?.setBackgroundImage(UIImage(), for: .default)
        naviBar?.shadowImage = UIImage()
        view.addSubview(naviBar!)
        
        view.addmoreEqualConstrain(item: naviBar!, toItem: view, attribute: .top, .left, .right)
        view.addConstraint(item: naviBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navi = naviBar {
            view.bringSubviewToFront(navi)
        }
    }
    
}

//
//

import UIKit

class NGOpaqueNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()

        
        /// 解决自定义返回按钮导致侧滑返回被禁止问题
        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) == true {
            weak var weakself = self
            interactivePopGestureRecognizer?.delegate = weakself
            delegate = weakself
        }
    }
    
    public func resetDelegateToSelf(){
        /// 解决自定义返回按钮导致侧滑返回被禁止问题
        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) == true {
            weak var weakself = self
            interactivePopGestureRecognizer?.delegate = weakself
            delegate = weakself
        }
    }
    
    
}

extension NGOpaqueNavigationController{
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if animated == true {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        // 从第一页调整隐藏tabbar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if animated == true {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        interactivePopGestureRecognizer?.isEnabled = false
        return super.popToRootViewController(animated: animated)
    }
    
}

extension NGOpaqueNavigationController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer && viewControllers.count < 2 {
            return false
        }
        return true
    }
}

extension NGOpaqueNavigationController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

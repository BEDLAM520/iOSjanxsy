//
//

import UIKit

class XEBTabBarViewController: UITabBarController {

//    fileprivate lazy var userViewModel = GZUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取用户信息
//        userViewModel.getUserInformation()
        
        addViewControllers()
        
    }
}

extension XEBTabBarViewController{
    fileprivate func addViewControllers(){
//        let loanvc = GZLoanViewController()
//        addSubViewController(viewController: loanvc, title: "申请", imageName: "tabbar_借款")
//
//        let billvc = GZBillViewController()
//        addSubViewController(viewController: billvc, title: "账单", imageName: "tabbar_账单")
//
//        let myvc = GZProfileViewController(nibName: "GZProfileViewController", bundle: nil)
//        addSubViewController(viewController: myvc, title: "我的", imageName: "tabbar_我的")
    }
    
    fileprivate func addSubViewController(viewController: UIViewController, title: String, imageName: String){
        
        // 在这里设置viewcontroller的title，在viewcontroller里面会改不过来
//        let item = UITabBarItem()
//        item.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
//        item.selectedImage = UIImage(named: imageName.imageSelectedName)?.withRenderingMode(.alwaysOriginal)
//        item.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
//        item.setTitleTextAttributes([NSForegroundColorAttributeName: XEB_NAV_COLOR], for: .highlighted)
//        item.title = title
//        viewController.tabBarItem = item
//        
//        let nav = NGOpaqueNavigationController(rootViewController: viewController)
//        addChildViewController(nav)
    }
}

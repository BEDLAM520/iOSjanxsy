//
//  TabBarViewController.swift

//
//  Created by  user on 2017/12/19.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var homevc: HomeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        addViewControllers()
    }
}

extension TabBarViewController {
    fileprivate func addViewControllers() {
        homevc = HomeViewController(nibName: "HomeViewController", bundle: nil)
        addViewController(vc: homevc, title: "首页", imageName: "tabbar_home", selecteImageName: "tabbar_home_selected")

        let myvc = GZProfileViewController(nibName: "GZProfileViewController", bundle: nil)
        addViewController(vc: myvc, title: "我的", imageName: "tabbar_my", selecteImageName: "tabbar_my_selected")
    }

    private func addViewController(vc: UIViewController, title: String, imageName: String, selecteImageName: String) {

        // 在这里设置viewcontroller的title，在viewcontroller里面会改不过来
        let item = UITabBarItem()
        item.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = UIImage(named: selecteImageName)?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: appMainColor], for: .selected)
        item.title = title
        vc.tabBarItem = item

        let nav = OpaqueNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == 0 {
            homevc.startRefresh()
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let nav = viewController as? OpaqueNavigationController,
            let vc = nav.viewControllers.last as?  HomeViewController {
            vc.isClickTab = true
        }

        return true
    }
}

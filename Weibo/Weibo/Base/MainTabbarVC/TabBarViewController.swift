//
//  TabBarViewController.swift

//
//  Created by  user on 2017/12/19.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    private let visitorInfos = [["imageName": "", "message": "关注一些人，回这里看看有什么惊喜"],
                                ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]]
    override func viewDidLoad() {
        super.viewDidLoad()

        addViewControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }

    @objc func userLogin(n: Notification) {

        var when = DispatchTime.now()

        if n.object != nil {
            view.addStatusTextHUD("用户登陆已经超时，需要重新登陆")
            when = DispatchTime.now() + 2
        }

        DispatchQueue.main.asyncAfter(deadline: when) {
            let nav = OpaqueNavigationController(rootViewController: OuthVC())
            self.present(nav, animated: true, completion: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension TabBarViewController {
    func addViewControllers() {
        let homevc = HomeVC()
        homevc.visitorInfoDictionary = visitorInfos[0]
        addViewController(vc: homevc, title: "首页", imageName: "tabbar_home", selecteImageName: "tabbar_home_selected")

        let minevc = MineVC()
        minevc.visitorInfoDictionary = visitorInfos[1]
        addViewController(vc: minevc, title: "我的", imageName: "tabbar_profile", selecteImageName: "tabbar_profile_selected")
    }

    private func addViewController(vc: UIViewController, title: String, imageName: String, selecteImageName: String) {

        // 在这里设置viewcontroller的title，在viewcontroller里面会改不过来
        let item = UITabBarItem()
        item.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = UIImage(named: selecteImageName)?.withRenderingMode(.alwaysOriginal)
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .selected)
        item.title = title
        vc.tabBarItem = item

        let nav = OpaqueNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}



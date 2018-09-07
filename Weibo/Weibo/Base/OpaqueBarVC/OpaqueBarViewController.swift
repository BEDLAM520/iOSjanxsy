//
//  OpaqueBarViewController.swift

//
//  Created by  user on 2017/12/13.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit
import SnapKit


private var haveToGoAuth = false

/*
 该控制器配合全局隐藏原NavigationBar的导航控制器自定义NavigationBar
 */
class OpaqueBarViewController: BaseViewController {

    open var naviBar = BaseUINavigationBar()
    private var titleLabel = UILabel()
    open var navTitle: String? {
        didSet {
            titleLabel.text = navTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        haveToGoAuth = false
    }

    private func setupViews() {
        naviBar.barTintColor = naviBarColor
        naviBar.isTranslucent = false;         // 重置解决该透明问题
        naviBar.setBackgroundImage(UIImage(), for: .default)
        naviBar.shadowImage = UIImage()
        view.addSubview(naviBar)

        titleLabel.font = UIFont.systemFont(ofSize: naviBarTitleFontSize)
        titleLabel.textColor = naviBarTitleColor
        titleLabel.textAlignment = .center
        naviBar.addSubview(titleLabel)

        naviBar.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(statusNaviBarHeight)
        })

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(naviBar)
            make.bottom.equalTo(naviBar)
            make.height.equalTo(navigationBarHeight)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubview(toFront: naviBar)
    }
}

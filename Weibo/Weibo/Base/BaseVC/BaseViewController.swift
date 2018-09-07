//
//  BaseViewController.swift

//
//  Created by  user on 2017/12/13.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var backButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        addBackButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MARK: - 全局的设置，主要是处理连续摁按钮导致重复执行selector的问题
        view.isUserInteractionEnabled = true
    }

    deinit {
        printLog(self)
    }
}

extension BaseViewController {

    /// 添加自定义返回按钮
    func addBackButton() {

        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        backBtn.contentMode = .scaleAspectFit
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.setImage(UIImage(named: "navbar_icon_return"), for: .normal)
        backBtn.setImage(UIImage(named: "navbar_icon_return"), for: .highlighted)
        backBtn.addTarget(self, action: #selector(BaseViewController.backButtonAction), for: .touchUpInside)
        backButton = backBtn

        let lb = UIBarButtonItem(customView: backBtn)
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        navigationItem.leftBarButtonItems = [lb]
    }

    /// 隐藏返回按钮
    open func hiddenBackBtn() {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        navigationItem.leftBarButtonItems = [negativeSpacer]
        navigationItem.setHidesBackButton(true, animated: false)
    }

    @objc open func backButtonAction() {
        view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

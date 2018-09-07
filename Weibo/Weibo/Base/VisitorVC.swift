//
//  VisitorVC.swift
//  Weibo
//
//  Created by  user on 2018/6/28.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class VisitorVC: OpaqueBarViewController {

    var visitorInfoDictionary: [String: String]?
    override func viewDidLoad() {
        super.viewDidLoad()

        if SingletonData.shared.userLogon {
             setupContentViews()
            startLoadData()
        } else {
            setupVisitorView()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(WBUserLoginSuccessedNotification), object: nil)
    }

    func setupContentViews() {

    }
    
    func startLoadData() {

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        printLog(self)
    }
}

private extension VisitorVC {

    @objc func loginSuccess() {
        // 更新UI => 将访客视图替换为表格视图
        // 需要重新设置view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        NotificationCenter.default.removeObserver(self)
    }


    func setupVisitorView() {

        guard let visitorDict = visitorInfoDictionary else {
            return
        }

        let visitorView = VisitorView(frame: view.bounds);
        visitorView.visitorInfo = visitorDict
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        view.addSubview(visitorView)
    }


    @objc func login() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }

    @objc func register() {
        printLog("register")
    }
}


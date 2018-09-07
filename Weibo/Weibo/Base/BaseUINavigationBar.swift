//
//  BaseUINavigationBar.swift
//  ECWallet
//
//  Created by  user on 2018/1/19.
//  Copyright © 2018年 ECW. All rights reserved.
//

import UIKit

class BaseUINavigationBar: UINavigationBar {

    // 解决iOS11navibar向上偏移的问题
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11, *) {
            for item in subviews {
                if NSStringFromClass(item.classForCoder).contains("Background") {
                    item.frame = self.bounds
                } else if NSStringFromClass(item.classForCoder).contains("ContentView") {
                    item.frame = self.bounds
                }
            }
        }
    }

}

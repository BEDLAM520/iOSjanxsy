//
//  UIView+HUD.swift
//  ECWallet
//
//  Created by  user on 2018/1/18.
//  Copyright © 2018年 ECW. All rights reserved.
//

import UIKit

// MARK: - 在UIView上添加
extension UIView {

    /// 有指示器和状态信息的加载框
    ///
    /// - Parameters:
    ///   - title: 状态信息
    ///   - detailText: 详细信息
    func addIndicatorAndTextHUD(_ title: String?, _ detailText: String? = nil) {
        let hud = ProgressHUD.showHUDAdded(self, true)
        hud.mode = .indicatorAndText
        hud.labelText = title
        hud.detailsLabelText = detailText
    }

    /// 状态信息加载框
    ///
    /// - Parameter text: 状态信息
    func addStatusTextHUD(_ text: String?, _ delay: CGFloat = 2) {
        let hud = ProgressHUD(frame: bounds)
        addSubview(hud)
        hud.mode = .text
        hud.detailsLabelText = text
        hud.isUserInteractionEnabled = false
        hud.show(true)
        hud.hideAfterDelay(delay, true)
    }

    func hideAndAddStatusTextHUD(_ text: String?, _ delay: CGFloat = 2) {
        hideHUD()
        addStatusTextHUD(text, delay)
    }

    /// 小指示器加载框
    func addGrayHUD() {
        _ = ProgressHUD.showHUDAdded(self, true)
    }

    /// 大指示器加载框
    func addLargeWhiteHUD() {
        let hud = ProgressHUD.showHUDAdded(self, true)
        hud.mode = .largeWhiteIndicator
    }

    /// 成功状态加载框
    ///
    /// - Parameter text: 成功状态信息
    func addSucceedHUD(_ text: String, _ delay: CGFloat = 2.5) {
        let hud = ProgressHUD(frame: bounds)
        addSubview(hud)
        hud.mode = .succeedStatus
        hud.show(true)
        hud.addSucceedAnimation(text)
        hud.hideAfterDelay(delay, true)
    }

    /// 圆弧指示器加载框
    func addRotateHUD() {
        let hud = ProgressHUD(frame: bounds)
        addSubview(hud)
        hud.mode = .rotate
        hud.show(true)
    }

    /// 进度条加载框
    ///
    /// - Returns: 进度条加载框视图
    func addProgressHUD() -> ProgressHUD {
        let hud = ProgressHUD(frame: bounds)
        addSubview(hud)
        hud.mode = .progress
        hud.show(true)
        return hud
    }

    /// 自定义加载框视图
    ///
    /// - Parameter customView: 自定义加载框视图
    func addCustomViewHUD(_ customView: UIView) {
        let hud = ProgressHUD(frame: bounds)
        addSubview(hud)
        hud.customView = customView
        hud.mode = .customView
        hud.show(true)
    }

    /// 隐藏加载框
    func hideHUD() {
        _ = ProgressHUD.hideHUDForView(self, true)
    }
}

// MARK: - 在keywindow上添加
extension UIView {

    /// 在keywindow上添加指示器状态信息加载框
    ///
    /// - Parameters:
    ///   - title: 状态信息
    ///   - detailText: 详细信息
    class func windowAddIndicatorAndTextHUD(_ title: String?, _ detailText: String? = nil) {
        if let view = UIApplication.shared.keyWindow?.subviews.last {
            let hud = ProgressHUD.showHUDAdded(view, true)
            hud.mode = .indicatorAndText
            hud.labelText = title
            hud.detailsLabelText = detailText
        }
    }

    /// 大指示器加载框
    static func windowAddLargeWhiteHUD() {
        if let view = UIApplication.shared.keyWindow?.subviews.last {
            let hud = ProgressHUD.showHUDAdded(view, true)
            hud.mode = .largeWhiteIndicator
        }
    }

    /// 隐藏在keywindow上的加载框
    class func windowHideHUD() {
        if let view = UIApplication.shared.keyWindow?.subviews.last {
            _ = ProgressHUD.hideHUDForView(view, true)
        }
    }

    /// 在keywindow上添加状态信息加载框
    ///
    /// - Parameter text: 状态信息
    class func windowAdddStatusTextHUD(_ text: String?) {
        if let view = UIApplication.shared.keyWindow?.subviews.last {
            let hud = ProgressHUD(frame: view.bounds)
            view.addSubview(hud)
            hud.mode = .text
            hud.detailsLabelText = text
            hud.isUserInteractionEnabled = false
            hud.show(true)
            hud.hideAfterDelay(2, true)
        }
    }
}

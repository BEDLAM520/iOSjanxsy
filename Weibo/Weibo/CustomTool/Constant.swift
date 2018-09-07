//
//  Constant.swift
//  WeiboSwift
//
//  Created by  user on 2018/6/12.
//  Copyright © 2018年 nailiao. All rights reserved.
//

import UIKit


/// app主题色
let appMainColor = rgba(255, 102, 0)
/// 导航栏标题字体颜色
let naviBarTitleColor = UIColor.white
let naviBarTitleFontSize: CGFloat = 18
/// navibar Color
let naviBarColor = rgba(250, 141, 67)

let mainScreenBounds = UIScreen.main.bounds
/// 屏幕宽度
let screenWidth = mainScreenBounds.size.width
/// 屏幕高度
let screenHeight = mainScreenBounds.size.height


/// 状态栏高度
var statusBarHeight: CGFloat {
    return isIphoneX ? 44 : 20
}

/// 导航栏高度
var navigationBarHeight: CGFloat = 44

/// 状态栏和导航栏的高度
var statusNaviBarHeight: CGFloat {
    return statusBarHeight + navigationBarHeight
}

/// 标签栏高度
var tabBarHeight: CGFloat {
    return isIphoneX ? 83 : 49
}

/// 是否是iPhoneX
var isIphoneX: Bool {
    return screenHeight == 812
}


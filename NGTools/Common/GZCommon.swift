//
//  Define.swift
//  Loan123
//
//  Created by Jason on 2016/12/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit

let appName = "daikuan123"



//智齿客服appkey
let sobotKey = "25ef4eccb11b493f8aab558b322d4979"

let channelName = "appstore"


// MARK: - 常规宏定义
/// 当前系统版本
let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue
// 当前版本号
let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

//idfv标示符
let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""

/// 屏幕宽度
let screenWidth = UIScreen.main.bounds.size.width

/// 屏幕高度
let screenHeight = UIScreen.main.bounds.size.height

let isIphone5 = (screenHeight == 568)

let isIphone4 = (screenHeight == 480)

/// AppDelegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate

/// 状态栏高度
let statusBarHeight:CGFloat = 20

/// 导航条高度
let navigationBarHeight:CGFloat = 44.0

/// tabBar高度
let tabBarHeight:CGFloat = 49.0

/// 通知中心
let notice = NotificationCenter.default

/// UserDefaults
let userDefault = UserDefaults.standard

//AlertView
func showAlertView(title:String,message:String)
{
    let alert = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButton(withTitle: "好")
    alert.show()
}

func RGBA (_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat)->UIColor
{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


//按钮的显示状态
func btnStatus(btn:UIButton,str:String,isEnabled:Bool) {
    
    btn.isEnabled = isEnabled
    
    btn.setTitle(str, for: .normal)
    
    if isEnabled {
        
        btn.xeb_ButtonEnableNormal()
        //btn.setBackgroundImage(#imageLiteral(resourceName: "按钮-默认"), for: .normal)
        
    }else{
        
        btn.xeb_ButtonDisableNormal()
        //btn.setBackgroundImage(#imageLiteral(resourceName: "按钮-不可点击状态"), for: .normal)
        
    }
    
    btn.isEnabled = isEnabled
    
}




//MARK: - UserDefaults用到的key
let appToken = "appToken"

let appAccount = "account"

let appFirstUse = "firstUse"

let appLoanRecordId = "loanRecordId"

let appTimestamp = "timestamp"

let appDuration = "duration"

let appLoanMoney = "loanMoney"

let appMessageCenter = "messageCenter"

let appRefuseStatus = "refuseStatus"






//MARK: - 全局颜色
let GZOrange = UIColor(valueRGB: 0xf38d32, alpha: 1)

let GZBlue = UIColor(valueRGB: 0x40b4fd, alpha: 1)

let GZGreen = UIColor(valueRGB: 0x55d616, alpha: 1)

let GZRed = UIColor(valueRGB: 0xfc6753, alpha: 1)

let GZGray = UIColor(valueRGB: 0xe9eef0, alpha: 1)

let GZBlack = UIColor(valueRGB: 0x323232, alpha: 1)


//正式环境
let baseURL = "http://clientapi.fstom.com:8080"   // 服务器
//let baseURL = "http://192.168.0.143:8081"           // 本地
let h5URL = "http://resource.fstom.com"

fileprivate let TestPreUrl = "http://192.168.0.143:8081/app-domain/"
fileprivate let OnlinePreUrl = "http://clientapi.fstom.com:8080/app-domain/"
let PreUrl = OnlinePreUrl


let loanProductId = 22

let SMSType = 1

// 登陆返回的UserId
let AppUserId = userDefault.value(forKey: "AppUserId")

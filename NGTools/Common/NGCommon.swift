//
//  NGCommon.swift
//  NGTools
//
//  Created by liaonaigang on 2023/10/23.
//  Copyright © 2023 ngliao. All rights reserved.
//

import UIKit

let NaviBarTitleFontSize: CGFloat = 18
let NaviBarTitleColor = UIColor.white
let NaviBarBackColor = RGBA(219,184,110,1)

let APPMainColor = RGBA(220,185,105,1.0)
let APPMainTextColor = RGBA(51,51,51,1)



/// 自定义Log打印 -（T表示不指定日志信息参数类型）
///
/// - Parameters:
///   - message: 打印信息
///   - file: 打印文件
///   - method: 打印所在文件中的方法
///   - line: 打印所在文件的行
func printLog<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    
    #if DEBUG
        let classStr = (file as NSString).lastPathComponent as NSString
        let classSimpleStr = classStr.substring(to: classStr.length - 6)
        print("\(Date(timeIntervalSinceNow: 8 * 3600)) \(Bundle.main.namespace)[\(classSimpleStr).\(method).m:\(line)] \(message)")
    #endif
}


/// 保存图片
///
/// - Parameter imageData: 图片数据
func saveImageToDesktop(imageData: Data) {
    
    guard let path = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first else {
        return
    }
    
    let imagePath = path.appending("/LCDImages")
    
    
    if canWritePanelFile(path: imagePath) == true {
        
        let url = URL(fileURLWithPath: imagePath).appendingPathComponent("helloworld.png")
        
        do {
            try imageData.write(to: url, options: .atomic)
        } catch  {
            printLog(error.localizedDescription)
        }
        
    }
    
}



/// 判断是否存在某文件夹，无则创建
///
/// - Parameter path: 文件夹路径
/// - Returns: 判断结果
func canWritePanelFile(path: String) -> Bool{
    
    var canWrite = false
    
    if FileManager.default.fileExists(atPath: path) == false {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            canWrite = true
        } catch  {
            printLog(error.localizedDescription)
        }
    }else {
        canWrite = true
    }
    
    return canWrite
}




//
//  Common.swift
//  AVPlayer
//
//  Created by  user on 2018/9/3.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation


func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
    let classStr = (file as NSString).lastPathComponent as NSString
    let classSimpleStr = classStr.substring(to: classStr.length - 6)
    print("\(Date(timeIntervalSinceNow: 8 * 3600)) [\(classSimpleStr).\(method).m:\(line)] \(message)")
    #endif
}

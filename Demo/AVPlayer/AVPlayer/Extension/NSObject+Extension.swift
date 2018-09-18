//
//  NSObject+Extension.swift
//  AVPlayer
//
//  Created by  user on 2018/9/14.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

extension NSObject {
    func synchronized(lock: AnyObject, closure: @escaping () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}

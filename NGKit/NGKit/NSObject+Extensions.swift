//
//  NSObject+Extensions.swift
//  Loan123
//
//  Created by  user on 2017/12/12.
//  Copyright © 2017年 Spring. All rights reserved.
//

import UIKit

extension NSObject {
    
    public func synchronized(lock: AnyObject, closure: @escaping () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    
    /**
     Throung string get class (may be nil).
     */
    public func ClassFromString(_ classString:String) -> AnyClass? {
        return NSClassFromString(Bundle.main.namespace + "." + (classString as String))
    }
    
}

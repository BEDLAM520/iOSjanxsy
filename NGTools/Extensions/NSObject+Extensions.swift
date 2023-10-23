//
//  NSObject+Extensions.swift
//

import Foundation

extension NSObject {
    
    func synchronized(lock: AnyObject, closure: @escaping () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    
    /**
     Throung string get class (may be nil).
     */
    open func ClassFromString(_ classString:String) -> AnyClass? {
        return NSClassFromString(Bundle.main.namespace + "." + (classString as String))
    }
    
}

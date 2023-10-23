//
//  NotificationCenter+Extensions.swift
//

import Foundation

extension NotificationCenter{
    open func ngAddObserver(_ observer: Any, selector aSelector: Selector, name: String, object anObject: Any? = nil){
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: name), object: anObject)
    }
    
    open func ngpost(name: String, object anObject: Any? = nil){
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: anObject)
    }
}

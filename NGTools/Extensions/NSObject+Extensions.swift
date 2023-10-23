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
    
    /// 返回档期累的属性数组
    ///
    /// - Returns: 属性数组
    class func obj_PropertyList() -> [String] {
        var count:UInt32 = 0
        var array:[String] = []
        //  获取‘类’的属性列表，返回属性列表的数组，可选项
        let list = class_copyPropertyList(self, &count)
        for i in 0..<Int(count) {
            guard let pty = list?[i],
                let cName = String(utf8String: property_getName(pty)),
                let name = String(utf8String: cName)
                else {
                    continue
            }
            array.append(name)
        }
        
        free(list)
        
        return array
    }
    
    
    //FIXME:看 ivar 和 property 的区别
    
    /// 返回当前累的成员变量数组
    ///
    /// - Returns: 成员变量数组
    class func obj_IvarList() -> [String] {
        
        var array:[String] = []
        
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self, &count)
        
        for i in 0..<Int(count) {
            
            guard let ivar = ivars?[i],
                let cName = ivar_getName(ivar),
                let name = String(utf8String: cName)
                
                else {
                    continue
            }
            array.append(name)
        }
        
        return array
    }
    
}

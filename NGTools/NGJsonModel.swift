//
//  NGJsonModel.swift
//  Loan123
//
//  Created by liaonaigang on 2017/12/24.
//  Copyright © 2017年 Spring. All rights reserved.
//


/*
 Now basic type pro must to init
 */

import UIKit

class NGJsonModel: NSObject {
    required override init(){}
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}

//fileprivate var AttriToModelDict:[String: String]?

extension NGJsonModel{
    
    class func modelObjcOfJson(_ dict: [String: Any])->Any{
        let obj = self.init()
        obj.setValues(dict: dict)
//        resetAttrDict()
        return obj
    }
    
//    class func setAttriToModelDict(_ dict: [String: String]){
//        AttriToModelDict = dict
//    }
    
    class func arrayModelObjcOfJson<T>(_ dictionaries: [[String: Any]])->[T]{
        var tempArray = [Any]()
        for dict in dictionaries{
            let obj = self.init()
            obj.setValues(dict: dict)
            tempArray.append(obj)
        }
//        resetAttrDict()
        return tempArray as! [T]
    }
    
//    fileprivate class func resetAttrDict(){
//        AttriToModelDict = nil
//    }
    
    // 后面试一下 id ，description 关键字问题，数组和字典问题
    func allKeysDictionary(dict:[String:Any]) -> [String:String] {
        var newDict:[String:String] = [:]
        
        for key in dict.keys {
            newDict[key] = key;
        }
        
        return newDict
    }
    
    
    func setValues(dict:[String:Any]) -> () {
        
        let allKeys = allKeysDictionary(dict: dict)
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        
        for i in 0..<Int(count) {
            
            guard let ivar = ivars?[i],
                let cName = ivar_getName(ivar),
                let name = String(utf8String: cName),
                let key = allKeys[name],
                let value = dict[key]
                else {
                    continue
            }
            
            self.setValue(value, forKey: name)
            
                // dictionary
//                if let attrTypeName = AttriToModelDict?[name]{
//                    if let cls = ClassFromString(attrTypeName) {
//                        if cls.isSubclass(of: NGJsonModel.classForCoder()){
//                        printLog(cls)
//    
//                            let v = NGJsonModel.modelObjcOfJson(value as! [String: Any])
//                            setValue(v, forUndefinedKey: name)
////                            printLog(cls.init())
//                            
//                        }
//                    }
//                }else {
//                    printLog(key)
//                    self.setValue(value, forKey: name)
//                }
        }
        
    }
    
}

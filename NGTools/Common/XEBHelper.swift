//
//  FDHelper.swift
//  Loan123
//
//  Created by seirra on 2017/11/2.
//  Copyright © 2017年 Jason. All rights reserved.
//

import UIKit

class XEBHelper {

}

/// MARK 系统相关
extension XEBHelper{
    
    static func getUserDefaultValue(key:String) -> Any? {
        
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: key) as Any?
        
    }
    
    
    static func setUserDefaultValue(key:String,value:Any?) {
        
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
        
    }
    
    
    static func delUserDefaultValue(key:String) {
        
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        
    }
}

// MARK: 数值转换
extension XEBHelper{
    
    
    static func converString(string:String?,defaultString:String="") -> String {
        
        return string ?? defaultString
    }
    
    static func converInt(int:Int?,defaultInt:Int=0) -> Int {
        
        return int ?? defaultInt
    }
    
    //隐藏手机中间数字
    static func getStarMobile(mobile:String?)->(String)
    {
        if let mobile = mobile{
        
            if(isTelNumber(num: mobile as NSString) == true)
            {//手机号码符合要求
                let startIndex = mobile.index(mobile.startIndex, offsetBy:3)
                let endIndex = mobile.index(startIndex, offsetBy:4)
                return mobile.replacingCharacters(in: startIndex..<endIndex, with:"****")
            }
            
            return mobile
            
        }
        
        return ""
    }
    
   static func isTelNumber(num:NSString)->Bool
    {
        
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        
        /**
         
         * 中国移动：China Mobile
         
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         
         */
        
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        
        /**
         
         * 中国联通：China Unicom
         
         * 130,131,132,155,156,185,186,145,176,1709
         
         */
        
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        
        /**
         
         * 中国电信：China Telecom
         
         * 133,153,180,181,189,177,1700
         
         */
        
        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluate(with: num) == true)
            
            || (regextestcm.evaluate(with: num)  == true)
            
            || (regextestct.evaluate(with: num) == true)
            
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
}

extension XEBHelper{
   
    static func richMoenyText(string:String,key: String, fontsize : CGFloat) -> NSMutableAttributedString
    {
        let str = NSString(string: string)
        let range = str.range(of: key)
        
        let attr = XEBHelper.richText(str: string, range: range, fontsize: fontsize, fontcolor: .orange)
        return attr
    }
    
    static func richText(str:String,range:NSRange,fontsize:CGFloat,fontcolor:UIColor) -> NSMutableAttributedString {
        
        let attr = NSMutableAttributedString(string: str)
        
        //let newStr = str as NSString
        //let range = newStr.range(of: ".")
        
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: fontcolor, range: range)
        attr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontsize)], range: range)
        return attr
    }

}


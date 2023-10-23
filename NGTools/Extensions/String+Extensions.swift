//
//  String+Extensions.swift
//

import Foundation

extension String{
    
    public var imageSelectedName:String{
        get{
            return self + "_selected"
        }
    }
}


// 常用验证
extension String{
    static public func verifyName(_ str: String?)->String?{
        if let str = str {
//            if str.characters.count >= 2{
            if str.count >= 2{
                return str
            }
        }
        return nil
    }
}


extension String{
    static func moneyShow(_ value: Double)->String{
       return String(format: "%.2f", value)
    }
}

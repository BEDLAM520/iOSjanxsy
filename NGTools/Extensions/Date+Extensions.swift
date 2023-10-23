//
//  Date+Extensions.swift
//

import Foundation

/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
fileprivate let dateFormatter = DateFormatter()
/// 当前日历对象
fileprivate let calendar = Calendar.current

extension Date {
    
    /// 计算与当前系统时间偏差 delta 秒数的日期字符串
    /// 在 Swift 中，如果要定义结构体的 `类`函数，使用 static 修饰 -> 静态函数
    static func gz_dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: delta)
        
        // 指定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    
    
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
    */
    var gz_dateDescription: String {
        
        // 1. 判断日期是否是今天
        if calendar.isDateInToday(self) {
        
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        // 2. 其他天
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        // 设置日期格式字符串
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}

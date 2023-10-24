//
//  NSCalendar+Extension.h
//  有截止时间或起始时间的日期选择器
//
//  Created by iosDev on 16/6/29.
//  Copyright © 2016年 iosDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Extension)


/**
 获取当前的日期数据元件模型

 @param date date

 @return 当前的日期数据元件模型
 */
+ (NSDateComponents *)currentDateComponents:(NSDate *)date;


/**
 获取当前年

 @param date date

 @return 当前年
 */
+ (NSInteger)currentYear:(NSDate *)date;

/**
 获取当前月
 
 @param date date
 
 @return 当前月
 */
+ (NSInteger)currentMonth:(NSDate *)date;


/**
 获取当前天
 
 @param date date
 
 @return 当前天
 */
+ (NSInteger)currentDay:(NSDate *)date;


/**
 获取当前小时
 
 @param date date
 
 @return 当前小时
 */
+ (NSInteger)currentHour:(NSDate *)date;


/**
 获取当前分钟
 
 @param date date
 
 @return 当前分钟
 */
+ (NSInteger)currentMinute:(NSDate *)date;



/**
 获取当前年月

 @param date date

 @return 当前年月
 */
+ (NSString *)currentYearAndMonth:(NSDate *)date;

/**
 获取当前时间

 @param date date

 @return 当前时间
 */
+ (NSString *)currentTime:(NSDate *)date;


/**
 获取当前周
 
 @param date date
 
 @return 当前周
 */
+ (NSString *)currentWeekday:(NSDate *)date;


/**
 获取当天0点的时间戳

 @param date date

 @return 时间戳
 */
+ (NSTimeInterval)currentDayInterval:(NSDate *)date;


/**
 获取明天0点的时间戳

 @param date date

 @return 时间戳
 */
+ (NSTimeInterval)nextDayInterval:(NSDate *)date;

/**
 获取指定年月的天数

 @param year  year
 @param month month

 @return 天数
 */
+ (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month;

/**
 *  7.获取指定年月的第一天的周数
 */
+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year
                               month:(NSInteger)month;
/**
 *  8.比较两个日期元件
 */
+ (NSComparisonResult)compareWithComponentsOne:(NSDateComponents *)componentsOne
                                 componentsTwo:(NSDateComponents *)componentsTwo;

/**
 *  9.获取两个日期元件之间的日期元件
 */
+ (NSMutableArray *)arrayComponentsWithComponentsOne:(NSDateComponents *)componentsOne
                                       componentsTwo:(NSDateComponents *)componentsTwo;
/**
 *  10.字符串转日期元件 字符串格式为：yy-MM-dd
 */
+ (NSDateComponents *)dateComponentsWithString:(NSString *)String;


/**
 获取对应字符串的时间戳

 @param dateStr 日期字符串
 @return 时间戳
 */
+ (NSTimeInterval)intervalWithDateStr:(NSString *)dateStr;

//时间戳转字符串
+ (NSString *)dateStrWithInterval:(NSTimeInterval)interval type:(NSInteger)type;



+ (NSInteger)getAge:(NSTimeInterval)interval;

@end

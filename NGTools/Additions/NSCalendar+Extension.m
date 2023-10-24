//
//  NSCalendar+Extension.m
//  有截止时间或起始时间的日期选择器
//
//  Created by iosDev on 16/6/29.
//  Copyright © 2016年 iosDev. All rights reserved.
//

#import "NSCalendar+Extension.h"

@implementation NSCalendar (Extension)
+ (NSDateComponents *)currentDateComponents:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute;
    return [calendar components:unitFlags fromDate:date];
}

+ (NSInteger)currentMonth:(NSDate *)date
{
    return [NSCalendar currentDateComponents:date].month;
}

+ (NSInteger)currentYear:(NSDate *)date
{
    return [NSCalendar currentDateComponents:date].year;
}

+ (NSInteger)currentDay:(NSDate *)date
{
    return [NSCalendar currentDateComponents:date].day;
}

+ (NSInteger)currentHour:(NSDate *)date
{
    return [NSCalendar currentDateComponents:date].hour;
}

+ (NSInteger)currentMinute:(NSDate *)date
{
    return [NSCalendar currentDateComponents:date].minute;
}

+ (NSString *)currentYearAndMonth:(NSDate *)date
{
    NSInteger year = [self currentYear:date];
    NSInteger month = [self currentMonth:date];
    NSString *yearMonth = [NSString stringWithFormat:@"%ld/%ld", year, month];
    return yearMonth;
}


+ (NSString *)currentTime:(NSDate *)date
{
    NSInteger hour = [self currentHour:date];
    NSInteger minute = [self currentMinute:date];
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld",hour,minute];
    return time;
}


+ (NSString *)currentWeekday:(NSDate *)date
{
    NSInteger i = [NSCalendar currentDateComponents:date].weekday;
    NSString *week;
    switch (i) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break;
        case 7:
            week = @"周六";
            break;
        default:
            break;
    }
    return week;
}

+ (NSTimeInterval)currentDayInterval:(NSDate *)date
{
   NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.year = [self currentYear:date];
    components.month = [self currentMonth:date];
    components.day = [self currentDay:date];
    components.hour = 0;
    components.minute = 0;
    NSDate* newDate = [greCalendar dateFromComponents:components];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    return interval;
}

+ (NSTimeInterval)nextDayInterval:(NSDate *)date
{
    NSTimeInterval nextDayInterval = [self currentDayInterval:date]+24*60*60;
    return nextDayInterval;
}


+ (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month
{
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            if (year%400==0 || (year%100!=0 && year%4 == 0)) {
                return 29;
            }else{
                return 28;
            }
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}

+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year
                               month:(NSInteger)month
{
    NSString *stringDate = [NSString stringWithFormat:@"%ld-%ld-01", (long)year, (long)month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *date = [formatter dateFromString:stringDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    return [components weekday];
}

+ (NSComparisonResult)compareWithComponentsOne:(NSDateComponents *)componentsOne
                                 componentsTwo:(NSDateComponents *)componentsTwo
{
    if (componentsOne.year == componentsTwo.year &&
        componentsOne.month == componentsTwo.month &&
        componentsOne.day   == componentsTwo.day) {
        return NSOrderedSame;
    }else if (componentsOne.year < componentsTwo.year ||
              (componentsOne.year == componentsTwo.year && componentsOne.month < componentsTwo.month) ||
              (componentsOne.year == componentsTwo.year && componentsOne.month == componentsTwo.month && componentsOne.day < componentsTwo.day)) {
        return NSOrderedAscending;
    }else {
        return NSOrderedDescending;
    }
}

+ (NSMutableArray *)arrayComponentsWithComponentsOne:(NSDateComponents *)componentsOne
                                       componentsTwo:(NSDateComponents *)componentsTwo
{
    NSMutableArray *arrayComponents = [NSMutableArray array];
    
    NSString *stringOne = [NSString stringWithFormat:@"%ld-%ld-%ld", componentsOne.year,
                           componentsOne.month,
                           componentsOne.day];
    NSString *stringTwo = [NSString stringWithFormat:@"%ld-%ld-%ld", componentsTwo.year,
                           componentsTwo.month,
                           componentsTwo.day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:stringOne];
    NSDate *dateToString = [dateFormatter dateFromString:stringTwo];
    int timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970];
    
    NSTimeInterval timeInterval = [dateFromString timeIntervalSinceDate:dateFromString];
    
    for (int i = 0; i <= timediff; i+=86400) {
        timeInterval = i;
        NSDate *date = [dateFromString dateByAddingTimeInterval:timeInterval];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
        [arrayComponents addObject:[calendar components:unitFlags fromDate:date]];
    }
    return arrayComponents;
}

+ (NSDateComponents *)dateComponentsWithString:(NSString *)String
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *date = [formatter dateFromString:String];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    return  [calendar components:unitFlags fromDate:date];
}

+ (NSTimeInterval)intervalWithDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeIntervalSince1970]*1000;
}

+ (NSString *)dateStrWithInterval:(NSTimeInterval)interval type:(NSInteger)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (type == 1) {
        formatter.dateFormat = @"yyyy年MM月";
    }else if (type == 2) {
        formatter.dateFormat = @"yyyy-MM-dd";
    }else if (type == 3) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    return [formatter stringFromDate:date];
}


+ (NSInteger)getAge:(NSTimeInterval)interval
{
    NSDate *nowDate = [NSDate date];
    
    NSInteger currentYear = [self currentYear:nowDate];
    
    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSInteger birthday_year = [self currentYear:birthday];
    
    return currentYear-birthday_year;
}


@end

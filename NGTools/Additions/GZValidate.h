//
//  YDYValidate.h
//  YDYiOS
//
//  Created by xubin on 15/11/9.
//  Copyright © 2015年 fuminghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GZValidate : NSObject


///邮箱
+ (BOOL) validateEmail:(NSString *)email;

///手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

///电话号码验证
+(BOOL)validatePhone:(NSString *)phone;

///车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

///车型
+ (BOOL) validateCarType:(NSString *)CarType;

///用户名
+ (BOOL) validateUserName:(NSString *)name;

/**用户名判断：用户名首位不能为_或数字，2-16位且不能为纯数字**/
+ (BOOL) validateWithUserName:(NSString *)userName;


/** 数字与字母组合密码 **/
+ (BOOL)validatePWD:(NSString *)passWord;

///密码
+ (BOOL) validatePassword:(NSString *)passWord;  

/// 群昵称
+ (BOOL) validateGroupUserName:(NSString *)name;

///昵称
+ (BOOL) validateNickname:(NSString *)nickname;

///身份证号码
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
///精确身份证号码
+ (BOOL)validateIDCardNumber:(NSString *)value;

///验证纯数字
+ (BOOL)validateNumText:(NSString *)str;

///验证银行卡
+(BOOL)validateBankCardTextField:(NSString *)debitCard;

+ (NSString *)validationText:(UITextField *)textField;

@end

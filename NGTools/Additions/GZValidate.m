//
//  YDYValidate.m
//  YDYiOS
//
//  Created by xubin on 15/11/9.
//  Copyright © 2015年 fuminghui. All rights reserved.
//

#import "GZValidate.h"

@implementation GZValidate

static NSInteger const MAXLENGTH = 20;

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{

    if (mobile.length != 11) {
        return NO;
    }else{
        if (![[mobile substringToIndex:1] isEqualToString:@"1"]) {
            return NO;
        }
    }
    
    return YES;

}

//验证电话号
+(BOOL)validatePhone:(NSString *)phone{
    
    NSString *phoneRegex = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//登录用户名
//^[\w\u4E00-\u9FA5]+$
//
//当然，\w就是匹配数字、大小写字母、_的字符，\u4E00-\u9FA5这个匹配中文
//你也可以分别写也行
//^[0-9a-zA-Z_\u4E00-\u9FA5]+$
//4-16位
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[0-9a-zA-Z_\u4E00-\u9FA5]{2,16}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

/**
 *  修改用户名
 *
 *  @param userName
 */

//只含有汉字、数字、字母、下划线不能以下划线开头和结尾@"^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$"
+ (BOOL) validateWithUserName:(NSString *)userName{
    
    NSString* fist = @"^(?![0-9]+$).+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",fist];
    
    if (![userNamePredicate evaluateWithObject:userName]) {
        
        return NO;
    }
    
    NSString * second = @"^(?!_)(?![0-9]).+$";
    userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",second];
    if (![userNamePredicate evaluateWithObject:userName]) {
        
        return NO;
    }
    
    NSString* three = @"^[0-9a-zA-Z_\u4E00-\u9FA5]{2,16}+$";
    userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",three];
    
    if (![userNamePredicate evaluateWithObject:userName]) {
        
        return NO;
    }
    
    return YES;
}



/**
 群昵称

 @param name name
 @return BOOL
 */
+ (BOOL) validateGroupUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[0-9a-zA-Z_\u4E00-\u9FA5]{2,11}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


+ (BOOL)validatePWD:(NSString *)passWord {
  
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z]{6}";
    //    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z0-9]+$)(?!([0-9]+[^a-zA-Z0-9])+$)(?!([a-zA-Z]+[^a-zA-Z0-9])+$).{6,20}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    //    if ([passWordPredicate evaluateWithObject:passWord]) {
    //        passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    //        passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    //        YDYLog(@"yes");
    //        return [passWordPredicate evaluateWithObject:passWord];
    //    }
    
    return [passWordPredicate evaluateWithObject:passWord];
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
//    NSString *passWordRegex = @"^.{6,20}+$";
    //匹配 数字和字母 或字符 组成密码
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z0-9]+$).{6,20}";
//    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z0-9]+$)(?!([0-9]+[^a-zA-Z0-9])+$)(?!([a-zA-Z]+[^a-zA-Z0-9])+$).{6,20}+$";
  
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
//    if ([passWordPredicate evaluateWithObject:passWord]) {
//        passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
//        passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
//        YDYLog(@"yes");
//        return [passWordPredicate evaluateWithObject:passWord];
//    }
    
    return [passWordPredicate evaluateWithObject:passWord];
}



///精确身份证号
+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
         
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,6}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


///身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[Xx])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//是否是纯数字
+ (BOOL)validateNumText:(NSString *)str{
    NSString * regex        = @"(^[0-9]*$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
   return [pred evaluateWithObject:str];
}


+(BOOL)validateBankCardTextField:(NSString *)debitCard{
    BOOL flag;
    if (debitCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:debitCard];
}






+ (NSString *)validationText:(UITextField *)textField
{
    //不论中文英文,如果有空格,回车,都要过滤掉
    NSString *toBeString = [self disable_Text:textField.text];
    
    NSString *lang = [textField.textInputMode primaryLanguage];
    
//    NSLog(@"%@",lang);
    
    //判断输入法
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length>=MAXLENGTH) {
                NSString *strNew = [NSString stringWithString:toBeString];
                [textField setText:[strNew substringToIndex:MAXLENGTH]];
            }else{
                [textField setText:toBeString];
            }
        }
        else
        {
//            NSLog(@"输入的英文还没有转化为汉字的状态");
        }
        
    }
    else{
        if (toBeString.length > MAXLENGTH) {
            textField.text = [toBeString substringToIndex:MAXLENGTH];
        }else{
            textField.text = toBeString;
        }
    }
    
    return textField.text;
    
}


//过滤非法字符
+ (NSString *)disable_Text:(NSString *)text
{
//    NSLog(@"过滤--->%@",text);
    
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //过滤emoji表情
    return [self disable_emoji:text];
}

//过滤emoj表情
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


@end

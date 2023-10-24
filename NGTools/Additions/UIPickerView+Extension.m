//
//  UIPickerView+Extension.m
//  TWBLEShoe
//
//  Created by ChenJie on 2016/10/20.
//  Copyright © 2016年 T&W. All rights reserved.
//

#import "UIPickerView+Extension.h"

@implementation UIPickerView (Extension)

- (void)clearSpearatorLine
{
   [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
       if (obj.frame.size.height < 1){
           
           obj.backgroundColor = [UIColor clearColor];
       }

   }];
}

@end

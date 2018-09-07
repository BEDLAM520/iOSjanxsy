//
//  UIScrollView+LNScrollView.h
//  LNRefresh
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import <UIKit/UIKit.h>


//日志打印 可以关闭日志打印，提升运行效率
#define ONLOG 1 //日志打印开关
#if ONLOG
#define MMLog( s, ... )             NSLog( @"[%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] \
lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define                             MMLog( s, ... )
#endif



@interface UIScrollView (LNScrollView)
- (void)addRefreshBlock:(void(^)(void))completion;
@end

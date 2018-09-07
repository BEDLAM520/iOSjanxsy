//
//  UIScrollView+LNScrollView.m
//  LNRefresh
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "UIScrollView+LNScrollView.h"
#import <objc/runtime.h>


#define ContentOffSet @"contentOffset"


static char RefreshBlockKey;

@implementation UIScrollView (LNScrollView)

#pragma mark - 添加刷新
- (void)addRefreshBlock:(void(^)(void))completion {
    
    objc_setAssociatedObject(self, &RefreshBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
    [self addObserver:self forKeyPath:ContentOffSet options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([object isEqual:self]) {
        CGPoint new = [[change objectForKey:@"new"] CGPointValue];
        CGPoint old = [[change objectForKey:@"old"] CGPointValue];
        if (new.y == old.y) return;
        
        MMLog(@" %d -- %@  --- %@",[self viewController].navigationController.navigationBarHidden,NSStringFromCGPoint(new),NSStringFromCGPoint(old));
        
        CGFloat relativePosition = 0;
        
        
        if (new.y <= 0) {
            // 下拉逻辑
            
        }else {
            // 上拉逻辑
            
        }
    }
}



- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

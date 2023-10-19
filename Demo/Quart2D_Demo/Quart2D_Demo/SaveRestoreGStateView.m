//
//  SaveRestoreGStateView.m
//  Quart2D_Demo
//
//  Created by liaonaigang on 16/7/1.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "SaveRestoreGStateView.h"

@implementation SaveRestoreGStateView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 将ctx拷贝一份放到栈中
//    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 10);
    [[UIColor redColor] set];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // 1.第一根线
    CGContextMoveToPoint(ctx, 50, 250);
    CGContextAddLineToPoint(ctx, 250, 250);
    CGContextStrokePath(ctx);
    
    
    // 将栈定的上下文出栈，替换当前的上下文
//    CGContextRestoreGState(ctx);
    
    
    
    // 2、第二根线
    CGContextSetLineWidth(ctx,30);
    [[UIColor blueColor] set];
    CGContextMoveToPoint(ctx, 50, 300);
    CGContextAddLineToPoint(ctx, 250, 300);
    CGContextStrokePath(ctx);
    
    
    // 保存上下文
    CGContextSaveGState(ctx);
    
    // 3、第三根线
    CGContextSetLineWidth(ctx, 20);
    [[UIColor greenColor] set];
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextMoveToPoint(ctx, 50, 350);
    CGContextAddLineToPoint(ctx, 250, 350);
    CGContextStrokePath(ctx);
    
    
    // 通过这里出栈，可以知道的是，保存的上下文中包含了当前上下文中的绘图信心、状态
    CGContextRestoreGState(ctx);
    
    // 4、第四根线
    CGContextMoveToPoint(ctx, 50, 450);
    CGContextAddLineToPoint(ctx, 250, 450);
    CGContextStrokePath(ctx);
    
}

@end

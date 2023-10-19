//
//  ContextRefTransform.m
//  Quart2D_Demo
//
//  Created by liaonaigang on 16/7/1.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "ContextRefTransform.h"

@implementation ContextRefTransform


- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextRotateCTM(ctx, M_PI * 0.5);
    /**
     
     *  按x、y方向的比例进行伸缩
     */
//    CGContextScaleCTM(ctx, 1, 0.5);
    
    /**
     *  根据x、y增加的值平移
     */
//    CGContextTranslateCTM(ctx, 0, 200);
    
    /**
     *  //旋转（相对于原点（0，0））
     *  如何旋转可看Rotation.pdf
     */
    CGContextRotateCTM(ctx, -180 * M_PI / 180);
    
    CGContextAddRect(ctx, CGRectMake(150, 250, 20, 20));
    CGContextSetLineWidth(ctx, 5);
    [[UIColor redColor] set];
    CGContextStrokePath(ctx);
    
    
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
//    CGContextSaveGState(ctx);
    
//    CGContextRotateCTM(ctx, M_PI_4 * 0.3);
//    CGContextScaleCTM(ctx, 0.5, 0.5);
//    CGContextTranslateCTM(ctx, 0, 150);
//    
//    CGContextAddRect(ctx, CGRectMake(50, 150, 100, 100));
//    [[UIColor redColor] set];
//    CGContextStrokePath(ctx);
    
//    CGContextRestoreGState(ctx);
//    
//    CGContextAddEllipseInRect(ctx, CGRectMake(100, 100, 100, 100));
//    CGContextMoveToPoint(ctx, 100, 100);
//    CGContextAddLineToPoint(ctx, 200, 250);
    
    
    // 矩阵操作
    //    CGContextScaleCTM(ctx, 0.5, 0.5);
    
    CGContextStrokePath(ctx);
}


@end

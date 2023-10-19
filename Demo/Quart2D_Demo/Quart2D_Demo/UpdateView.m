//
//  UpdateView.m
//  Quart2D_Demo
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "UpdateView.h"

@interface UpdateView ()

@property (nonatomic,strong) NSArray *pieArray;

@end

@implementation UpdateView

- (NSArray *)pieArray {
    if (!_pieArray) {
        _pieArray = @[@{@"color":[UIColor redColor],@"value":@"0.05"},
                      @{@"color":[UIColor blueColor],@"value":@"0.15"},
                      @{@"color":[UIColor greenColor],@"value":@"0.2"},
                      @{@"color":[UIColor lightGrayColor],@"value":@"0.25"},
                      @{@"color":[UIColor blackColor],@"value":@"0.1"},
                      @{@"color":[UIColor orangeColor],@"value":@"0.1"},
                      @{@"color":[UIColor yellowColor],@"value":@"0.1"},
                      @{@"color":[UIColor purpleColor],@"value":@"0.05"}];
    }
    return _pieArray;
}



/**
 *  默认只会在view第一次显示的时候调用(只能由系统自动调用, 不能手动调用)
 */

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}


/*
 调用drawRect方法的时机：
 1.创建view时，系统会自动调用drawRect完成绘制
 2.drawRect不允许手动调用
 3.如果视图内容需要发生改变，也就是需要重绘视图时，绝对不能违反第二原则，只能通过给视图发setNeedsDisplay消息，来通知系统需要重绘
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGPoint center = CGPointMake(150, 150);
//    CGFloat radius = 100;
//    
//    CGContextMoveToPoint(ctx, center.x, center.y);
//    CGContextAddArc(ctx, center.x, center.y, radius, 3*M_PI_2, self.progress *2*M_PI+3*M_PI_2, NO);
//    CGContextClosePath(ctx);
//    
//    CGContextSetRGBFillColor(ctx, 1, 0, 1, 1);
//    
//
//    CGContextFillPath(ctx);
//    
//    [self drawPie:ctx];
    [self drawArcToPoint:ctx];
}


- (void)drawArcToPoint:(CGContextRef)ctx {
    
    CGContextMoveToPoint(ctx, 100, 100);
    CGContextAddArcToPoint(ctx, 100, 100, 200, 200 ,100);
//    CGContextAddArcToPoint(ctx, <#CGFloat x1#>, <#CGFloat y1#>, <#CGFloat x2#>, <#CGFloat y2#>, <#CGFloat radius#>)
    CGContextSetLineWidth(ctx, 5);
    CGContextSetRGBStrokeColor(ctx, 1, 0, 1, 1);
    CGContextStrokePath(ctx);

    
}

- (void)drawPie:(CGContextRef)ctx {
    
    
    /**
     *  需要注意的是由于iOS中的坐标体系是和Quartz坐标体系中Y轴相反的，所以iOS UIView在做Quartz绘图时，Y轴已经做了Scale为-1的转换，因此造成CGPathAddArc函数最后一个是否是顺时针的参数结果正好是相反的，也就是说如果设置最后的参数为YES，根据参数定义应该是顺时针的，但实际绘图结果会是逆时针的！
     */
    
    CGFloat firstAngle = 0;
    
    for (int i = 0; i < self.pieArray.count; i ++) {
        
        NSDictionary *dict = self.pieArray[i];
        
        CGContextAddArc(ctx, 150, 350, 50, firstAngle, 2 * M_PI * [dict[@"value"] floatValue] +firstAngle, NO);
        CGContextAddLineToPoint(ctx, 150, 350);
        CGContextClosePath(ctx);
        
        [dict[@"color"] setFill];
        
        CGContextFillPath(ctx);
        
        firstAngle += 2 * M_PI * [dict[@"value"] floatValue];
        
        
        
        
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path addArcWithCenter:CGPointMake(160, 200) radius:100 startAngle:firstAngle endAngle:([dict[@"value"] floatValue]*2*M_PI)+firstAngle clockwise:YES];
//        
//        [path addLineToPoint:CGPointMake(160, 200)];
//        [path closePath];
//        
//        
//        [dict[@"color"] setFill];
//        
//        [path fill];
//        
//        firstAngle += ([dict[@"value"] floatValue]*2*M_PI);
    }
}

@end

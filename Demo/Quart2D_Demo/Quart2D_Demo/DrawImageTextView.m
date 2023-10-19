//
//  DrawImageTextView.m
//  Quart2D_Demo
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "DrawImageTextView.h"

@implementation DrawImageTextView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"drawrect");
    
    
    drawImage();
//    drawText();
}



/**
 *  绘制图片
 */
void drawImage() {
    
    // 要裁减的图片
    UIImage *image = [UIImage imageNamed:@"images"];
    CGSize size = image.size;
 
    
    
    // 裁剪步骤
    // 1、获取 UIView 的图形上下文对象
    // 2、在上下文对象上绘制一个圆形路径
    // 3、执行裁剪操作（裁剪的意思是告诉系统，将来只有在被裁减出的区域内绘制的图形才会显示）
    // 4、把图片绘制到上下文上（直接调用 UIImage 对象的绘图方法即可）

    CGFloat radius = (size.width > size.height ? size.height : size.width ) * 0.5;
////    CGFloat radius = 50;
    CGPoint center = CGPointMake(40 + size.width * 0.5, 40 + size.height * 0.5);
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddArc(ctx, 40 + size.width * 0.5, 40 + size.height * 0.5, radius, 0, M_PI * 2, 1);
//    CGContextClip(ctx);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, center.x, center.y);
//    CGContextAddLineToPoint(ctx, center.x + radius, center.y);
    CGContextAddArc(ctx, center.x, center.y, radius, 0, 0.3 * M_PI * 2, YES);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
//    CGContextFillPath(ctx);
    
//    UIImage *image = [UIImage imageNamed:@"banner_zhu@2x"];
   
    

    // 利用drawAsPatternInRec方法绘制图片到layer, 是通过平铺原有图片
    //    [image drawAsPatternInRect:CGRectMake(40, 40, 200, 200 * (size.height / size.width))];
    //    [image drawAsPatternInRect:CGRectMake(40, 40, size.width, size.height)];
    
    
//    [image drawAtPoint:CGPointMake(10, 10)];
    
//    [image drawInRect:CGRectMake(40, 40, 200, 200 * (size.height / size.width))];
    [image drawInRect:CGRectMake(40, 40, size.width, size.height)];
//    [image drawInRect:CGRectMake(40, 40, size.width, size.height) blendMode:kCGBlendModeSourceAtop alpha:1];
    
    
    
    
//    kCGBlendModeNormal,              正常；也是默认的模式。前景图会覆盖背景图"
//    kCGBlendModeMultiply,            正片叠底；混合了前景和背景的颜色，最终颜色比原先的都暗"
//    kCGBlendModeScreen,              滤色；把前景和背景图的颜色先反过来，然后混合"
//    kCGBlendModeOverlay,             覆盖；能保留灰度信息，结合kCGBlendModeSaturation能保留透明度信息，在imageWithBlendMode方法中两次执行drawInRect方法实现我们基本需求";
    
//    kCGBlendModeDarken,              变暗
//    kCGBlendModeLighten,             变亮
//    kCGBlendModeColorDodge,          颜色变淡
//    kCGBlendModeColorBurn,           颜色加深
//    kCGBlendModeSoftLight,           柔光
//    kCGBlendModeHardLight,           强光
//    kCGBlendModeDifference,          插值
//    kCGBlendModeExclusion,           排除
//    kCGBlendModeHue,                 色调
//    kCGBlendModeSaturation,          饱和度
//    kCGBlendModeColor,               颜色
//    kCGBlendModeLuminosity,          亮度


    
   
// 后面结合layer来看
//image drawLayer:(nonnull CALayer *) inContext:(nonnull CGContextRef)


    
    // 水印
    NSString * str = @"xxxkisd";
    [str drawInRect:CGRectMake(100, 100, 100, 30) withAttributes:nil];
    
    
    
    
//    CGContextFillPath(ctx);
  
}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    [super drawLayer:layer inContext:ctx];
//    NSLog(@"sdf");
//}






/**
 *  绘制字符串
 */
void drawText() {
    
     NSString *str = @"舍得浪费空间圣诞快乐圣诞快乐圣诞节快乐斯捷克洛夫都是考试的考生发来的快乐圣诞节快乐圣诞节快乐都是恐惧舍得浪费空间圣诞快乐圣诞快乐圣诞节快乐斯捷克洛夫都是考试的考生发来的快乐圣诞节快乐圣诞节快乐都是恐惧";
     NSMutableDictionary *attrs = [@{NSForegroundColorAttributeName:[UIColor redColor],
                                                                       NSFontAttributeName:[UIFont systemFontOfSize:15]} mutableCopy];
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 2.画矩形
//    CGRect cubeRect = CGRectMake(50, 50, 200, 200);
//    CGContextAddRect(ctr, cubeRect);
//    CGContextFillPath(ctr);
//    
//
//
//    [str drawInRect:cubeRect withAttributes:attrs];
    
    
    
    CGRect frame = [str boundingRectWithSize:CGSizeMake(100, 90) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    CGContextAddRect(ctr, CGRectMake(50, 50, frame.size.width, frame.size.height));
    CGContextFillPath(ctr);
    [str drawInRect:CGRectMake(50, 50, frame.size.width, frame.size.height) withAttributes:attrs];
    
    
    
    
//    打印可以看到，sizeWithAttributes是在给定的属性下，返回的高度是固定的，而字符串越长，宽度越宽
//    而boundingRectWithSize是在指定的属性下，将字符串绘制到一个范围内，字符串会在该范围换行，如果该范围足够高，可以算出字符串在该范围占的空间，否则返回字符串的宽和该范围的高
//    CGSize size = [str sizeWithAttributes:attrs];
   

}





@end

//
//  LineView.m
//  Quart2D_Demo
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "LineShapeView.h"

@implementation LineShapeView


- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"initframe");
    }
    return self;
}


/**
 drawRect:方法的使用
 • 常见图形的绘制:线条、多边形、圆
 • 绘图状态的设置:文字颜色、线宽等
 • 图形上下文状态的保存与恢复
 • 图形上下文栈
 */

- (void)drawRect:(CGRect)rect {
    
    // 打印可以看到，drawrect是在viewdidload后执行的
    /**
     *  ➢ 当view第一次显示到屏幕上时(被加到UIWindow上显示出来) 
     *  ➢ 调用view的setNeedsDisplay或者setNeedsDisplayInRect:时
     */
    NSLog(@"drawrect");
    
    
    //    draw4Rect();
    //    drawTriangle();
    
    //    drawCircle();
//    drawRrc();
//    drawLine();
//    drawDashLine();
    
    drawCurves();
    
}


/**
 *  画圆弧
 */
void drawRrc() {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(contextRef, 100, 100);
    CGContextAddLineToPoint(contextRef, 100, 150);
    
    // 根据起始弧度到目的弧度的弧形绘制圆弧
    // x\y : 圆心
    // radius : 半径
    // startAngle : 开始角度
    // endAngle : 结束角度
    // clockwise : 圆弧的伸展方向(0:顺时针, 1:逆时针)
    //
//    CGContextAddArc(contextRef, 100, 100, 50, M_PI * 0.5, M_PI * 1.5, 1);
    
    
    // 根据弧线起始点到弧线终点和圆弧的半径绘制圆弧
    CGContextAddArcToPoint(contextRef, 100, 100, 200, 200, 50);
    CGContextClosePath(contextRef);
    
    
    
    
    
    //用灰色设置背景颜色
    /*第二个参数：阴影的位移,由 CGSize 类型值指定,从每个形状要应用阴影的右下部分开始。位移的 x 值越大,形状
     右边的阴影就扩散得越远。位移的 y 值越大,下部的阴影就越低。
     第三个参数：阴影的模糊值,以浮点值(CGFloat)来指定。指定 0.0f 将导致阴影成为固态形状。这个值越高,阴影就越
     模糊。我们很快能看到例子。
     */
    CGContextSetShadowWithColor(contextRef, CGSizeMake(5, 10), 1, [UIColor lightGrayColor].CGColor);
//    CGContextSetShadow(contextRef, CGSizeMake(10, 10), 4);

    
    
    [[UIColor redColor] setFill];
    [[UIColor blueColor] setStroke];
    
    //    //设置颜色
    //    CGContextSetStrokeColorWithColor(contextRef, [[UIColor redColor] CGColor]);
    
    //设置填充颜色
    //    CGContextSetFillColorWithColor(contextRef, [[UIColor blueColor] CGColor]);
    //    CGContextFillPath(contextRef);
    
    //    CGContextFillPath(contextRef);
    //    CGContextStrokePath(contextRef);
    
    
    
    
    /* Draw the context's path using drawing mode `mode'. */
    //  （CGContext）描边和填充分开调用方法无法同时绘制，需要下面的方法
    //绘制图形到指定图形上下文,切设置既有边框,又有填充型
    /*CGPathDrawingMode是填充方式,枚举类型
     kCGPathFill:只有填充（非零缠绕数填充），不绘制边框
     kCGPathEOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
     kCGPathStroke:只有边框
     kCGPathFillStroke：既有边框又有填充
     kCGPathEOFillStroke：奇偶填充并绘制边框
     */
    CGContextDrawPath(contextRef, kCGPathFill);
    
    
}

/**
 *  贝塞尔曲线
 */
void drawCurves() {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(ctx, 10, 200);
//    CGContextAddQuadCurveToPoint(ctx, 150, 50, 200, 200);

    CGContextAddCurveToPoint(ctx, 100, 100, 200, 300, 300, 200);
    
    CGContextStrokePath(ctx);
    
    
    
    
    /**
     *  画曲线
     *
     *  @param c   图形上下文
     *  @param cpx 控制点x值
     *  @param cpy 控制点y值
     *  @param x   曲线终点x值
     *  @param y   曲线终点y值
     *
     */
//    CGContextAddQuadCurveToPoint(CGContextRef  _Nullable c, CGFloat cpx, CGFloat cpy, CGFloat x, CGFloat y)
    
    
    /**
     *  画曲线
     *
     *  @param c    图形上下文
     *  @param cp1x 控制点1 x值
     *  @param cp1y 控制点1 y值
     *  @param cp2x 控制点2 x值
     *  @param cp2y 控制点2 y值
     *  @param x    曲线终点x值
     *  @param y    曲线终点y值
     *
     */
//    CGContextAddCurveToPoint(CGContextRef  _Nullable c, CGFloat cp1x, CGFloat cp1y, CGFloat cp2x, CGFloat cp2y, CGFloat x, CGFloat y)
}


/**
 *  椭圆
 */
void drawCircle() {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //    CGContextAddEllipseInRect(contextRef, CGRectMake(10, 10, 100, 100));
    CGContextAddEllipseInRect(contextRef, CGRectMake(50, 50, 100, 50));
    
    CGContextSetLineWidth(contextRef, 2);
    
    CGContextStrokePath(contextRef);
}


/**
 *  三角形
 */
void drawTriangle() {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(contextRef, 100, 100);
    CGContextAddLineToPoint(contextRef, 100, 200);
    CGContextAddLineToPoint(contextRef, 200, 200);
    CGContextClosePath(contextRef);
    
    CGContextSetLineWidth(contextRef, 3);
    CGContextSetRGBStrokeColor(contextRef, 1, 0, 0, 1);
    
    CGContextStrokePath(contextRef);
    
}



/**
 *  画四边形
 */
void draw4Rect() {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(contextRef, CGRectMake(20, 20, 159, 199));
    
    
    [[UIColor redColor] set];
    
    CGContextStrokePath(contextRef);
}


/**
 *  画线条
 */
void drawLine() {
    // 1.获得图形上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 2.拼接图形(路径)
    // 设置线段宽度
    CGContextSetLineWidth(contextRef, 10);
    
    
    
    // 设置线段头尾部的样式
    /**
     Butt 齐头   Square 多出一截方头 Round 多出一截圆头
     */
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    
    
    
    // 设置线段转折点的样式  （圆、斜、尖)
    CGContextSetLineJoin(contextRef, kCGLineJoinRound);
    
    CGContextSetRGBStrokeColor(contextRef, 1, 0, 0, 1);
    
    
    /**  第1根线段  **/
    CGContextMoveToPoint(contextRef, 100, 100);
    
    CGContextAddLineToPoint(contextRef, 200, 200);
    
    
    
    // 3.渲染显示到view上面
    CGContextStrokePath(contextRef);
    
    
    /**  第2根线段  **/
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 1, 1);
    
    CGContextMoveToPoint(contextRef, 210, 210);
    CGContextAddLineToPoint(contextRef, 300, 300);
    CGContextAddLineToPoint(contextRef, 100, 400);
    
    
    
    //显示所绘制的东西
    CGContextStrokePath(contextRef);
}

/**
 *  画虚线
 */
void drawDashLine() {
    
    CGContextRef cxr = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {5,4,3,2,1};
    CGContextSetLineDash(cxr, 0, lengths, 5);
    
    
    CGContextMoveToPoint(cxr, 10, 100);
    CGContextAddLineToPoint(cxr, 300, 100);
    
    
    CGContextStrokePath(cxr);
    
}

@end

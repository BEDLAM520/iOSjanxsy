//
//  ScanBackView.m
//  AVFountion
//
//  Created by xshhanjuan on 15/9/7.
//  Copyright (c) 2015年 xsh. All rights reserved.
//

#import "ScanBackView.h"

@implementation ScanBackView

-(void)drawRect:(CGRect)rect {
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(0, self.frame.size.height * 0.2)];
    [path1 addLineToPoint:CGPointMake(0, 0)];
    [path1 addLineToPoint:CGPointMake(self.frame.size.height * 0.2, 0)];
    path1.lineWidth = 3;
    [RGBACOLOR(79, 195, 38, 1) setStroke];
    [path1 stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(self.frame.size.height * 0.8, 0)];
    [path2 addLineToPoint:CGPointMake(self.frame.size.height, 0)];
    [path2 addLineToPoint:CGPointMake(self.frame.size.height, self.frame.size.height * 0.2)];
    path2.lineWidth = 3;
    [RGBACOLOR(79, 195, 38, 1) setStroke];
    [path2 stroke];
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(0, self.frame.size.height * 0.8)];
    [path3 addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path3 addLineToPoint:CGPointMake(self.frame.size.height * 0.2, self.frame.size.height)];
    path3.lineWidth = 3;
    [RGBACOLOR(79, 195, 38, 1) setStroke];
    [path3 stroke];
    
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    [path4 moveToPoint:CGPointMake(self.frame.size.height * 0.8, self.frame.size.height)];
    [path4 addLineToPoint:CGPointMake(self.frame.size.height, self.frame.size.height)];
    [path4 addLineToPoint:CGPointMake(self.frame.size.height , self.frame.size.height * 0.8)];
    path4.lineWidth = 3;
    [RGBACOLOR(79, 195, 38, 1) setStroke];
    [path4 stroke];
}

@end

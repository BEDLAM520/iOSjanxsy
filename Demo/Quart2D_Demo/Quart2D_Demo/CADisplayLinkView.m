//
//  CADisplayLinkView.m
//  Quart2D_Demo
//
//  Created by liaonaigang on 16/7/1.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "CADisplayLinkView.h"

@implementation CADisplayLinkView
{
    CGFloat _snowY;
}

- (void)awakeFromNib {
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)drawRect:(CGRect)rect {
    
    _snowY += 5;
    
    
    UIImage *image = [UIImage imageNamed:@"images"];
    [image drawInRect:CGRectMake(0, _snowY, 100, 100)];
}

@end

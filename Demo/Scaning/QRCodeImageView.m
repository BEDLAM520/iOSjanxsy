//
//  QRCodeImageView.m
//  MyTool
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 xsh. All rights reserved.
//

#import "QRCodeImageView.h"

@implementation QRCodeImageView

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [UIImageView new];
        _logo.userInteractionEnabled = YES;
        [self addSubview:_logo];
    }
    return _logo;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat logoW = self.width * 0.25;
    self.logo.frame = CGRectMake(self.width * 0.75 * 0.5, (self.height - logoW ) * 0.5, logoW, logoW);
}

@end

//
//  CommentModel.m
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


- (instancetype)init {
    if (self = [super init]) {
        _height = CCBottomGap;
    }
    return self;
}


- (void)setName:(NSString *)name {
    _name = name;
    
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:1],
                           NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    _nameHeight = [name boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    _height += _nameHeight + CNameTopGap;
}


- (void)setComment:(NSString *)comment {
    
    _comment = comment;
    
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 0;
    style.lineSpacing = 8;
    
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                            NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSParagraphStyleAttributeName:style};
    
    
    
    // 计算一行文本的高度
    CGFloat width = [UIScreen mainScreen].bounds.size.width - BHeaderWidht - BHeaderLeftGap - BHeaderNameGap - BRemarkRightGap - CCommentLeftRightGap * 2;
    
    _commentHeight = [comment boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    
    
    _height += _commentHeight + CNameBottomGap;
    
    _commetnAttr = [self getAttributedStringWithString:comment attrs:attrs];
    
}



- (NSAttributedString *)getAttributedStringWithString:(NSString *)string attrs:(NSDictionary*)attrs{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, [string length]);
    
    return [self setAttributedString:attributedString params:attrs range:range];
}

- (NSMutableAttributedString*)setAttributedString:(NSMutableAttributedString*)attr params:(NSDictionary*)params range:(NSRange)range {
    
    for (NSString *keyName in params.allKeys) {
        [attr addAttribute:keyName value:[params objectForKey:keyName] range:range];
    }
    
    return attr;
}




@end

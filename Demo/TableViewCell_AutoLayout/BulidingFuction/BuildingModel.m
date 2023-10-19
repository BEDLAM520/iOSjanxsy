//
//  BuildingModel.m
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import "BuildingModel.h"


@implementation BuildingModel

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray new];
    }
    return _comments;
}

- (instancetype)init {
    if (self = [super init]) {
        _headerRect = CGRectMake(BHeaderLeftGap, BHeaderTopGap, BHeaderWidht, BHeaderWidht);
        _height = BCellBottomGap;
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:1],
                           NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    _nameHeight = [name boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    _height += _nameHeight + BNameLabelTop;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
    _nameAttr = [self setAttributedString:attr params:dict range:NSMakeRange(0, name.length)];
}


- (void)setDate:(NSString *)date {
    _date = date;
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor darkGrayColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:13]};
    
    _dateHeight = [date boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    _height += _dateHeight + BNameDateBottomGap;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:date];
    _dateAttr = [self setAttributedString:attr params:dict range:NSMakeRange(0, date.length)];
    
}



- (void)setRemark:(NSString *)remark {
    
    _remark = remark;
    
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 0;
    style.lineSpacing = 8;
    
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                            NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSParagraphStyleAttributeName:style};
    
    
    
    // 计算一行文本的高度
    CGFloat width = [UIScreen mainScreen].bounds.size.width - _headerRect.size.width - BHeaderLeftGap - BHeaderNameGap - BRemarkRightGap;
    _remarkHeight = [remark boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    
    
    _height += _remarkHeight + BDateTableBottomGap;
    
    
    _remarkAttr = [self getAttributedStringWithString:_remark attrs:attrs];
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


- (void)buidingAddComment:(CommentModel *)comment {
    
    [self.comments insertObject:comment atIndex:0];
    
    __block CGFloat height = 0;
    
    [self.comments enumerateObjectsUsingBlock:^(CommentModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        height += obj.height;
    }];
    
    _commentHeight = height + BTableRemarkGap;
}


@end

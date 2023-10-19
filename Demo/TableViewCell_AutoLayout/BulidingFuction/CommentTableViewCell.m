//
//  CommentTableViewCell.m
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameL = [UILabel new];
        self.nameL.textColor = [UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:1];
        self.nameL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameL];
        
        self.commentL = [UILabel new];
        self.commentL.numberOfLines = 0;
        [self.contentView addSubview:self.commentL];
        
    }
    return self;
}

- (void)setComment:(CommentModel *)comment {
    _comment = comment;
    
    [self.commentL setAttributedText:comment.commetnAttr];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat top = CNameTopGap;
    self.nameL.frame = CGRectMake(CNameLeftGap, top, 200, self.comment.nameHeight);
    
    top += self.comment.nameHeight + CNameBottomGap;
    self.commentL.frame = CGRectMake(CCommentLeftRightGap, top, self.frame.size.width - CCommentLeftRightGap * 2, self.comment.commentHeight);
}

@end

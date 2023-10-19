//
//  CommentModel.h
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BHeaderNameGap         15
#define BRemarkRightGap        15
#define BHeaderLeftGap         8
#define BHeaderTopGap          8
#define BNameLabelTop          15
#define BCellBottomGap         15
#define BNameDateBottomGap     5
#define BDateTableBottomGap    15
#define BHeaderWidht           35
#define BTableRemarkGap        10

#define CNameLeftGap           5
#define CNameTopGap            5
#define CNameBottomGap         10
#define CCommentLeftRightGap   10
#define CCBottomGap            5

@interface CommentModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign,readonly)CGFloat nameHeight;

@property (nonatomic,copy)NSString *comment;
@property (nonatomic,strong,readonly)NSAttributedString *commetnAttr;
@property (nonatomic,assign,readonly)CGFloat commentHeight;

@property (nonatomic,assign)NSInteger point;

@property (nonatomic,assign,readonly)CGFloat height;

@end

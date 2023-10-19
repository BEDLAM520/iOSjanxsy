//
//  BuildingModel.h
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentModel.h"


@interface BuildingModel : NSObject

- (void)buidingAddComment:(CommentModel*)comment;


@property (nonatomic,assign,readonly)CGFloat height;

@property (nonatomic,copy)NSString *url;
@property (nonatomic,assign,readonly)CGRect headerRect;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong,readonly)NSAttributedString *nameAttr;
@property (nonatomic,assign,readonly)CGFloat nameHeight;

@property (nonatomic,copy)NSString *date;
@property (nonatomic,strong,readonly)NSAttributedString *dateAttr;
@property (nonatomic,assign,readonly)CGFloat dateHeight;

@property (nonatomic,copy)NSString *remark;
@property (nonatomic,strong,readonly)NSAttributedString *remarkAttr;
@property (nonatomic,assign,readonly)CGFloat remarkHeight;

@property (nonatomic,assign)NSInteger point;
@property (nonatomic,strong,readonly)NSAttributedString *pointAttr;
@property (nonatomic,assign,readonly)CGFloat pointHeight;

@property (nonatomic,strong)NSMutableArray *comments;
@property (nonatomic,assign,readonly)CGFloat commentHeight;
@end

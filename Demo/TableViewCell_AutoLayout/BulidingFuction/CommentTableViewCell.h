//
//  CommentTableViewCell.h
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic,strong)CommentModel *comment;
@property (nonatomic,strong)UILabel *nameL;
@property (nonatomic,strong)UILabel *commentL;
@end

//
//  FoldTableViewCell.h
//  MyTool
//
//  Created by xshhanjuan on 16/1/14.
//  Copyright © 2016年 xsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldModel.h"

@interface FoldTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) FoldModel *fold;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITableView *tableView;
@end

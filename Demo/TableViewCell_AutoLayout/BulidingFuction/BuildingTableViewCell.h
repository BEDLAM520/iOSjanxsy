//
//  BuildingTableViewCell.h
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingModel.h"

@class BuildingTableViewCell;

@protocol BuildingTableViewCellDelegate <NSObject>

- (void)BuildingTableViewCellDidClickPoint:(BuildingTableViewCell*)cell;

@end


@interface BuildingTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)BuildingModel *buiding;
@property (nonatomic,weak)id<BuildingTableViewCellDelegate> delegate;
@property (nonatomic,strong)UIImageView *headerV;
@property (nonatomic,strong)UILabel *nameL;
@property (nonatomic,strong)UILabel *dateL;
@property (nonatomic,strong)UILabel *remarkL;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *pointV;
@property (nonatomic,strong)UILabel *pointL;
@end

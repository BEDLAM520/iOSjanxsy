//
//  BuildingTableViewCell.m
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import "BuildingTableViewCell.h"
#import "CommentTableViewCell.h"

@implementation BuildingTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headerV = [UIImageView new];
        [self.contentView addSubview:self.headerV];
        self.headerV.backgroundColor = [UIColor redColor];
        
        self.nameL = [UILabel new];
        [self.contentView addSubview:self.nameL];
        
        self.pointV = [UIButton new];
        [self.pointV addTarget:self action:@selector(clickPoint) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.pointV];
        self.pointV.backgroundColor = [UIColor redColor];
        
        self.pointL = [UILabel new];
        self.pointL.font = [UIFont systemFontOfSize:13];
        self.pointL.textAlignment = NSTextAlignmentLeft;
        self.pointL.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.pointL];
        
        self.dateL = [UILabel new];
        [self.contentView addSubview:self.dateL];
        
        self.remarkL = [UILabel new];
        self.remarkL.numberOfLines = 0;
        [self.contentView addSubview:self.remarkL];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:tableView];
        self.tableView = tableView;
        
        
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)clickPoint {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BuildingTableViewCellDidClickPoint:)]) {
        [self.delegate BuildingTableViewCellDidClickPoint:self];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (void)setBuiding:(BuildingModel *)buiding {
    _buiding = buiding;
    
    
    self.nameL.attributedText = buiding.nameAttr;
    self.dateL.attributedText = buiding.dateAttr;
    self.remarkL.attributedText = buiding.remarkAttr;
    self.pointL.text = [NSString stringWithFormat:@"%@",@(buiding.point)];
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat top = BNameLabelTop;
    CGFloat nameLeft = self.buiding.headerRect.origin.x + self.buiding.headerRect.size.width + BHeaderNameGap;
    CGFloat tableViewWidth = self.frame.size.width - nameLeft - BRemarkRightGap;
    
    self.headerV.frame = self.buiding.headerRect;
    self.nameL.frame = CGRectMake(nameLeft, top, 200, self.buiding.nameHeight);
    
    self.pointV.frame = CGRectMake(self.frame.size.width - 100, top, 20, 20);
    self.pointL.frame = CGRectMake(self.frame.size.width - 100 + 20  + 5, top, 60, 20);
    
    
    
    top += BNameDateBottomGap + self.buiding.nameHeight;
    self.dateL.frame = CGRectMake(nameLeft, top, 250, self.buiding.dateHeight);
    
    top += BDateTableBottomGap + self.buiding.dateHeight;
    self.tableView.frame = CGRectMake(nameLeft, top, tableViewWidth, self.buiding.commentHeight);
    
    top += self.buiding.commentHeight + BTableRemarkGap;
    self.remarkL.frame = CGRectMake(nameLeft, top, tableViewWidth, self.buiding.remarkHeight);
}


#pragma mark - tabledelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buiding.comments.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCell"];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCell"];
    }
    
    CommentModel *comment = self.buiding.comments[indexPath.row];
    cell.nameL.text = [NSString stringWithFormat:@"%@.%@",@(indexPath.row+1),comment.name];
    cell.comment = comment;
    
    return cell;
}


#pragma mark - dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *comment = self.buiding.comments[indexPath.row];
    return comment.height;
}


- (void)dealloc {
    self.delegate = nil;
}


@end

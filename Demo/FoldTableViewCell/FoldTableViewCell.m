//
//  FoldTableViewCell.m
//  MyTool
//
//  Created by xshhanjuan on 16/1/14.
//  Copyright © 2016年 xsh. All rights reserved.
//

#import "FoldTableViewCell.h"


@implementation FoldTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 36;
        tableView.scrollEnabled = NO;
        _tableView = tableView;
        [self addSubview:tableView];
        
    }
    return self;
}



- (void)setFold:(FoldModel *)fold {
    _fold = fold;
    _titleLabel.text = fold.title;
}




-(void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(15, 0, self.width - 15*2, 36);
    
    
    if (self.fold.isOpen) {
        _tableView.frame = CGRectMake(0, 36, self.width, 36 * self.fold.subArray.count);
        [_tableView reloadData];
    }else {
        _tableView.frame = CGRectMake(0, 36, self.width, 0);
    }
}



#pragma mark tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fold.subArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.fold.subArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMLog(@"%@",self.fold.subArray[indexPath.row]);
}


@end

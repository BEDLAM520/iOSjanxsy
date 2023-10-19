//
//  ViewController.m
//  BulidingFuction
//
//  Created by liaonaigang on 2017/4/22.
//  Copyright © 2017年 gangCompany. All rights reserved.
//

#import "ViewController.h"
#import "BuildingTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,BuildingTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        NSMutableArray *dataArray = [NSMutableArray new];
        _dataArray = dataArray;
        
        NSString *temp = @"sdffdsfsd";
        NSString *commentStr = @"小鸡巴鸡说啥啊我听不到";
        for (int i = 0; i < 10; i++) {
            
            BuildingModel *model = [BuildingModel new];
            model.name = [NSString stringWithFormat:@"鸡巴%@号",@(i + 1)];
            model.date = @"2017-03-22";
            model.point = (i + 1) * (i + 1);
            model.remark = temp;
            temp = [temp stringByAppendingString:@"你懂个球啊你你球都没有"];
            [dataArray addObject:model];
            
            for (int j = 0; j < i + 1; j ++) {
                CommentModel *comment = [CommentModel new];
                comment.name = [NSString stringWithFormat:@"小鸡巴%@号",@(j + 1)];
                comment.point = (j + 1) * (j + 1);
                commentStr = [commentStr stringByAppendingString:@"小鸡巴鸡说啥啊我听不到"];
                comment.comment = commentStr;
                
                [model buidingAddComment:comment];
            }
        }
        
        
        
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView reloadData];
    
    [self setupViews];
}

- (void)setupViews {
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 300, 55, 55)];
    addBtn.backgroundColor = [UIColor blueColor];
    [addBtn addTarget:self action:@selector(addNewComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}

- (void)addNewComment {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"添加一条状态" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"添加一条状态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BuildingModel *model = [BuildingModel new];
        model.name = @"鸡鸡小小号";
        model.date = @"2017-03-22";
        model.point = 100;
        model.remark = @"福建省打开了附近的索科洛夫绝世独立飞机上看了附近的苏里科夫三大纪律反抗精神独立开发建立肯德基失联客机上的快乐";
        [self.dataArray addObject:model];
        
        
        [self.dataArray insertObject:model atIndex:0];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[BuildingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.delegate = self;
    cell.buiding = self.dataArray[indexPath.row];
    
    return cell;
}


#pragma mark - dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"添加一条状态" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"添加一条评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BuildingModel *buid = self.dataArray[indexPath.row];

        
        CommentModel *model = [CommentModel new];
        model.name = @"小鸡鸡小小号";
        model.point = 100;
        model.comment = @"费德勒高架道路可是感觉凉快地方机构两块地方叫孤苦伶仃福建各地风口浪尖的弗兰克该奋斗了";
        [buid buidingAddComment:model];
        
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingModel *buid = self.dataArray[indexPath.row];
    return buid.height + buid.commentHeight;
}


#pragma mark BuildingTableViewCellDelegate
- (void)BuildingTableViewCellDidClickPoint:(BuildingTableViewCell *)cell {
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    BuildingModel *buid = self.dataArray[path.row];
    buid.point += 1;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end

//
//  UpdateViewController.m
//  Quart2D_Demo
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年 nailiao. All rights reserved.
//

#import "UpdateViewController.h"
#import "UpdateView.h"

@interface UpdateViewController ()
@property (weak, nonatomic) IBOutlet UpdateView *showView;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderAction:(UISlider *)sender {
    
    self.showView.progress = sender.value;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  HMDetailViewController.m
//  02-本地推送通知
//
//  Created by apple on 14-8-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDetailViewController.h"

@interface HMDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation HMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bodyLabel.text = self.userInfo[@"body"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

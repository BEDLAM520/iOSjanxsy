//
//  ViewController.m
//  RuntimeDemo
//
//  Created by  user on 2018/3/29.
//  Copyright © 2018年 NG. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    id cls = [Person class];
    void *obj = &cls;
    [(__bridge id)obj speak];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end



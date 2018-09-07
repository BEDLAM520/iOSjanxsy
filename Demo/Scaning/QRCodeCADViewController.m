//
//  QRCodeCADViewController.m
//  MyTool
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 xsh. All rights reserved.
//

#import "QRCodeCADViewController.h"
#import "QRCodeImageView.h"
@interface QRCodeCADViewController ()
@property (nonatomic,strong)QRCodeImageView *imgV;
@end

@implementation QRCodeCADViewController

- (QRCodeImageView *)imgV {
    if (!_imgV) {
        _imgV = [[QRCodeImageView alloc]initWithFrame:CGRectMake(80, 160, self.view.width - 80 * 2, self.view.width - 80*2)];
        _imgV.userInteractionEnabled = YES;
        [self.view addSubview:_imgV];
        
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recQRCode)];
        longG.minimumPressDuration = 1.0;
        [_imgV addGestureRecognizer:longG];
    }
    return _imgV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码生成和识别";
    
    [self setupViews];
}


- (void)setupViews {
    UIButton *createBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.imgV.bottom + 40, 80, 40)];
    [createBtn setTitle:@"生成" forState:UIControlStateNormal];
    createBtn.backgroundColor = RGBACOLOR(102, 80, 150, 1);
    [createBtn addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    
    UIButton *recoBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - createBtn.width - 40, createBtn.y, createBtn.width, createBtn.height)];
    [recoBtn setTitle:@"长摁识别" forState:UIControlStateNormal];
    recoBtn.backgroundColor = createBtn.backgroundColor;
//    [recoBtn addTarget:self action:@selector(recQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoBtn];
}


- (void)create {
    if (!self.imgV.image) {
        self.imgV.image = [UIImage creatCIQRCodeImageWithSize:self.imgV.width message:@"我在这创建一个二维码呀"];
        self.imgV.logo.image = [UIImage imageNamed:@"icon_imgApp"];
    }
}

- (void)recQRCode {
    if (self.imgV.image) {
        CIQRCodeFeature *feature = [self.imgV.image recognizeQRCode];
        MMLog(@"%@   %@",feature,feature.messageString);
        [self addActityText:feature.messageString deleyTime:1.5];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

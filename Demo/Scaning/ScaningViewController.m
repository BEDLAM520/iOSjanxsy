//
//  ViewController.m
//  AVFountion
//
//  Created by xshhanjuan on 15/9/2.
//  Copyright (c) 2015年 xsh. All rights reserved.
//

#import "ScaningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanBackView.h"
#import "QRCodeCADViewController.h"

#define scranWidth    xLessThanSix(250)
#define scranHeight   scranWidth
#define scopeColor   [[UIColor blackColor] colorWithAlphaComponent:0.5]

@interface ScaningViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) UIImageView *scanLine;
@property (nonatomic,strong) AVCaptureDevice *device;            //设备  手机的摄像机
@property (nonatomic,strong) AVCaptureDeviceInput *input;        //输入设备
@property (nonatomic,strong) AVCaptureMetadataOutput *output;    //输出设备
@property (nonatomic,strong) AVCaptureSession *session;          //控制器 连接输入输出设备
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview; //视图 显示相机的范围
@end

@implementation ScaningViewController

- (UIImageView *)scanLine {
    if (!_scanLine) {
        _scanLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scranWidth, 3)];
        _scanLine.image = [UIImage imageNamed:@"qr_scanning"];
    }
    return _scanLine;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"二维码";
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    [self config];
}



- (void)setupViews {
    
    CGFloat topH = (DespiteNavH  - scranWidth) * 0.3;
    CGFloat rightW = (self.view.width - scranWidth ) * 0.5;
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, nnNavH, self.view.frame.size.width, topH)];
    topView.backgroundColor = scopeColor;
    [self.view addSubview:topView];
    
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,topView.bottom,rightW, scranHeight)];
    leftView.backgroundColor = scopeColor;
    [self.view addSubview:leftView];
    
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(rightW + scranWidth, topView.bottom, rightW, scranHeight)];
    rightView.backgroundColor = scopeColor;
    [self.view addSubview:rightView];
    
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, rightView.bottom, self.view.width,self.view.height - rightView.bottom)];
    downView.backgroundColor = scopeColor;
    [self.view addSubview:downView];
    
    
    
    ScanBackView *srcanView = [[ScanBackView alloc]initWithFrame:CGRectMake(rightW + scranWidth * 0.5, topView.bottom + scranHeight * 0.5, 0, 0)];
    srcanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:srcanView];
    
    
    [srcanView addSubview:self.scanLine];
    
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.scanLine.centerY += scranHeight - 3;
    } completion:nil];
    
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, rightView.bottom + 30, self.view.frame.size.width, 15)];
    showLabel.text = @"将二维码/条码放入框内，即可自动扫描";
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:13];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.hidden = YES;
    [self.view addSubview:showLabel];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, showLabel.bottom + 40, 200, 40)];
    btn.centerX = self.view.centerX;
    [btn setTitle:@"二维码生成和识别" forState:UIControlStateNormal];
    btn.enabled = NO;
    btn.hidden = YES;
    [btn addTarget:self action:@selector(qrcodeCAR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        srcanView.frame = CGRectMake(rightW , topView.bottom, scranWidth, scranHeight);
    } completion:^(BOOL finished) {
        showLabel.hidden = NO;
        btn.hidden = NO;
        btn.enabled = YES;
    }];
}


- (void)qrcodeCAR {
    QRCodeCADViewController *vc = [[QRCodeCADViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)config {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (AVAuthorizationStatusAuthorized != authStatus) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"要打开照相权限吗？" message:@"打开相册后，本应用对您的相机进行访问。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=com.vip.cunCunTeGong"]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        [self configDevice];
    }
}



-(void)configDevice {
    
    [self addActityLoading:@"加载中..." subTitle:nil];
    
    // 耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 闪光灯
        if (self.device.torchMode == AVCaptureTorchModeOff) {
            
            // Input  将设备作为输入设备的信息来源
            self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
            
            // Output 输出设备 需要设置代理和队列 一般使用主队列
            self.output = [[AVCaptureMetadataOutput alloc]init];
            [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            
            // 生成控制器
            self.session = [[AVCaptureSession alloc]init];
            // 代表输入图片质量大小，一般来说AVCaptureSessionPreset640x480就够使用，但是如果要保证较小的二维码图片能快速扫描，最好设置高些
            [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
            
            
            //添加输入设备
            if ([self.session canAddInput:self.input]) {
                [self.session addInput:self.input];
            }
            
            //添加输出设备
            if ([self.session canAddOutput:self.output]) {
                [self.session addOutput:self.output];
            }
            
            
            AVCaptureConnection *outputConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
            outputConnection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
            
            if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                
                // 只有二维码
                //            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
                
                // 条形和二维码都有
                self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                                    AVMetadataObjectTypeEAN8Code,
                                                    AVMetadataObjectTypeCode128Code,
                                                    AVMetadataObjectTypeQRCode];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Preview 扫描视图，扫描范围
                self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
                self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
                self.preview.frame = self.view.layer.bounds;
                [self.view.layer insertSublayer:self.preview atIndex:0];
                
                self.preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
                
                MMLog(@"%@",self.session);
                [self.session startRunning];
                
                
                UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(reStart)];
                self.navigationItem.rightBarButtonItem = barItem;
                
                [self hiddenHUDActity];
                [self setupViews];
            });
            
            
            

            
            CGFloat topH = (DespiteNavH  - scranWidth) * 0.3;
            CGSize size = self.view.bounds.size;
            CGRect cropRect = CGRectMake((self.view.frame.size.width - scranWidth) * 0.5, topH + nnNavH, scranWidth, scranHeight);
            CGFloat p1 = size.height/size.width;
            CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
            
            if (p1 < p2) {
                CGFloat fixHeight = size.width * 1920. / 1080.;
                CGFloat fixPadding = (fixHeight - size.height)/2;
                self.output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                          cropRect.origin.x/size.width,
                                                          cropRect.size.height/fixHeight,
                                                          cropRect.size.width/size.width);
            } else {
                CGFloat fixWidth = size.height * 1080. / 1920.;
                CGFloat fixPadding = (fixWidth - size.width)/2;
                self.output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                          (cropRect.origin.x + fixPadding)/fixWidth,
                                                          cropRect.size.height/size.height,
                                                          cropRect.size.width/fixWidth);
            
            }
        }
    });
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        
        return AVCaptureVideoOrientationPortrait;
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        
        return AVCaptureVideoOrientationLandscapeLeft;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        
        return AVCaptureVideoOrientationLandscapeRight;
        
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

- (void)reStart {
    if (self.session) {
        self.scanLine.alpha = 1;
        [self.session startRunning];
        
        
        self.scanLine.y = 0;
        [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
            self.scanLine.centerY += scranHeight - 3;
        } completion:nil];
    }
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] > 0) {
        
        [self.session stopRunning];
        self.scanLine.alpha = 0;
        
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        
        NSString *stringValue = metaDataObject.stringValue;
        
        
        MMLog(@"%@",stringValue);
    }
}






/*
 一、扫码需要配置下面五个部分：
 AVCaptureDevice            * device;   //设备  手机的摄像机
 AVCaptureDeviceInput       * input; //输入设备
 AVCaptureMetadataOutput    * output;//输出设备
 AVCaptureSession           * session; //控制器 连接输入输出设备
 AVCaptureVideoPreviewLayer * preview; //视图 显示相机的范围
 二、概念
 1.条形码类别：
 AVF_EXPORT NSString *const AVMetadataObjectTypeUPCECode
 AVF_EXPORT NSString *const AVMetadataObjectTypeCode39Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeCode39Mod43Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeEAN13Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeEAN8Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeCode93Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeCode128Code
 AVF_EXPORT NSString *const AVMetadataObjectTypePDF417Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeQRCode //二维码
 AVF_EXPORT NSString *const AVMetadataObjectTypeAztecCode
 AVF_EXPORT NSString *const AVMetadataObjectTypeInterleaved2of5Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeITF14Code
 AVF_EXPORT NSString *const AVMetadataObjectTypeDataMatrixCode
 2.采集的质量：
 AVCaptureSessionPresetPhoto //不支持流媒介 全照片
 AVCaptureSessionPresetHigh   //高清
 AVCaptureSessionPresetMedium //中等 适合wifi环境
 AVCaptureSessionPresetLow  //低 适合3G网络
 AVCaptureSessionPreset320x240  //其它配置
 AVCaptureSessionPreset352x288
 3.扫描显示：
 AVLayerVideoGravityResize, //拉伸视频以填充可用屏幕区域，即使这样做会扭曲的形象
 AVLayerVideoGravityResizeAspect //保留宽高比，留下黑边，其中视频不填充可用屏幕区域
 AVLayerVideoGravityResizeAspectFill //保留高宽比，但填充可用的屏幕区域，必要时裁剪视频
 4.扫描媒体：
 AVMediaTypeVideo
 AVMediaTypeAudio
 AVMediaTypeText
 AVMediaTypeClosedCaption
 AVMediaTypeSubtitle
 AVMediaTypeTimecode
 AVMediaTypeMetadata
 AVMediaTypeMuxed
 **/

@end

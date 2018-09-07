//
//  GesturePasswordViewController.m
//  GesturePassWord
//
//  Created by xshhanjuan on 15/11/11.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import "GesturePasswordViewController.h"


#define SCREENWIDTH  self.view.frame.size.width
#define SCREENHeight  self.view.frame.size.height
#define kButton_tag       1001
#define bothGap     50

#define gesturePasswrod  [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"]
#define MAXSIX ([[UIScreen mainScreen]bounds].size.height >= 667.0)


@interface GesturePasswordViewController ()

@property (nonatomic,assign) CGPoint linePointStart;      // 画线起点
@property (nonatomic,assign) CGPoint linePointEnd;        // 画线终点
@property (nonatomic,assign) BOOL bHaveDraw;            //是否已开始画线（当手指点在按钮内时开始，手指在屏幕上抬起结束）
@property (nonatomic,assign) BOOL bSecondInput;              // 是否是第二次输入
@property (nonatomic,assign) int nPasswordErrorNum;       //密码输入错误次数

@property (nonatomic,strong) UIImageView *backgroundImageView;   // 画布
@property (nonatomic,strong) NSMutableArray *sudokuArray;        //九个button
@property (nonatomic,strong) NSMutableArray *sudokuSelectButtons;   //变色button
@property (nonatomic,strong) UILabel *textTinLabel;       //提示lael

@property (nonatomic,strong) NSMutableArray *showButtons;


@property (nonatomic, copy) NSString *savedPassword;    //密码

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger secNumber;

@property (nonatomic,strong) UIView *promptView;


@end

@implementation GesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"移除手势密码" style:UIBarButtonItemStylePlain target:self action:@selector(removeG)];
    
    
    // initData
    _secNumber = 0;
    _bSecondInput = NO;
    _nPasswordErrorNum = 0;
    _bHaveDraw = NO;
    _sudokuArray = [[NSMutableArray alloc]initWithCapacity:9];
    _showButtons = [[NSMutableArray alloc]initWithCapacity:9];
    
    [self createUI];
    [self createPromptView];
}


- (void)removeG
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturePassword"];
}


-(void)createUI
{
    
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
    [self.view addSubview:backgroundImageView];
    
    // 画布
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backgroundImageView];
    
    
    
    CGFloat mainHeight = SCREENHeight;
    CGFloat startY = 0;
    if (!self.navigationController.navigationBarHidden) {
        mainHeight -= 64;
        startY += 64;
    }
    
    //
    [self createTopViewWithFrame:CGRectMake(0, startY , SCREENWIDTH, mainHeight * 0.2)];
    
    
    // 创建九宫格
    [self createNineWithFrame:CGRectMake(0, mainHeight * 0.25 + startY, SCREENWIDTH, mainHeight * 0.5)];
    
    //
    [self createShowView:CGRectMake(0, mainHeight * 0.8 + startY, SCREENWIDTH, mainHeight * 0.2)];
 
}

- (void)createTopViewWithFrame:(CGRect)frame
{
    CGFloat titleFont = 23;
    CGFloat telFont = 18;
    CGFloat textTinFont = 16;
    if (MAXSIX) {
        titleFont = 25;
        telFont = 20;
        textTinFont = 18;
    }
    
    //
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height * 0.2 + frame.origin.y, SCREENWIDTH, frame.size.height * 0.3)];
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    if (gesturePasswrod) {
        titleLabel.text = @"绘制图案以解锁";
    }
    else
    {
        titleLabel.text = @"创建新的手势密码";
    }
    

    //
    UILabel *textTinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height * 0.6 + frame.origin.y, SCREENWIDTH, frame.size.height * 0.2)];
    textTinLabel.textAlignment = NSTextAlignmentCenter;
    textTinLabel.font = [UIFont systemFontOfSize:textTinFont];
    textTinLabel.textColor = [UIColor blackColor];
    textTinLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textTinLabel];
    _textTinLabel = textTinLabel;
}

-(void)createNineWithFrame:(CGRect)frame
{
    //
    CGFloat startY = frame.origin.y;
    CGFloat buttonSideGap = 25;
    CGFloat buttonUpDown = 25;
    CGFloat buttonWidth = (SCREENWIDTH - bothGap * 2 - buttonSideGap * 2) / 3;
    
    CGFloat perimeter = buttonWidth;
    
    for (int i = 0; i < 9; i++) {
        
        int line = i / 3;
        int num = i % 3;
        
        CGRect frame = CGRectMake( bothGap + num * (perimeter + buttonSideGap), startY + (perimeter + buttonUpDown) * line, perimeter, perimeter);
        
        UIButton *button = [[UIButton alloc]initWithFrame:frame];
        button.tag = kButton_tag + i;
        [button setBackgroundImage:[UIImage imageNamed:@"settingPassButt_nol"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"settingPassButt_sel"] forState:UIControlStateSelected];
        
        button.layer.cornerRadius = 20.0f;
        button.layer.masksToBounds = YES;
        button.userInteractionEnabled = NO;
        
        [self.view addSubview:button];
        
        [_sudokuArray addObject:button];
    }
}


- (void)createShowView:(CGRect)frame
{
    
    //
    CGFloat startY = frame.origin.y;
    CGFloat buttonSideGap = 8;
    CGFloat buttonUpDown = 8;
    CGFloat buttonWidth = 10;
    CGFloat showBothGap = (SCREENWIDTH - 3 * buttonWidth - 2 * buttonSideGap) * 0.5;
    
    
    for (int i = 0; i < 9; i++) {
        
        int line = i / 3;
        int num = i % 3;
        
        CGRect frame = CGRectMake( showBothGap + num * (buttonWidth + buttonSideGap), startY + (buttonWidth + buttonUpDown) * line, buttonWidth, buttonWidth);
        
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [[UIColor whiteColor] CGColor];
        view.layer.cornerRadius = buttonWidth * 0.45;
        view.tag = i;
        
        [self.view addSubview:view];
        [_showButtons addObject:view];
        
    }
}


- (void)createPromptView
{
    CGFloat titleFont = 14;
    if (MAXSIX) {
        titleFont = 16;
    }
    
    CGRect frame = CGRectMake(self.view.frame.size.width * 0.5 - 120, self.view.frame.size.height * 0.5 - 60, 240, 120);
    
    UIView *promptView = [[UIView alloc]initWithFrame:frame];
    promptView.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    promptView.layer.cornerRadius = 7.0f;
    _promptView = promptView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height * 0.1, frame.size.width - 16, frame.size.height * 0.4)];
    titleLabel.text  = @"您已连续输错3次密码，请30秒后再次尝试或其他方法";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [promptView addSubview:titleLabel];
    
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height * 0.5, frame.size.width - 16, frame.size.height * 0.4)];
    timerLabel.tag = 100;
    timerLabel.font = [UIFont systemFontOfSize:titleFont];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    [promptView addSubview:timerLabel];
    
}



#pragma mark -- touch
// 开始触碰
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resetShow];
    
    UITouch *touch = [touches anyObject];
    if (touch) {
        for (UIButton *btn in _sudokuArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                _bHaveDraw = YES;
                _linePointStart = btn.center;
                if (!_sudokuSelectButtons) {
                    _sudokuSelectButtons = [[NSMutableArray alloc]initWithCapacity:9];
                }
                [_sudokuSelectButtons addObject:btn];
                btn.selected = YES;
            }
        }
    }
}

// 触碰移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch && _bHaveDraw) {
        _linePointEnd = [touch locationInView:_backgroundImageView];
        for (UIButton *btn in _sudokuArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                BOOL btn_contained = NO;
                for (UIButton *b in _sudokuSelectButtons) {
                    if (b == btn) {
                        btn_contained = YES;
                        break;
                    }
                }
                if (!btn_contained) {
                    [_sudokuSelectButtons addObject:btn];
                    btn.selected = YES;
                    
                }
            }
            
        }
        
        _backgroundImageView.image = [self drawUnlockLine];
        //        [self drawUnlockLine];
    }
}

// 结束触碰
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_sudokuSelectButtons) {
        
        //业务逻辑
        [self outputTheResult];
        [self setShow];
        
        for (UIButton *selectButton in _sudokuSelectButtons) {
            selectButton.selected = NO;
        }
        
        _sudokuSelectButtons = nil;
        _bHaveDraw = NO;
        _backgroundImageView.image = nil;
    }
}


#pragma mark -- showView set
- (void)setShow
{
    if (_sudokuSelectButtons.count > 2) {
        
        NSMutableArray *selectNums = [NSMutableArray new];
        
        for (UIButton *btn in _sudokuSelectButtons) {
            
            [selectNums addObject:[NSNumber numberWithInteger:btn.tag - kButton_tag]];
        }
        
        NSLog(@"show  %@",selectNums);
        
        
        for (int i = 0; i < selectNums.count; i++) {
            
            NSInteger num = [selectNums[i] integerValue];
            NSLog(@"num   %ld",(long)num);
            for (UIView *view in _showButtons) {
                
                if (view.tag == num) {
                    view.backgroundColor = [UIColor blueColor];
                    NSLog(@"showtag  %ld",(long)view.tag);
                    break;
                }
            }
        }
        
    }
}


- (void)resetShow
{
    for (UIView *view in _showButtons) {
        view.backgroundColor = [UIColor clearColor];
    }
}



#pragma mark -- 检测是否设置成功
- (void)outputTheResult {
    NSString *inputString = [NSString stringWithFormat:@""];
    if(_sudokuSelectButtons.count > 2)
    {
        // 画线的数据
        for (UIButton *b in _sudokuSelectButtons)
        {
            b.selected = NO;
            
            inputString = [inputString stringByAppendingString:[NSString stringWithFormat:@"%ld",b.tag-kButton_tag]];
            
        }
        
        // 本地是否存储有手势锁密码
        if (gesturePasswrod)
        {
            if ([inputString isEqualToString:gesturePasswrod]) { //输入正确
                
                
                _textTinLabel.text = @"密码匹配成功";

            }
            else
            {
                _nPasswordErrorNum++;
                if (_nPasswordErrorNum < 3)
                {
                    _textTinLabel.text = [NSString stringWithFormat:@"密码错误%d次",_nPasswordErrorNum];
                }
                else
                {
                    _textTinLabel.text = [NSString stringWithFormat:@"密码错误%d次",_nPasswordErrorNum];
                    
                    [self errorAction];
                }
            }
        }
        else
        {
            if(_bSecondInput)
            { //第二次输入
                if([inputString isEqualToString:_savedPassword])
                {
                    _textTinLabel.text = nil;
                    
                    //保存数据
                    [[NSUserDefaults standardUserDefaults] setObject:_savedPassword forKey:@"gesturePassword"];
                    

                    
                    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
                        
                        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
                        [self presentViewController:alertView animated:YES completion:nil];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertView addAction:sureAction];
                    }
                    else
                    {
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"输出结果" message:@"设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alertView.tag = 0;
                        [alertView show];
                    }
                }
                else
                {
                    _textTinLabel.text = @"两次密码输入不一致，请重新输入";
                }
            }
            else
            {
                
                _textTinLabel.text = @"请再输入一次确认";
                _savedPassword = inputString;
            }
            _bSecondInput = !_bSecondInput;
        }
    }
    else
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"输出结果" message:@"您设置的密码太短，请至少设置3位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:sureAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"输出结果" message:@"您设置的密码太短，请至少设置3位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 0;
            [alertView show];
        }
    }
}


#pragma mark -- action
- (void)errorAction
{
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [[UIColor colorWithRed:50/255.0f green:50/255.0f blue:100/255.0f alpha:YES] colorWithAlphaComponent:0.3];
    
    [backView addSubview:_promptView];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    UILabel *label = (UILabel*)[_promptView viewWithTag:100];
    [label setText:@"30秒后重试"];
    
    _nPasswordErrorNum = 0;
    [self timer];
    
}



#pragma mark --  Timer
-(NSTimer *)timer
{
    _secNumber = 30;
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    }
    
    return _timer;
}


-(void)timeRun
{
    if (_secNumber > 1) {
        _secNumber -- ;
        NSString *string = [NSString stringWithFormat:@"%d秒后重试",(int)_secNumber];
        
        UILabel *label = (UILabel*)[_promptView viewWithTag:100];
        [label setText:string];
    }
    else
    {
        UILabel *label = (UILabel*)[_promptView viewWithTag:100];
        label.text = nil;
        [_promptView.superview removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        _textTinLabel.text = nil;
    }
}


#pragma mark -- 底部画线
- (UIImage*)drawUnlockLine {
    
    UIGraphicsBeginImageContext(_backgroundImageView.frame.size);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_linePointStart.x, _linePointStart.y)];
    for (UIButton *btn in _sudokuSelectButtons) {
        CGPoint point = btn.center;
        [path addLineToPoint:CGPointMake(point.x, point.y)];
    }
    [path addLineToPoint:CGPointMake(_linePointEnd.x, _linePointEnd.y)];
    path.lineWidth = 3;
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}




#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%ld",(long)buttonIndex);
    
    if(1001 == alertView.tag) {
        
    }
    else{
        _savedPassword = nil;
        _bSecondInput = NO;
        
    }
}

@end

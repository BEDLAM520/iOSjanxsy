//
//  HMViewController.m
//  02-本地推送通知
//
//  Created by apple on 14-8-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"
#import "HMDetailViewController.h"

@interface HMViewController ()
- (IBAction)schedule;
- (IBAction)cancel;
@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)schedule2 {
    // 1.创建本地推送通知对象
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    
    // 2.设置通知属性
    
    // 音效文件名
    ln.soundName = @"buyao.wav";
    
    // 通知的具体内容
    ln.alertBody = @"重大新闻：xxxx xxxx被调查了....";
    
    // 锁屏界面显示的小标题（"滑动来" + alertAction）
    ln.alertAction = @"查看新闻吧";
    
    // 设置app图标数字
    ln.applicationIconBadgeNumber = 10;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:ln];
}

- (IBAction)schedule {
    // 1.创建本地推送通知对象
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    
    // 2.设置通知属性
    // 音效文件名
    ln.soundName = @"buyao.wav";
    
    // 通知的具体内容
    ln.alertBody = @"重大新闻：xxxx xxxx被调查了....";
    
    // 锁屏界面显示的小标题（"滑动来" + alertAction）
    ln.alertAction = @"查看新闻吧";
    
    // 通知第一次发出的时间(5秒后发出)
    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    // 设置时区（跟随手机的时区）
    ln.timeZone = [NSTimeZone defaultTimeZone];
    
    // 设置app图标数字
    ln.applicationIconBadgeNumber = 5;
    
    // 设置通知的额外信息
    ln.userInfo = @{
                    @"icon" : @"test.png",
                    @"title" : @"重大新闻",
                    @"time" : @"2014-08-14 11:19",
                    @"body" : @"重大新闻:答复后即可更换就肯定会尽快赶快回家的疯狂估计很快将发的"
                    };
    
    // 设置启动图片
    ln.alertLaunchImage = @"Default";
    
    // 设置重复发出通知的时间间隔
//    ln.repeatInterval = NSCalendarUnitMinute;
    
    // 3.调度通知（启动任务）
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

- (IBAction)cancel {
    NSArray *notes = [UIApplication sharedApplication].scheduledLocalNotifications;
    NSLog(@"%@", notes);
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UILocalNotification *)note
{
    HMDetailViewController *detailVc = segue.destinationViewController;
    detailVc.userInfo = note.userInfo;
}
@end

//
//  HMAppDelegate.m
//  02-本地推送通知
//
//  Created by apple on 14-8-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMAppDelegate.h"
#import "HMViewController.h"

@interface HMAppDelegate()
@property (nonatomic, weak) UILabel *label;
@end

@implementation HMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    NSLog(@"------didFinishLaunchingWithOptions---%@");
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    label.frame = CGRectMake(0, 100, 200, 100);
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 0;
    [[[self.window.rootViewController.childViewControllers firstObject] view] addSubview:label];
    
    UILocalNotification *note = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (note) {
        label.text = @"点击本地通知启动的程序";
        
        HMViewController *homeVc = [self.window.rootViewController.childViewControllers firstObject];
        [homeVc performSegueWithIdentifier:@"home2detail" sender:note];
    } else {
        label.text = @"直接点击app图标启动的程序";
    }
    self.label = label;
    return YES;
}

/**
 *  当用户点击本地通知进入app的时候调用 、通知发出的时候（app当时并没有被关闭）
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    self.label.text = [NSString stringWithFormat:@"点击通知再次回到前台---%d", application.applicationState];
    // 程序正处在前台运行，直接返回
    if (application.applicationState == UIApplicationStateActive) return;
    
    HMViewController *homeVc = [self.window.rootViewController.childViewControllers firstObject];
    [homeVc performSegueWithIdentifier:@"home2detail" sender:notification];
}

@end

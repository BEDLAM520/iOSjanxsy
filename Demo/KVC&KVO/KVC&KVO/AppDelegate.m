//
//  AppDelegate.m
//  KVC&KVO
//
//  Created by  user on 2018/8/31.
//  Copyright © 2018  user. All rights reserved.
//

#import "AppDelegate.h"

@interface Person: NSObject
{
    @private
    int _age;
}

@property (nonatomic, copy,readonly) NSString *name;
@property (nonatomic, assign, getter=isMale) BOOL male;
@end

@interface AppDelegate ()

@end

@implementation Person

@end


@interface NSKVONotifying_Person: NSObject {
    
}

@end
@implementation NSKVONotifying_Person
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    Person *per = [Person new];
    NSLog(@"%d",per.isMale);
    [per setValue:@"jack" forKey:@"name"];
    
    [per setValue:@123 forKey:@"age"];
    [per setValue:@1 forKey:@"male"];
    
    NSLog(@"%@  %d  %d",per.name, per.isMale, per.male);
    NSLog(@"%@  %d  %d",[per valueForKey:@"_name"], [[per valueForKey:@"_age"] intValue], [[per valueForKey:@"isMale"] boolValue]);
    NSLog(@"%@  %d  %d",[per valueForKey:@"name"], [[per valueForKey:@"age"] intValue], [[per valueForKey:@"male"] boolValue]);
    
    [per addObserver:self forKeyPath:@"male" options:NSKeyValueObservingOptionNew context:nil];
    per.male = false;
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"----  %@  %@  %@",keyPath, object, change);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

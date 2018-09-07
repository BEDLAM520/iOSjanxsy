//
//  AppDelegate.m
//  RuntimeDemo
//
//  Created by  user on 2018/3/29.
//  Copyright © 2018年 NG. All rights reserved.
//

#import "AppDelegate.h"
#import "School.h"
#import <objc/runtime.h>
#import "Person.h"
#import "NSObject+Extension.h"
#import <UIKit/UIKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self deepTest];
    NSLog(@"\n-----------------------------------------------");
    [self testRunTime];
     NSLog(@"NSObject' meta class is %p   %p",objc_getClass((__bridge void*)[NSObject class]),[NSObject class]);
    return YES;
}

- (void)deepTest {
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Person class] isKindOfClass:[Person class]];
    BOOL res4 = [(id)[Person class] isMemberOfClass:[Person class]];
    
    NSLog(@"%@  %@  %@  %@",(id)[NSObject class], [NSObject class], (id)[Person class], [Person class]);
    NSLog(@"result  %d  %d  %d  %d",res1,res2,res3,res4);
    
    [NSObject foo];
    [[NSObject new] foo];
    
}


- (void)testRunTime {
    School *school = [School new];
    Class cls = school.class;
    
    [school startOpen];
    
    NSLog(@"class name %s",class_getName(cls));
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"School is a meta-class? %@",(class_isMetaClass(cls) ? @"yess" : @"no"));
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s",class_getName(cls), class_getName(meta_class));
    NSLog(@"instance size: %zu",class_getInstanceSize(cls));
    
    // 不起作用
    class_addIvar([School class], "height", sizeof(double), log(sizeof(double)), "f");
    
    // 成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i<outCount;i++){
        Ivar ivar = ivars[i];
        NSLog(@"instance variabel's name: %s",ivar_getName(ivar));
    }
    free(ivars);
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1:));
    imp(school,  @selector(method1:), 18);
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");
    
    
    //
    //    if ([school respondsToSelector:@selector(hello)]) {
    //        NSLog(@"call hello");
    //        [school performSelector:@selector(hello)];
    //    }
    
    [school performSelector:@selector(hello)];
    
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

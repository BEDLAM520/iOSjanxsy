//
//  Person.m
//  RuntimeDemo
//
//  Created by  user on 2018/8/24.
//  Copyright © 2018 NG. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"---1   %@",NSStringFromClass([self class]));
        NSLog(@"---2   %@",NSStringFromClass([super class]));
    }
    return self;
}

- (void)speak {
    NSLog(@"my name's %@",self.name);
}

+ (void)temp {
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Person class] isKindOfClass:[Person class]];
    BOOL res4 = [(id)[Person class] isMemberOfClass:[Person class]];
    
    NSLog(@"%@  %@  %@  %@",(id)[NSObject class], [NSObject class], (id)[Person class], [Person class]);
    NSLog(@"result  %d  %d  %d  %d",res1,res2,res3,res4);
}

@end

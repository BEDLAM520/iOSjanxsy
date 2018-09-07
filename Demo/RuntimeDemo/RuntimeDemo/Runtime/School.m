//
//  School.m
//  RuntimeDemo
//
//  Created by  user on 2018/8/23.
//  Copyright © 2018 NG. All rights reserved.
//

#import "School.h"
#import <objc/runtime.h>
#import "ClassRoom.h"
@implementation School
- (void)startOpen {
    NSLog(@"++1  %@  ",self.class);
    NSLog(@"++2  %@  ",super.class);
    [self registerClassPair];
}

+ (NSString *)getSchoolName {
    return @"";
}

- (void)method1:(NSInteger)age {
    NSLog(@"my age is %d",age);
}

void Test(id self, SEL _cmd) {
    NSLog(@"this object point: %p",self);
    NSLog(@"class: %@, super class: %@",[self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i<4; i++) {
        NSLog(@"isa point: %d,  class point: %p",i, currentClass);
        currentClass = objc_getClass((__bridge void*)currentClass);
    }
    
    NSLog(@"NSObject's class is %p",[NSObject class]);
    NSLog(@"NSObject' meta class is %p",objc_getClass((__bridge void*)[NSObject class]));
    
//    在for循环中，我们通过objc_getClass来获取对象的isa，并将其打印出来，依此一直回溯到NSObject的meta-class。分析打印结果，可以看到最后指针指向的地址是0x0，即NSObject的meta-class的类地址。
}

void imp_submethod1(id self, SEL _cmd) {
    NSLog(@"call func imp_submethod1");
}

- (void)registerClassPair {
    // 这个例子是在运行时创建了一个NSError的子类Test
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(Test), (IMP)Test, "v@:");
    class_replaceMethod(newClass, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(newClass, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(newClass, "property2", attrs, 3);
    objc_registerClassPair(newClass);

    
//    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
//    id instance = [newClass new];
    id instance = class_createInstance([newClass class], sizeof([newClass class]));
    [instance performSelector:@selector(Test)];
    [instance performSelector:@selector(method1)];
    // [TestClass imp_submethod1]: unrecognized selector sent to instance
    // [instance performSelector:@selector(imp_submethod1)];
    
    /*
     this object point: 0x600000644530
     class: TestClass, super class: NSError
     isa point: 0,  class point: 0x6000006445f0
     isa point: 1,  class point: 0x0
     isa point: 2,  class point: 0x0
     isa point: 3,  class point: 0x0
     NSObject's class is 0x105d9cea8
     NSObject' meta class is 0x0
     call func imp_submethod1
     */
}

void replaceMethod(id self, SEL _cmd) {
    NSLog(@"replace unrecognize selector");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(hello)) {
        NSLog(@"use resolveInstanceMethod solution");
        class_addMethod([self class], sel, (IMP)replaceMethod, "v@:");
        return true;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if(aSelector == @selector(hello)) {
        NSLog(@"use forwardingTargetForSelector solution");
        return [ClassRoom new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signatrue = [super methodSignatureForSelector:aSelector];
    NSLog(@"methodSignatureForSelector   %@",signatrue);
    if (!signatrue) {
        if([ClassRoom instancesRespondToSelector:aSelector]) {
            signatrue = [ClassRoom instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signatrue;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation %@",NSStringFromSelector(anInvocation.selector));
    NSLog(@"use forwardInvocation solution");
    
    ClassRoom *room = [ClassRoom new];
    if([room respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:room];
    } else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
}

@end

//
//  School.h
//  RuntimeDemo
//
//  Created by  user on 2018/8/23.
//  Copyright © 2018 NG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)NSInteger classCount;
@property (nonatomic,assign)double width;

-(void)startOpen;
+(NSString*)getSchoolName;
- (void)method1:(NSInteger)age;
@end

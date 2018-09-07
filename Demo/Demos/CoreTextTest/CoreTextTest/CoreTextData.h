//
//  CoreTextData.h
//  CoreTextTest
//
//  Created by liaonaigang on 16/6/15.
//  Copyright © 2016年 gangnailiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSAttributedString *content;


@end

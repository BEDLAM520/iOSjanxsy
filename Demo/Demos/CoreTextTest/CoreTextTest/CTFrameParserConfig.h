//
//  CTFrameParserConfig.h
//  CoreTextTest
//
//  Created by liaonaigang on 16/6/14.
//  Copyright © 2016年 gangnailiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end

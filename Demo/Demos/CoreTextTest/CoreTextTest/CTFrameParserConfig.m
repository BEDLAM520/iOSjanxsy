//
//  CTFrameParserConfig.m
//  CoreTextTest
//
//  Created by liaonaigang on 16/6/14.
//  Copyright © 2016年 gangnailiao. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}


@end

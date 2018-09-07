//
//  CTFrameParser.h
//  CoreTextTest
//
//  Created by liaonaigang on 16/6/15.
//  Copyright © 2016年 gangnailiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject


+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;
+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config;
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(CTFrameParserConfig *)config
                                  height:(CGFloat)height;
@end

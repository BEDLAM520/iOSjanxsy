//
//  ViewController.m
//  CoreTextTest
//
//  Created by liaonaigang on 16/6/14.
//  Copyright © 2016年 gangnailiao. All rights reserved.
//

#import "ViewController.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "CTDisplayView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CTDisplayView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
//    config.textColor = [UIColor redColor];
//    config.width = self.displayView.frame.size.width;
//    
//    CoreTextData *data = [CTFrameParser parseContent:@" 按照以上原则，我们将`CTDisplayView`中的部分内容拆开。" config:config];
//    self.displayView.data = data;
//    
//    CGRect frame = self.displayView.frame;
//    frame.size.height = data.height;
//    self.displayView.frame = frame;

    
    
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = self.displayView.frame.size.width;
    config.textColor = [UIColor blackColor];
    
    NSString *content =
    @" 对于上面的例子，我们给 CTFrameParser 增加了一个将 NSString 转 "
    " 换为 CoreTextData 的方法。"
    " 但这样的实现方式有很多局限性，因为整个内容虽然可以定制字体 "
    " 大小，颜色，行高等信息，但是却不能支持定制内容中的某一部分。"
    " 例如，如果我们只想让内容的前三个字显示成红色，而其它文字显 "
    " 示成黑色，那么就办不到了。"
    "\n\n"
    " 解决的办法很简单，我们让`CTFrameParser`支持接受 "
    "NSAttributeString 作为参数，然后在 NSAttributeString 中设置好 "
    " 我们想要的信息。";
    NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:content
                                           attributes:attr];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, 7)];
    
    CoreTextData *data = [CTFrameParser parseAttributedContent:attributedString
                                                        config:config];
    self.displayView.data = data;

    CGRect frame = self.displayView.frame;
    frame.size.height = data.height;
    self.displayView.frame = frame;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

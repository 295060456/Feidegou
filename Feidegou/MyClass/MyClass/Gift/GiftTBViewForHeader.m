//
//  GiftTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/12/2.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GiftTBViewForHeader.h"

@interface GiftTBViewForHeader ()

@property(nonatomic,strong)YYLabel *titleLab;

@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;

@end

@implementation GiftTBViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        if ([data isKindOfClass:[NSString class]]) {
            self.str = (NSString *)data;
        }
    }return self;
}

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

-(void)drawRect:(CGRect)rect{
    if (![NSString isNullString:self.str]) {
        self.titleLab.attributedText = self.attributedString;
    }
}

#pragma mark —— lazyLoad
-(YYLabel *)titleLab{
    if (!_titleLab) {
        _titleLab = YYLabel.new;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        _titleLab.attributedText = self.attributedString;
        [_titleLab sizeToFit];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _titleLab;
}

-(NSMutableAttributedString *)attributedString{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineSpacing = 1;//行间距
    paragraphStyle.firstLineHeadIndent = 20;//首行缩进
    
    NSDictionary *attributeDic = @{
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : kRedColor
    };
    if (!_attributedString) {
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];
    }else{
        _attributedString = Nil;
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];
    }
        NSRange selRange_01 = [self.str rangeOfString:@"可以赠送的喵粮数量:"];//location=0, length=2
        NSRange selRange_02 = [self.str rangeOfString:@"g"];//location=6, length=2

        //设定可点击文字的的大小
        UIFont *selFont = [UIFont systemFontOfSize:16];
        CTFontRef selFontRef = CTFontCreateWithName((__bridge CFStringRef)selFont.fontName,
                                                    selFont.pointSize,
                                                    NULL);
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_01];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_01];
#warning 打开注释部分会崩，之前都不会崩溃，怀疑是升级Xcode所致
                 //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_01];
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_02];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_02];
        //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_02];
        //        } else {
        //            // Fallback on earlier versions
        //        }
    return _attributedString;
}

@end

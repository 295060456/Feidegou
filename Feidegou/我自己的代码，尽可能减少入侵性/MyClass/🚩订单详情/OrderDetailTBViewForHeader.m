//
//  OrderDetailTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/11/18.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailTBViewForHeader.h"

@interface OrderDetailTBViewForHeader (){
    
}

@property(nonatomic,strong)YYLabel *titleLab;
@property(nonatomic,strong)UIImageView *tipsIMGV;

@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;

@end

@implementation OrderDetailTBViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        if ([data isKindOfClass:[NSString class]]) {
            self.str = (NSString *)data;
        }
    }return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"");
}

-(void)drawRect:(CGRect)rect{
    self.tipsIMGV.alpha = 1;
    if (![NSString isNullString:self.str]) {
        self.titleLab.attributedText = self.attributedString;
    }
}
#pragma mark —— lazyLoad
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
        NSRange selRange_01 = [self.str rangeOfString:@"您向"];//location=0, length=2
        NSRange selRange_02 = [self.str rangeOfString:@"购买"];//location=6, length=2

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

-(YYLabel *)titleLab{
    if (!_titleLab) {
        _titleLab = YYLabel.new;
//        _titleLab.backgroundColor = kRedColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        _titleLab.attributedText = self.attributedString;
//        _titleLab.lineBreakMode = NSLineBreakByCharWrapping;//？？
        [_titleLab sizeToFit];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
        }];
    }return _titleLab;
}

-(UIImageView *)tipsIMGV{
    if (!_tipsIMGV) {
        _tipsIMGV = UIImageView.new;
        _tipsIMGV.image = kIMG(@"电 话");
        [self addSubview:_tipsIMGV];
        [_tipsIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-SCALING_RATIO(20));
            make.size.mas_equalTo(CGSizeMake(self.mj_h / 1.5, self.mj_h / 1.5));
        }];
    }return _tipsIMGV;
}


@end

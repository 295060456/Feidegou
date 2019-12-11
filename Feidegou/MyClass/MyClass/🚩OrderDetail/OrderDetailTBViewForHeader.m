//
//  OrderDetailTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/11/18.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailTBViewForHeader.h"

@interface OrderDetailTBViewForHeader (){
    NSRange selRange_01;
    NSRange selRange_02;
}

@property(nonatomic,strong)YYLabel *titleLab;

@property(nonatomic,copy)NSMutableAttributedString *attributedString;
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

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

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(80);
}

-(void)headerViewWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[OrderDetailModel class]]) {
        self.orderDetailModel = (OrderDetailModel *)model;
//        self.orderDetailModel.countDownStr;
////        order_status;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
////        del_state;//撤销状态 0、不影响（驳回）;1、待审核;2、已通过
        if (self.orderDetailModel.order_status.intValue == 2 &&
            self.orderDetailModel.del_state.intValue == 1) {
            self.tipsBtn.alpha = 1;//取消中
        }else{
            self.tipsBtn.alpha = 0;
        }
    }
    if (![NSString isNullString:self.str]) {
        self.titleLab.attributedText = self.attributedString;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)drawRect:(CGRect)rect{

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
    selRange_01 = [self.str rangeOfString:@"您向"];//location=0, length=2
//    order_type;//订单类型 1、直通车;2、批发;3、产地
    if (self.orderDetailModel.order_type.intValue == 1) {
        selRange_02 = [self.str rangeOfString:@"出售"];
    }else if (self.orderDetailModel.order_type.intValue == 3){
        selRange_02 = [self.str rangeOfString:@"购买"];
    }else{}
//    selRange_02 = [self.str rangeOfString:@"出售"];
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
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(30));
        }];
    }return _titleLab;
}

-(MMButton *)tipsBtn{
    if (!_tipsBtn) {
        _tipsBtn = MMButton.new;
//        _tipsBtn.backgroundColor = kRedColor;
         [_tipsBtn setImage:kIMG(@"contact")
                  forState:UIControlStateNormal];
         _tipsBtn.imageAlignment = MMImageAlignmentTop;
        if (@available(iOS 8.2, *)) {
            _tipsBtn.titleLabel.font = [UIFont systemFontOfSize:7 weight:1];
        } else {
            // Fallback on earlier versions
            _tipsBtn.titleLabel.font = [UIFont systemFontOfSize:7];
        }
         _tipsBtn.spaceBetweenTitleAndImage = SCALING_RATIO(5);
         [_tipsBtn setTitleColor:COLOR_HEX(0x7D7D7D, 1)
                       forState:UIControlStateNormal];
         [self.contentView addSubview:_tipsBtn];
        _tipsBtn.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(110),
                                    SCALING_RATIO(15),
                                    SCALING_RATIO(8),
                                    SCALING_RATIO(8));
#warning tpis 这个地方用masonry找不到更好的时机去刷新
//         [_tipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.top.equalTo(self);
//             make.right.equalTo(self).offset(-SCALING_RATIO(50));
//             make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(30), SCALING_RATIO(30)));
//             //            make.size.mas_equalTo(CGSizeMake(self.mj_h / 1.5, self.mj_h / 1.5));
//         }];
//        [self layoutIfNeeded];
        [_tipsBtn setTitle:@"联系买家"
                  forState:UIControlStateNormal];
        [_tipsBtn sizeToFit];
        _tipsBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }return _tipsBtn;
}

-(void)setStr:(NSString *)str{
    _str = str;
    if (![NSString isNullString:str]) {
        if ([str containsString:@"出售"]) {
            selRange_02 = [self.str rangeOfString:@"出售"];
        }else if ([str containsString:@"购买"]){
            selRange_02 = [self.str rangeOfString:@"购买"];
        }else{}
        self.titleLab.attributedText = self.attributedString;
    }
}

@end

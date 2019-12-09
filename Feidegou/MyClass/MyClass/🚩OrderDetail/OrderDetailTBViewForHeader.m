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
@property(nonatomic,strong)MMButton *tipsBtn;

@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;
@property(nonatomic,strong)OrderManager_panicBuyingModel *orderManager_panicBuyingModel;
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;
@property(nonatomic,strong)OrderManager_producingAreaModel *orderManager_producingAreaModel;

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
    if ([model isKindOfClass:[OrderManager_panicBuyingModel class]]) {
        self.orderManager_panicBuyingModel = (OrderManager_panicBuyingModel *)model;

    }else if ([model isKindOfClass:[OrderDetailModel class]]){
        self.orderDetailModel = (OrderDetailModel *)model;

    }else if ([model isKindOfClass:[CatFoodProducingAreaModel class]]){
        self.catFoodProducingAreaModel = (CatFoodProducingAreaModel *)model;
    }else if ([model isKindOfClass:[OrderManager_producingAreaModel class]]){
        self.orderManager_producingAreaModel = (OrderManager_producingAreaModel *)model;
    }
    else{}
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)drawRect:(CGRect)rect{
    if (self.orderManager_panicBuyingModel) {
        if (self.orderManager_panicBuyingModel.order_status.intValue == 2 &&
            self.orderManager_panicBuyingModel.del_state.intValue == 1) {
            self.tipsBtn.alpha = 1;
        }else{
            self.tipsBtn.alpha = 0;
        }
    }else if (self.orderDetailModel){
        if(self.orderDetailModel.order_status.intValue == 2 &&
        (self.orderDetailModel.del_state.intValue == 1 ||
         self.orderDetailModel.del_state.intValue == 0)){
            self.tipsBtn.alpha = 1;
        }else{
            self.tipsBtn.alpha = 0;
        }
    }else{
        self.tipsBtn.alpha = 0;
    }
    
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
    NSRange selRange_02;
    if (self.orderDetailModel) {
        selRange_02 = [self.str rangeOfString:@"出售"];//location=6, length=2
    }
    else if (self.orderManager_panicBuyingModel){
        selRange_02 = [self.str rangeOfString:@"出售"];//location=6, length=2
    }
    else if (self.catFoodProducingAreaModel){
        selRange_02 = [self.str rangeOfString:@"购买"];
    }else if (self.orderManager_producingAreaModel){
        selRange_02 = [self.str rangeOfString:@"购买"];
    }else{
        
    }
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
            make.centerY.equalTo(self.tipsBtn);
        }];
    }return _titleLab;
}

-(MMButton *)tipsBtn{
    if (!_tipsBtn) {
        _tipsBtn = MMButton.new;
//        _tipsBtn.backgroundColor = kRedColor;
         [_tipsBtn setImage:kIMG(@"contact")
                  forState:UIControlStateNormal];
//        _tipsBtn.titleLabel.font = [UIFont systemFontOfSize:<#(CGFloat)#> weight:<#(UIFontWeight)#>];
         _tipsBtn.imageAlignment = MMImageAlignmentTop;
         _tipsBtn.spaceBetweenTitleAndImage = SCALING_RATIO(5);
         [_tipsBtn setTitleColor:COLOR_HEX(0x7D7D7D, 1)
                       forState:UIControlStateNormal];
         [self.contentView addSubview:_tipsBtn];
        _tipsBtn.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(110),
                                    SCALING_RATIO(15),
                                    SCALING_RATIO(13),
                                    SCALING_RATIO(13));
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

@end

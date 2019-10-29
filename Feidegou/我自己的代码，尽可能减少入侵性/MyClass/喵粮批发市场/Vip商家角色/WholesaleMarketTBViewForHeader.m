//
//  WholesaleMarketTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarketTBViewForHeader.h"

@interface WholesaleMarketTBViewForHeader ()<UIScrollViewDelegate>{
    
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)MMButton *orderIdBtn;//订单号
@property(nonatomic,strong)MMButton *numBtn;//数量
@property(nonatomic,strong)MMButton *priceBtn;//单价
@property(nonatomic,strong)MMButton *typeBtn;//类型
@property(nonatomic,strong)MMButton *styleBtn;//状态
@property(nonatomic,strong)NSMutableArray <MMButton *>*btnMutArr;
@property(nonatomic,copy)DataBlock block;

@end

@implementation WholesaleMarketTBViewForHeader

-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"");
}

-(void)drawRect:(CGRect)rect{
    self.scrollView.alpha = 1;
    self.scrollView.backgroundColor = KLightTextColor;
    for (int i = 0; i < self.btnMutArr.count; i++) {
        [self.btnMutArr[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            [self layoutIfNeeded];
        }];
    }//得到每个btn的size
    //计算btn之间的相隔距离
   __block CGFloat width = 0;
    for (int i = 0; i < self.btnMutArr.count; i++) {
        width += self.btnMutArr[i].mj_w;
    }
    self.scrollView.contentSize = CGSizeMake(width, self.mj_h);
    width = (self.scrollView.mj_w - width) / self.btnMutArr.count;
    //加约束
    for (int i = 0; i < self.btnMutArr.count; i++) {
        [self.btnMutArr[i] mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.scrollView).offset(width / 2);
            }else{
                make.left.equalTo(self.btnMutArr[i - 1].mas_right).offset(width);
            }
        }];
    }
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

#pragma mark —— 点击事件
-(void)btnClickEvent:(MMButton *)sender{
    if (self.block) {
        self.block(sender);
    }
}
#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
//        _scrollView.backgroundColor = KYellowColor;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _scrollView;
}

-(MMButton *)orderIdBtn{
    if (!_orderIdBtn) {
        _orderIdBtn = MMButton.new;
        _orderIdBtn.tag = 0;
        [_orderIdBtn addTarget:self
                        action:@selector(btnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [_orderIdBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_orderIdBtn setTitle:@"订单号"
                     forState:UIControlStateNormal];
        [_orderIdBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_orderIdBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_orderIdBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _orderIdBtn.imageAlignment = MMImageAlignmentRight;
        _orderIdBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_orderIdBtn.titleLabel sizeToFit];
        _orderIdBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_orderIdBtn];
    }return _orderIdBtn;
}

-(MMButton *)numBtn{
    if (!_numBtn) {
        _numBtn = MMButton.new;
        _numBtn.tag = 1;
        [_numBtn addTarget:self
                    action:@selector(btnClickEvent:)
          forControlEvents:UIControlEventTouchUpInside];
        [_numBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_numBtn setTitle:@"数量"
                     forState:UIControlStateNormal];
        [_numBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_numBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_numBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _numBtn.imageAlignment = MMImageAlignmentRight;
        _numBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_numBtn.titleLabel sizeToFit];
        _numBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_numBtn];
    }return _numBtn;
}

-(MMButton *)priceBtn{
    if (!_priceBtn) {
        _priceBtn = MMButton.new;
        _priceBtn.tag = 2;
        [_priceBtn addTarget:self
                      action:@selector(btnClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [_priceBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_priceBtn setTitle:@"单价"
                     forState:UIControlStateNormal];
        [_priceBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_priceBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_priceBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _priceBtn.imageAlignment = MMImageAlignmentRight;
        _priceBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_priceBtn.titleLabel sizeToFit];
        _priceBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_priceBtn];
    }return _priceBtn;
}

-(MMButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = MMButton.new;
        _typeBtn.tag = 3;
        [_typeBtn addTarget:self
                     action:@selector(btnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_typeBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_typeBtn setTitle:@"类型"
                     forState:UIControlStateNormal];
        [_typeBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_typeBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_typeBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _typeBtn.imageAlignment = MMImageAlignmentRight;
        _typeBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_typeBtn.titleLabel sizeToFit];
        _typeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_typeBtn];
    }return _typeBtn;
}

-(MMButton *)styleBtn{
    if (!_styleBtn) {
        _styleBtn = MMButton.new;
        _styleBtn.tag = 4;
        [_styleBtn addTarget:self
                      action:@selector(btnClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [_styleBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_styleBtn setTitle:@"状态"
                     forState:UIControlStateNormal];
        [_styleBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_styleBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_styleBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _styleBtn.imageAlignment = MMImageAlignmentRight;
        _typeBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_styleBtn.titleLabel sizeToFit];
        _styleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_styleBtn];
    }return _styleBtn;
}

-(NSMutableArray<MMButton *> *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = NSMutableArray.array;
        [_btnMutArr addObject:self.orderIdBtn];
        [_btnMutArr addObject:self.numBtn];
        [_btnMutArr addObject:self.priceBtn];
        [_btnMutArr addObject:self.typeBtn];
        [_btnMutArr addObject:self.styleBtn];
    }return _btnMutArr;
}

@end

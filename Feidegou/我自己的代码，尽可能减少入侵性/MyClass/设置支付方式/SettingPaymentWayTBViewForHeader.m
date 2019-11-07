//
//  SettingPaymentWayTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SettingPaymentWayTBViewForHeader.h"

@interface SettingPaymentWayTBViewForHeader ()
<
BEMCheckBoxDelegate
>

@property(nonatomic,strong)BEMCheckBox *checkBox;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)NSString *titleStr;;

@end

@implementation SettingPaymentWayTBViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        if ([data isKindOfClass:[NSString class]]) {
            self.titleStr = (NSString *)data;
            self.checkBox.alpha = 1;
            self.titleLab.alpha = 1;
        }
    }return self;
}
#pragma mark —— lazyLoad
-(BEMCheckBox *)checkBox{
    if (!_checkBox) {
        _checkBox = BEMCheckBox.new;
        // 矩形复选框
        _checkBox.boxType = BEMBoxTypeSquare;
        _checkBox.delegate = self;
        // 动画样式
        _checkBox.onAnimationType  = BEMAnimationTypeBounce;
        _checkBox.offAnimationType = BEMAnimationTypeBounce;
        _checkBox.animationDuration = 0.3;
        // 颜色样式
        _checkBox.tintColor    = kBlueColor;
        _checkBox.onTintColor  = kWhiteColor;
        _checkBox.onFillColor  = kRedColor;
        _checkBox.onCheckColor = kWhiteColor;
        _checkBox.on = YES;
        [self addSubview:_checkBox];
        [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(SCALING_RATIO(-50));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(30), SCALING_RATIO(30)));
        }];
    }return _checkBox;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = self.titleStr;
        [_titleLab sizeToFit];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.checkBox.mas_right).offset(SCALING_RATIO(10));
            make.top.bottom.equalTo(self.checkBox);
        }];
    }return _titleLab;
}



@end

//
//  PersonalDataChangedListTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "PersonalDataChangedListTBViewForHeader.h"

@interface PersonalDataChangedListTBViewForHeader ()

@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation PersonalDataChangedListTBViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        if ([data isKindOfClass:[NSString class]]) {
            
        }
    }return self;
}

-(void)drawRect:(CGRect)rect{
    self.titleLab.alpha = 1;
}

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(30);
}

-(void)headerViewWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[PersonalDataChangedListModel class]]) {
        PersonalDataChangedListModel *personalDataChangedListModel = (PersonalDataChangedListModel *)model;
        self.titleLab.text = personalDataChangedListModel.addTime;
    }
}

#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.textColor = KLightGrayColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _titleLab;
}

@end

//
//  LookUpContactWayTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/11/26.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "LookUpContactWayTBViewForHeader.h"

@interface LookUpContactWayTBViewForHeader ()
<
TXScrollLabelViewDelegate
>

@property(nonatomic,strong)UIImageView *tipsIMGV;
@property(nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property(nonatomic,copy)NSString *str;

@end

@implementation LookUpContactWayTBViewForHeader

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

-(void)headerViewWithModel:(id _Nullable)model{
    
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"");
    self.scrollLabelView.alpha = 1;
}
#pragma mark —— TXScrollLabelViewDelegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView
       didClickWithText:(NSString *)text
                atIndex:(NSInteger)index{
    
}
#pragma mark —— lazyLoad
-(UIImageView *)tipsIMGV{
    if (!_tipsIMGV) {
        _tipsIMGV = UIImageView.new;
        _tipsIMGV.image = kIMG(@"telephone");
        [self addSubview:_tipsIMGV];
        [_tipsIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-SCALING_RATIO(20));
            make.size.mas_equalTo(CGSizeMake(self.mj_h / 1.5, self.mj_h / 1.5));
        }];
    }return _tipsIMGV;
}

-(TXScrollLabelView *)scrollLabelView{
    if (!_scrollLabelView) {
        _scrollLabelView = [TXScrollLabelView scrollWithTitle:self.str
                                                         type:TXScrollLabelViewTypeLeftRight
                                                     velocity:.5f
                                                      options:UIViewAnimationOptionCurveEaseInOut];
        _scrollLabelView.scrollLabelViewDelegate = self;
        _scrollLabelView.scrollTitleColor = kBlackColor;
        _scrollLabelView.backgroundColor = kWhiteColor;
        _scrollLabelView.frame = CGRectMake(0,
                                            0,
                                            self.mj_w,
                                            self.mj_h);
        [self addSubview:_scrollLabelView];
        [_scrollLabelView beginScrolling];
    }return _scrollLabelView;
}


@end

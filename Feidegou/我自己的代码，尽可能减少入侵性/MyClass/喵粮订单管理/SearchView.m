//
//  SearchView.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
<
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation SearchView

-(void)drawRect:(CGRect)rect{
    self.scrollView.alpha = 1;
    for (int i = 0; i < self.btnTitleMutArr.count; i++) {
        MMButton *btn = MMButton.new;
        [btn setTitle:self.btnTitleMutArr[i]
             forState:UIControlStateNormal];
        [btn setImage:kIMG(@"双向箭头_1")
             forState:UIControlStateNormal];
        [btn setImage:kIMG(@"双向箭头_2")
             forState:UIControlStateSelected];
        btn.imageAlignment = MMImageAlignmentRight;
        btn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [btn.titleLabel sizeToFit];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self
                action:@selector(MMButtonClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kBlackColor
                  forState:UIControlStateNormal];
        [self addSubview:btn];
    
    }
}

-(void)MMButtonClickEvent:(MMButton *)sender{
    
}

#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + SCALING_RATIO(150), self.mj_h);
//        _scrollView.backgroundColor = KYellowColor;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _scrollView;
}

-(NSMutableArray<NSString *> *)btnTitleMutArr{
    if (!_btnTitleMutArr) {
        _btnTitleMutArr = NSMutableArray.array;
        [_btnTitleMutArr addObject:@"已支付"];
        [_btnTitleMutArr addObject:@"已发单"];
        [_btnTitleMutArr addObject:@"已接单"];
        [_btnTitleMutArr addObject:@"已作废"];
        [_btnTitleMutArr addObject:@"已发货"];
        [_btnTitleMutArr addObject:@"已完成"];
    }return _btnTitleMutArr;
}

@end

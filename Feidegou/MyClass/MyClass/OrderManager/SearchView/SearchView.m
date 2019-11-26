//
//  SearchView.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SearchView.h"
#import "OrderListVC.h"

#define BtnDefaultWidth SCALING_RATIO(100)

@interface SearchView ()
<
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray <MMButton *>*btnMutArr;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,assign)CGFloat BtnWidth;

@end

@implementation SearchView

-(instancetype)initWithBtnTitleMutArr:(NSArray <NSString *>*)btnTitleMutArr{
    if (self = [super init]) {
        self.btnTitleArr = btnTitleMutArr;
        self.scrollView.alpha = 1;
        self.backgroundColor = kWhiteColor;
        if (btnTitleMutArr.count * BtnDefaultWidth < SCREEN_WIDTH) {
            self.BtnWidth = (SCREEN_WIDTH - SCALING_RATIO(5) * 2 - SCALING_RATIO(10) * (btnTitleMutArr.count - 1))/ btnTitleMutArr.count;
        }else{
            self.BtnWidth = BtnDefaultWidth;
        }
        
        for (int i = 0; i < btnTitleMutArr.count; i++) {
            MMButton *btn = MMButton.new;
//            btn.backgroundColor = RandomColor;
            [UIView cornerCutToCircleWithView:btn
                              AndCornerRadius:7.f];
            [UIView colourToLayerOfView:btn
                             WithColour:KLightGrayColor
                         AndBorderWidth:.5f];
            [btn setTitle:btnTitleMutArr[i]
                 forState:UIControlStateNormal];
            [btn setImage:kIMG(@"TwoWayArrow_1")
                 forState:UIControlStateNormal];
            [btn setImage:kIMG(@"TwoWayArrow_2")
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
            [self.scrollView addSubview:btn];
            btn.frame = CGRectMake((self.BtnWidth + SCALING_RATIO(10)) * (i) + SCALING_RATIO(5),
                                   0,
                                   self.BtnWidth,
                                   SCALING_RATIO(50));
            [self.btnMutArr addObject:btn];
        }
    }return self;
}

-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

-(void)MMButtonClickEvent:(MMButton *)sender{
    if (self.block) {
        self.block(sender);
    }
}
#pragma mark —— UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
//        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake((SCALING_RATIO(100) + SCALING_RATIO(10)) * (self.btnTitleArr.count) + SCALING_RATIO(5),
                                             55);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = YES;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _scrollView;
}

-(NSMutableArray<MMButton *> *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = NSMutableArray.array;
    }return _btnMutArr;
}

@end

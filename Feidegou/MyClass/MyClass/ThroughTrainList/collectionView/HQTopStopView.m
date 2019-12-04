//
//  HQTopStopView.m
//  HQCollectionViewDemo
//
//  Created by Mr_Han on 2018/10/10.
//  Copyright © 2018年 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
// 

#import "HQTopStopView.h"

@interface HQTopStopView ()

@property(nonatomic,strong)NSMutableArray *btnTitleMutArr;

@end

@implementation HQTopStopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.searchView.alpha = 1;
    }return self;
}

-(SearchView *)searchView{
    if (!_searchView) {
         _searchView = [[SearchView alloc] initWithBtnTitleMutArr:self.btnTitleMutArr];
        [self addSubview:_searchView];
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _searchView;
}

-(NSMutableArray *)btnTitleMutArr{
    if (!_btnTitleMutArr) {
        _btnTitleMutArr = NSMutableArray.array;
        [_btnTitleMutArr addObject:kIMG(@"综合")];
        [_btnTitleMutArr addObject:kIMG(@"销量")];
        [_btnTitleMutArr addObject:kIMG(@"价格")];
        [_btnTitleMutArr addObject:kIMG(@"筛选")];
    }return _btnTitleMutArr;
}

@end

//
//  OrderManagerTBViewForHeader.m
//  Feidegou
//
//  Created by Kite on 2019/12/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderManagerTBViewForHeader.h"

@interface OrderManagerTBViewForHeader ()

@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;
@property(nonatomic,copy)DataBlock block;

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model;

@end

@implementation OrderManagerTBViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kClearColor;
        if ([data isKindOfClass:[NSMutableArray class]]) {
            self.btnTitleMutArr = (NSMutableArray *)data;
        }
    }return self;
}

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

-(void)drawRect:(CGRect)rect{
    self.searchView.alpha = 1;
}

-(void)clickBlock:(DataBlock)block{
    self.block = block;
}

-(void)headerViewWithModel:(id _Nullable)model{

}
#pragma mark —— lazyLoad
-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithBtnTitleMutArr:self.btnTitleMutArr];
        _searchView.backgroundColor = kClearColor;
        @weakify(self)
        [_searchView actionBlock:^(id data) {
            @strongify(self)
            if (self.block) {
                self.block(data);
            }
        }];
        [self addSubview:_searchView];
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCALING_RATIO(10));
            make.left.equalTo(self).offset(SCALING_RATIO(5));
            make.bottom.right.equalTo(self).offset(SCALING_RATIO(-5));
        }];
    }return _searchView;
}

@end

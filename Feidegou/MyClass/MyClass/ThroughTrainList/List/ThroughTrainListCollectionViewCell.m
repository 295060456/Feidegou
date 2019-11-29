//
//  ThroughTrainListCollectionViewCell.m
//  Feidegou
//
//  Created by Kite on 2019/11/28.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainListCollectionViewCell.h"
#import "XXTools.h"

@interface ThroughTrainListCollectionViewCell (){
    
}

@property(nonatomic,strong)UILabel *titleLab;//商品名
@property(nonatomic,strong)UIImageView *imageView;//商品图片
@property(nonatomic,strong)UILabel *repertoryLab;//库存数
@property(nonatomic,strong)UILabel *rankLab;//排名
@property(nonatomic,strong)UILabel *salesLab;//销量
@property(nonatomic,strong)NSArray *arr;

@end

@implementation ThroughTrainListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (!_arr) {
            _arr = [XXTools.new addMarkLabelWithText:@"temp"
                                            maxWidth:60
                                           superView:self.imageView
                                        cornerRadius:2];
        }
    }return self;
}

-(void)drawRect:(CGRect)rect{
    self.imageView.alpha = 1;//商品图片
    self.titleLab.alpha = 1;//商品名
    self.salesLab.alpha = 1;//销量
    self.repertoryLab.alpha = 1;
    self.rankLab.alpha = 1;


}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

-(void)richElementsInCellWithModel:(id _Nullable)model{
    self.salesLab.text = @"1234";//销量
}
#pragma mark —— lazyLoad
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.backgroundColor = kRedColor;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.right.equalTo(self.contentView).offset(-SCALING_RATIO(5));
            make.height.mas_equalTo(self.contentView.mj_h * 2 / 3);
        }];
    }return _imageView;
}



-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"商品名";
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.imageView);
            make.top.equalTo(self.imageView.mas_bottom);
            make.height.mas_equalTo(self.contentView.mj_h * 1 / 6);
        }];
    }return _titleLab;
}

-(UILabel *)repertoryLab{
    if (!_repertoryLab) {
        _repertoryLab = UILabel.new;
        _repertoryLab.text = @"库存数：123456";
        [self.contentView addSubview:_repertoryLab];
        [_repertoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView);
            make.right.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.titleLab.mas_bottom);
            make.height.mas_equalTo(self.contentView.mj_h * 1 / 6);
        }];
    }return _repertoryLab;
}

-(UILabel *)rankLab{
    if (!_rankLab) {
        _rankLab = UILabel.new;
        _rankLab.text = @"排名：123456";
        [self.contentView addSubview:_rankLab];
        [_rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLab.mas_bottom);
            make.height.mas_equalTo(self.contentView.mj_h * 1 / 6);
        }];
    }return _rankLab;
}

-(UILabel *)salesLab{
    if (!_salesLab) {
        _salesLab = self.arr[1];
    }return _salesLab;
}


@end

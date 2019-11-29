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
@property(nonatomic,strong)UILabel *salesLab;//当前剩余
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
    self.salesLab.alpha = 1;//当前剩余
    self.repertoryLab.alpha = 1;
    self.rankLab.alpha = 1;
    [UIView cornerCutToCircleWithView:self.contentView
                      AndCornerRadius:5];
    [UIView colourToLayerOfView:self.contentView
                     WithColour:KLightGrayColor
                 AndBorderWidth:.5f];
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

-(void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[ThroughTrainListModel class]]) {
        ThroughTrainListModel *throughTrainListModel = (ThroughTrainListModel *)model;
        [self showImagePic:throughTrainListModel.print];//商品图片
        self.titleLab.text = throughTrainListModel.name;//商品名
        self.salesLab.text = [@"剩余" stringByAppendingString:[NSString ensureNonnullString:throughTrainListModel.quantity ReplaceStr:@"0"]];//当前剩余
        self.repertoryLab.text = [@"已售:"stringByAppendingString:[NSString ensureNonnullString:throughTrainListModel.sales ReplaceStr:@"0"]];//已销售
        self.rankLab.text = [@"当前排名:"stringByAppendingString:[NSString ensureNonnullString:throughTrainListModel.ranking ReplaceStr:@"0"]];
    }
}

-(void)showImagePic:(NSString *)imageUrl{
    if (![NSString isNullString:imageUrl]) {
        @weakify(self)
        NSString *str = [NSString stringWithFormat:@"%@/%@",BaseUrl_Gouge,imageUrl];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:str]
                             options:SDWebImageDownloaderProgressiveDownload//渐进式下载
                                                         progress:^(NSInteger receivedSize,
                                                                    NSInteger expectedSize,
                                                                    NSURL * _Nullable targetURL) {}
                                                        completed:^(UIImage * _Nullable image,
                                                                    NSData * _Nullable data,
                                                                    NSError * _Nullable error,
                                                                    BOOL finished) {
            @strongify(self)
            if (image) {
                self.imageView.image = image;
            }else{
                self.imageView.image = kIMG(@"picLoadErr");
            }
        }];
    }
}
#pragma mark —— lazyLoad
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.image = kIMG(@"picLoadErr");
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

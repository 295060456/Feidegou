//
//  OrderTBVCell.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderTBVCell.h"

@interface OrderTBVCell ()

@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIImageView *typeImgV;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *timeLab;

@end

@implementation OrderTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderTBVCell *cell = (OrderTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:ReuseIdentifier
                                            margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.imgV.alpha = 1;
    self.titleLab.text = @"猫粮200g";
    self.timeLab.text = @"2019年10月20日 17:23:11";
    self.typeImgV.image = kIMG(@"Mf_旌旗_红色");//Mf_旌旗_绿色
}
#pragma mark —— lazyLoad
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = UIImageView.new;
        _imgV.backgroundColor = kRedColor;
        [UIView cornerCutToCircleWithView:_imgV
                          AndCornerRadius:SCALING_RATIO(5) / 2];
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(5), SCALING_RATIO(5)));
        }];
    }return _imgV;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV.mas_right).offset(SCALING_RATIO(5));
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
        _titleLab.numberOfLines = 0;
        [_titleLab sizeToFit];
    }return _titleLab;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = UILabel.new;
        _timeLab.numberOfLines = 0;
        [_timeLab sizeToFit];
        [self.contentView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
    }return _timeLab;
}

-(UIImageView *)typeImgV{
    if (!_typeImgV) {
        _typeImgV = UIImageView.new;
        [self.contentView addSubview:_typeImgV];
        [_typeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-30));
            make.top.equalTo(self.contentView);
            make.width.mas_equalTo(SCALING_RATIO(30));
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
    }return _typeImgV;
}

@end

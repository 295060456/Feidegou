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
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *timeLab;

@end

@implementation OrderTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderTBVCell *cell = (OrderTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:ReuseIdentifier];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
    }return self;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.imgV.alpha = 1;
    self.titleLab.text = @"1234567";
    self.timeLab.text = @"928364";
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

@end

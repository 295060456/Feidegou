//
//  OrderListTBVCell.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderListTBVCell.h"

@interface OrderListTBVCell ()

@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIImageView *typeImgV;
@property(nonatomic,strong)UILabel *titleLab;//喵粮？g
@property(nonatomic,strong)UILabel *timeLab;//时间
@property(nonatomic,strong)UILabel *sellerLab;//卖家 买家
@property(nonatomic,strong)UILabel *paymentWayLab;//支付方式
@property(nonatomic,strong)UILabel *orderTypeLab;//订单类型
@property(nonatomic,strong)UILabel *orderStatusLab;//订单状态

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *timeStr;
@property(nonatomic,copy)NSString *sellerStr;
@property(nonatomic,copy)NSString *paymentWayStr;
@property(nonatomic,copy)NSString *orderTypeStr;
@property(nonatomic,copy)NSString *orderStatusStr;

@end

@implementation OrderListTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderListTBVCell *cell = (OrderListTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderListTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:ReuseIdentifier
                                                margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

-(void)drawRect:(CGRect)rect{
    self.imgV.alpha = 1;
    self.typeImgV.alpha = 1;
    self.titleLab.alpha = 1;//喵粮？g
    self.timeLab.alpha = 1;//时间
    self.orderStatusLab.alpha = 1;//订单状态
    self.sellerLab.alpha = 1;//卖家 买家
    self.paymentWayLab.alpha = 1;//支付方式
    self.orderTypeLab.alpha = 1;//订单类型

}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 3;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderManager_producingAreaModel class]]) {
        OrderManager_producingAreaModel *orderManager_producingAreaModel = (OrderManager_producingAreaModel *)model;
        self.titleStr = [NSString stringWithFormat:@"喵粮:%@ g",[NSString ensureNonnullString:orderManager_producingAreaModel.quantity ReplaceStr:@"无"]];
        self.timeStr = [@"下单时间:" stringByAppendingString:[NSString ensureNonnullString:orderManager_producingAreaModel.addTime ReplaceStr:@"无"]];
        if ([orderManager_producingAreaModel.identity isEqualToString:@"卖家"]) {
            self.typeImgV.image = kIMG(@"Mf_flag_Red");
            self.imgV.backgroundColor = kRedColor;
            self.sellerStr = [@"卖家:" stringByAppendingString:[NSString ensureNonnullString:orderManager_producingAreaModel.trade_no ReplaceStr:@"无"]];
        }else if ([orderManager_producingAreaModel.identity isEqualToString:@"买家"]){
            self.typeImgV.image = kIMG(@"Mf_flag_Green");
            self.imgV.backgroundColor = KGreenColor;
            self.sellerStr = [@"买家:" stringByAppendingString:[NSString ensureNonnullString:orderManager_producingAreaModel.buyer_name ReplaceStr:@"无"]];
        }
        if ([orderManager_producingAreaModel.payment_status intValue] == 1) {//支付宝
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"支付宝"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else if ([orderManager_producingAreaModel.payment_status intValue] == 2){//微信
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"微信"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else if ([orderManager_producingAreaModel.payment_status intValue] == 3){//银行卡
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"银行卡"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else{}
        
        if ([orderManager_producingAreaModel.order_type intValue] == 1) {//直通车
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"直通车"];//订单类型 1、直通车;2、批发;3、平台
        }else if ([orderManager_producingAreaModel.order_type intValue] == 2){//批发
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"批发"];//订单类型 1、直通车;2、批发;3、平台
        }else if ([orderManager_producingAreaModel.order_type intValue] == 3){//平台
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"平台"];//订单类型 1、直通车;2、批发;3、平台
        }else{}
        
        if ([orderManager_producingAreaModel.order_status intValue] == 0) {//已支付
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已支付"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_producingAreaModel.order_status intValue] == 1){//已发单
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已发单"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_producingAreaModel.order_status intValue] == 2){//已下单
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已下单"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_producingAreaModel.order_status intValue] == 3){//已作废
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已作废"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_producingAreaModel.order_status intValue] == 4){//已发货
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已发货"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_producingAreaModel.order_status intValue] == 5){//已完成
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已完成"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else{}
    }else if ([model isKindOfClass:[OrderManager_panicBuyingModel class]]){
        OrderManager_panicBuyingModel *orderManager_panicBuyingModel = (OrderManager_panicBuyingModel *)model;
        self.titleStr = [NSString stringWithFormat:@"喵粮:%@ g",[NSString ensureNonnullString:orderManager_panicBuyingModel.quantity ReplaceStr:@"无"]];
        self.timeStr = [@"下单时间:" stringByAppendingString:[NSString ensureNonnullString:orderManager_panicBuyingModel.addTime ReplaceStr:@"无"]];
        if ([orderManager_panicBuyingModel.identity isEqualToString:@"卖家"]) {
            self.typeImgV.image = kIMG(@"Mf_flag_Red");
            self.imgV.backgroundColor = kRedColor;
            self.sellerStr = [@"卖家:" stringByAppendingString:[NSString ensureNonnullString:orderManager_panicBuyingModel.trade_no ReplaceStr:@"无"]];
        }else if ([orderManager_panicBuyingModel.identity isEqualToString:@"买家"]){
            self.typeImgV.image = kIMG(@"Mf_flag_Green");
            self.imgV.backgroundColor = KGreenColor;
            self.sellerStr = [@"买家:" stringByAppendingString:[NSString ensureNonnullString:orderManager_panicBuyingModel.buyer_name ReplaceStr:@"无"]];
        }
        if ([orderManager_panicBuyingModel.payment_status intValue] == 1) {//支付宝
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"支付宝"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else if ([orderManager_panicBuyingModel.payment_status intValue] == 2){//微信
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"微信"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else if ([orderManager_panicBuyingModel.payment_status intValue] == 3){//银行卡
            self.paymentWayStr = [@"支付方式:" stringByAppendingString:@"银行卡"];//支付类型:1、支付宝;2、微信;3、银行卡
        }else{}
        
        if ([orderManager_panicBuyingModel.order_type intValue] == 1) {//直通车
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"直通车"];//订单类型 1、直通车;2、批发;3、平台
        }else if ([orderManager_panicBuyingModel.order_type intValue] == 2){//批发
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"批发"];//订单类型 1、直通车;2、批发;3、平台
        }else if ([orderManager_panicBuyingModel.order_type intValue] == 3){//平台
            self.orderTypeStr = [@"订单类型:" stringByAppendingString:@"平台"];//订单类型 1、直通车;2、批发;3、平台
        }else{}
        
        if ([orderManager_panicBuyingModel.order_status intValue] == 0) {//已支付
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已支付"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_panicBuyingModel.order_status intValue] == 1){//已发单
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已发单"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_panicBuyingModel.order_status intValue] == 2){//已下单
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已下单"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_panicBuyingModel.order_status intValue] == 3){//已作废
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已作废"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_panicBuyingModel.order_status intValue] == 4){//已发货
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已发货"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else if ([orderManager_panicBuyingModel.order_status intValue] == 5){//已完成
            self.orderStatusStr = [@"订单状态:" stringByAppendingString:@"已完成"];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        }else{}
    }
}
#pragma mark —— lazyLoad
-(UIImageView *)imgV{//小红点
    if (!_imgV) {
        _imgV = UIImageView.new;
        [UIView cornerCutToCircleWithView:_imgV
                          AndCornerRadius:SCALING_RATIO(5) / 2];
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(20));
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(5), SCALING_RATIO(5)));
        }];
    }return _imgV;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = self.titleStr;
        if (@available(iOS 8.2, *)) {
            _titleLab.font = [UIFont systemFontOfSize:30
                                               weight:1];
        } else {
            _titleLab.font = [UIFont systemFontOfSize:30];
        }
        _titleLab.numberOfLines = 0;
        [_titleLab sizeToFit];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imgV);
            make.left.equalTo(self.imgV.mas_right).offset(SCALING_RATIO(5));
        }];
    }return _titleLab;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = UILabel.new;
        _timeLab.text = self.timeStr;
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
            make.width.mas_equalTo(SCALING_RATIO(40));
            make.height.mas_equalTo(SCALING_RATIO(50));
        }];
    }return _typeImgV;
}

-(UILabel *)sellerLab{
    if (!_sellerLab) {
        _sellerLab = UILabel.new;
        _sellerLab.text = self.sellerStr;
        [self.contentView addSubview:_sellerLab];
        [_sellerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV);
            make.top.equalTo(self.titleLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _sellerLab;
}

-(UILabel *)paymentWayLab{
    if (!_paymentWayLab) {
        _paymentWayLab = UILabel.new;
        _paymentWayLab.text = self.paymentWayStr;
        [self.contentView addSubview:_paymentWayLab];
        [_paymentWayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV);
            make.top.equalTo(self.sellerLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _paymentWayLab;
}

-(UILabel *)orderTypeLab{
    if (!_orderTypeLab) {
        _orderTypeLab = UILabel.new;
        _orderTypeLab.text = self.orderTypeStr;
        [self.contentView addSubview:_orderTypeLab];
        [_orderTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV);
            make.top.equalTo(self.paymentWayLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _orderTypeLab;
}

-(UILabel *)orderStatusLab{
    if (!_orderStatusLab) {
        _orderStatusLab = UILabel.new;
        _orderStatusLab.text = self.orderStatusStr;
        [self.contentView addSubview:_orderStatusLab];
        [_orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV);
            make.top.equalTo(self.orderTypeLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _orderStatusLab;
}

@end


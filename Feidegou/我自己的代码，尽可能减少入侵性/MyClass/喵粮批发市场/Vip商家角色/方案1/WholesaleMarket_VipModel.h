//
//  WholesaleMarket_VipModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_VipModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,copy)NSString *payment_weixin;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,strong)NSNumber *quantity_max;
@property(nonatomic,copy)NSString *payment_alipay;
@property(nonatomic,strong)NSNumber *payment_type;//0、都没有;2、支付宝;3、微信;4、银行卡;5、支付宝 + 微信;6、支付宝 + 银行卡;7、微信 + 银行卡;9、支付宝 + 微信 + 银行卡
@property(nonatomic,strong)NSNumber *quantity_min;
@property(nonatomic,copy)NSString *finishTime;

@end

NS_ASSUME_NONNULL_END


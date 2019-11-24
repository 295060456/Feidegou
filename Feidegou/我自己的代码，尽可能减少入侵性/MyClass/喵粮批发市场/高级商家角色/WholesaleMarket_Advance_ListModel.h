//
//  WholesaleMarket_AdvanceModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

//列表的model
@interface WholesaleMarket_Advance_ListModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,strong)NSNumber *quantity_max;
@property(nonatomic,strong)NSNumber *payment_type;//0、都没有;2、支付宝;3、微信;4、银行卡;5、支付宝 + 微信;6、支付宝 + 银行卡;7、微信 + 银行卡;9、支付宝 + 微信 + 银行卡
@property(nonatomic,strong)NSNumber *quantity_min;
@property(nonatomic,strong)NSNumber *payment_weixin_img;
@property(nonatomic,strong)NSNumber *payment_alipay_img_path;
@property(nonatomic,copy)NSString *payment_weixin_img_path;
@property(nonatomic,copy)NSString *payment_weixin_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *payment_alipay_img_name;
@property(nonatomic,copy)NSString *finishTime;

//我自己加的字段
@property(nonatomic,copy)NSString *buyNum;//购买的数量
@property(nonatomic,strong)NSNumber *paymentWay;//付款的方式
@property(nonatomic,strong)NSNumber *order_Id;//订单ID

@end

@interface WholesaleMarket_Advance_purchaseModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,strong)NSNumber *bankCard;//??
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,strong)NSNumber *catfoodsale_id;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,copy)NSString *payTime;
@property(nonatomic,copy)NSString *payment_weixin;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_alipay;
@property(nonatomic,copy)NSString *bankUser;
@property(nonatomic,copy)NSString *finishTime;

@end

NS_ASSUME_NONNULL_END



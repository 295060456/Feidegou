//
//  WholesaleMarket_AdvanceModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_AdvanceModel : BaseModel

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

@end

NS_ASSUME_NONNULL_END

//{
//    bankaddress = <null>,
//    seller = 1,
//    seller_name = "嘻",
//    payment_weixin_id = "123456789",
//    payment_status = <null>,
//    deleteStatus = 0,
//    bankCard = <null>,
//    order_status = 1,
//    payment_alipay_id = <null>,
//    quantity_max = 20,
//    payment_weixin_img_path = <null>,
//    quantity = 20,
//    id = 7,
//    payment_type = <null>,
//    quantity_min = 0,
//    payment_weixin_img_name = <null>,
//    bankUser = <null>,
//    payment_alipay_img = <null>,
//    payment_weixin_img = -1,
//    payment_alipay_img_path = <null>,
//    bankName = <null>,
//    addTime = "2019-11-05 15:58:38",
//    payment_alipay_img_name = <null>,
//    price = 20,
//    rental = <null>,
//    finishTime = <null>,
//    order_type = 0,
//}

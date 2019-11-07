//
//  WholesaleOrders_AdvanceModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleOrders_AdvanceModel : BaseModel

@property(nonatomic,copy)NSString *payment_print_img_name;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *payment_weixin_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_weixin_img_path;
@property(nonatomic,copy)NSString *payment_alipay_img_path;

@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *order_status;//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,strong)NSNumber *catfoodsale_id;

@end

NS_ASSUME_NONNULL_END

//{
//    payment_print_img_name = <null>,
//    finishTime = <null>,
//    payment_weixin_img_name = <null>,
//    rental = 100,
//    payment_alipay_img_name = <null>,
//    id = 17,
//    payment_alipay_img = <null>,
//    seller_name = <null>,
//    bankCard = <null>,
//    payTime = <null>,
//    ordercode = "SALE20191107140243292",
//    payment_alipay_id = <null>,
//    deleteStatus = 0,
//    del_print_name = <null>,
//    addTime = "2019-11-07 14:02:43",
//    order_status = 2,
//    del_state = <null>,
//    refer = <null>,
//    payment_weixin_img = <null>,
//    del_print_path = <null>,
//    bankName = <null>,
//    payment_print_img_path = <null>,
//    updateTime = "2019-11-07 14:02:43",
//    payment_status = 0,
//    seller = 1,
//    buyer = 1,
//    payment_weixin_id = <null>,
//    delTime = <null>,
//    buyer_name = <null>,
//    quantity = 5,
//    price = 20,
//    del_print = <null>,
//    order_type = 2,
//    payment_print = <null>,
//    bankUser = <null>,
//    trueName = <null>,
//    reason = <null>,
//    bankaddress = <null>,
//    del_check = <null>,
//    catfoodsale_id = 3,
//    payment_weixin_img_path = <null>,
//    payment_alipay_img_path = <null>,
//}

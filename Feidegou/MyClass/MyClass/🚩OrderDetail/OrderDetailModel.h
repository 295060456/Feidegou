//
//  OrderDetailModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
//极光推送 直通车订单使用
@interface OrderDetailModel : BaseModel

@property(nonatomic,copy)NSString *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,copy)NSString *notifyurl;
@property(nonatomic,copy)NSString *group_img;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,copy)NSString *del_reason;
@property(nonatomic,copy)NSString *trade_no;
@property(nonatomic,copy)NSString *card_img;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *weixin_decode;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *payment_alipay;
@property(nonatomic,copy)NSString *comefrom;
@property(nonatomic,copy)NSString *msg_type;
@property(nonatomic,copy)NSString *overdueTime;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *byname;
@property(nonatomic,copy)NSString *affirm;
@property(nonatomic,copy)NSString *goods_status;
@property(nonatomic,copy)NSString *seller_ip;
@property(nonatomic,copy)NSString *payment_weixin;
@property(nonatomic,copy)NSString *platform_id;
@property(nonatomic,copy)NSString *seller_city;
@property(nonatomic,copy)NSString *alipay_decode;
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString *buyer_city;
@property(nonatomic,copy)NSString *payTime;

@property(nonatomic,strong)NSNumber *del_wait_left_time;//外层数据

@property(nonatomic,copy)NSString *identity;//我自己手动加的字段


@end

NS_ASSUME_NONNULL_END

//{
//    deal = 2,
//    del_wait_left_time = 0,
//    catFoodOrder =     {
//        finishTime = "2019-12-09 03:20:03",
//        weixin_decode = <null>,
//        rental = 600,
//        id = 494,
//        payment_alipay_img = "upload/alipay_qr/20191208002739956.png",
//        seller_name = "miaotestvip",
//        payment_alipay = <null>,
//        payTime = <null>,
//        ordercode = "20191209000756259669",
//        del_reason = <null>,
//        comefrom = "3333",
//        deleteStatus = 0,
//        msg_type = <null>,
//        addTime = "2019-12-09 00:07:56",
//        overdueTime = <null>,
//        order_status = 4,
//        payment_weixin_img = <null>,
//        del_state = 3,
//        byname = "5bc7ekaP",
//        affirm = <null>,
//        goods_status = 2,
//        payment_status = 1,
//        updateTime = "2019-12-09 00:05:56",
//        seller = 136648,
//        delTime = "2019-12-09 00:09:05",
//        quantity = 600,
//        seller_ip = "203.90.239.231",
//        payment_weixin = <null>,
//        price = 1,
//        del_print = <null>,
//        platform_id = 136639,
//        seller_city = "香港",
//        order_type = 1,
//        alipay_decode = "https://qr.alipay.com/fkx1cscszy0i7awfsdgs",
//        del_check = <null>,
//        ip = "119.39.23.134",
//        notifyurl = "http://api.one4bank.com/Pay/notify/code/miaopay/orderno/f3HPYWr8aLDp6dF4U1",
//        buyer_city = "湖南省长沙市芙蓉区",
//    },
//}

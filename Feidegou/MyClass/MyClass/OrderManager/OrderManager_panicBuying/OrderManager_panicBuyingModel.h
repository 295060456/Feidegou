//
//  OrderManager_panicBuyingModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager_panicBuyingModel : BaseModel
//OrderManager_panicBuyingModel
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

@property(nonatomic,strong)NSNumber *del_wait_left_time;//外层数据

@property(nonatomic,copy)NSString *identity;//我自己手动加的字段

@end

NS_ASSUME_NONNULL_END

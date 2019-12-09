//
//  OrderListModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListModel : BaseModel

@property(nonatomic,copy)NSString *finishTime;//
@property(nonatomic,copy)NSString *payTime;//大写
@property(nonatomic,strong)NSNumber *deleteStatus;//
@property(nonatomic,copy)NSString *updateTime;//
@property(nonatomic,strong)NSNumber *seller;//
@property(nonatomic,copy)NSString *buyer;//
@property(nonatomic,copy)NSString *delTime;//
@property(nonatomic,strong)NSNumber *catfoodsale_id;//
@property(nonatomic,copy)NSString *payment_weixin;//
@property(nonatomic,copy)NSString *payment_alipay;//

@property(nonatomic,copy)NSString *weixin_decode;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *del_reason;
@property(nonatomic,copy)NSString *comefrom;
@property(nonatomic,copy)NSString *msg_type;
@property(nonatomic,copy)NSString *overdueTime;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *byname;
@property(nonatomic,strong)NSNumber *affirm;
@property(nonatomic,strong)NSNumber *goods_status;
@property(nonatomic,copy)NSString *seller_ip;
@property(nonatomic,strong)NSNumber *platform_id;
@property(nonatomic,copy)NSString *seller_city;
@property(nonatomic,copy)NSString *alipay_decode;
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString *notifyurl;
@property(nonatomic,copy)NSString *buyer_city;

@property(nonatomic,copy)NSString *identity;//我自己手动加的字段

@end

NS_ASSUME_NONNULL_END




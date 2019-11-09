//
//  ThroughTrainToPromoteModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/9.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughTrainToPromoteModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *weixin_decode;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *del_reason;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *comefrom;
@property(nonatomic,copy)NSString *notifyurl;

@end

NS_ASSUME_NONNULL_END

//{
//   "ordercode" :"1",
//   "ip" :null,
//   "seller" :null,
//   "seller_name" :"1",
//   "order_type" :1,
//   "rental" :1.00,
//   "quantity" :1,
//   "price" :1.00,
//   "payment_status" :1,
//   "payment_weixin_img" :1,
//   "weixin_decode" :null,
//   "payment_weixin_id" :"1",
//   "order_status" :1,
//   "updateTime" :"2019-11-08 15:53:18",
//   "payTime" :"2019-11-08 15:53:08",
//   "finishTime" :"2019-11-08 15:52:58",
//   "del_reason" :"1",
//   "del_state" :1,
//   "delTime" :"2019-11-08 15:52:54",
//   "del_check" :"1",
//   "comefrom" :null,
//   "notifyurl" :null,
//   "id" :6,
//   "addTime" :"2019-11-08 15:52:49",
//   "deleteStatus" :true
//}

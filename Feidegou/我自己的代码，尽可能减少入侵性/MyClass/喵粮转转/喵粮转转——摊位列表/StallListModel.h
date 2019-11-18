//
//  StallListModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StallListModel : BaseModel

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
@property(nonatomic,copy)NSString *payment_weixin;
@property(nonatomic,copy)NSString *overdueTime;
@property(nonatomic,copy)NSString *byname;

@end

NS_ASSUME_NONNULL_END



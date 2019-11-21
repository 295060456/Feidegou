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
@property(nonatomic,copy)NSString *bankCard;//大写
@property(nonatomic,copy)NSString *payTime;//大写
@property(nonatomic,strong)NSNumber *deleteStatus;//
@property(nonatomic,strong)NSNumber *order_status;//
@property(nonatomic,copy)NSString *updateTime;//
@property(nonatomic,strong)NSNumber *seller;//
@property(nonatomic,copy)NSString *buyer;//
@property(nonatomic,copy)NSString *delTime;//
@property(nonatomic,copy)NSString *bankUser;//大写
@property(nonatomic,strong)NSNumber *catfoodsale_id;//
@property(nonatomic,copy)NSString *payment_weixin;//
@property(nonatomic,copy)NSString *payment_alipay;//

@property(nonatomic,copy)NSString *identity;//我自己手动加的字段

@end

NS_ASSUME_NONNULL_END

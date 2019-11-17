//
//  WholesaleOrders_VipModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/12.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CatFoodOrder : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,copy)NSString *payment_weixin;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_alipay;
@property(nonatomic,strong)NSNumber *catfoodsale_id;
@property(nonatomic,assign)BOOL deleteStatus;
@property(nonatomic,strong)NSNumber *finishTime;

@end

@interface WholesaleOrders_VipModel : BaseModel

@property(nonatomic,strong)CatFoodOrder *catFoodOrder;

@end

NS_ASSUME_NONNULL_END


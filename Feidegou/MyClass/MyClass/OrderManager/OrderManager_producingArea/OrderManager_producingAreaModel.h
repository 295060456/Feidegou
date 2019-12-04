//
//  OrderManager_producingAreaModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager_producingAreaModel : BaseModel

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

@property(nonatomic,copy)NSString *identity;//我自己手动加的字段


@end

NS_ASSUME_NONNULL_END

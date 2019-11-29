//
//  ThroughTrainListModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/28.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughTrainListModel : BaseModel

@property(nonatomic,copy)NSString *print;
@property(nonatomic,copy)NSString *delTime;//关闭时间
@property(nonatomic,strong)NSNumber *deleteStatus;//不管
@property(nonatomic,strong)NSNumber *user_id;
@property(nonatomic,strong)NSNumber *ranking;
@property(nonatomic,strong)NSNumber *number;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSNumber *train_status;//直通车状态 销售中1 2已关闭
@property(nonatomic,strong)NSNumber *sales;//销售量


@end

NS_ASSUME_NONNULL_END


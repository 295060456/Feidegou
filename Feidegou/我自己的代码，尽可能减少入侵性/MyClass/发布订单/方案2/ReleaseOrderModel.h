//
//  ReleaseOrderModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseOrderModel : BaseModel

@property(nonatomic,strong)NSNumber *alipay;
@property(nonatomic,strong)NSNumber *weixin;
@property(nonatomic,strong)NSNumber *bank;

@end

NS_ASSUME_NONNULL_END

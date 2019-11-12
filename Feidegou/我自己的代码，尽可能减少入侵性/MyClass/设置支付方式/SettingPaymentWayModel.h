//
//  SettingPaymentWayModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingPaymentWayModel : BaseModel

@property(nonatomic,strong)NSNumber *weixin;
@property(nonatomic,strong)NSNumber *alipay;
@property(nonatomic,copy)NSString *bankuser;
@property(nonatomic,copy)NSString *alipay_name;
@property(nonatomic,copy)NSString *bankcard;
@property(nonatomic,copy)NSString *bankaddress;
@property(nonatomic,copy)NSString *bankname;
@property(nonatomic,copy)NSString *weixin_name;
@property(nonatomic,strong)NSNumber *bank;

@end

NS_ASSUME_NONNULL_END



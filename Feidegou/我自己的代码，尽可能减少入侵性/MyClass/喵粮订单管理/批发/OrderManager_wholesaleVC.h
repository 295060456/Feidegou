//
//  OrderManager_wholesaleVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager_wholesaleVC : BaseVC

+ (instancetype)CominngFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

+(instancetype)initWithrequestParams:(nullable id)requestParams
                             success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END

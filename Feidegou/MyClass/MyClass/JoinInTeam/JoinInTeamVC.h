//
//  JoinInTeamVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinInTeamVC : BaseVC

@property(nonatomic,weak)LoginViewController *loginVC;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

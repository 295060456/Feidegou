//
//  SettingPaymentWayVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "XDMultTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingPaymentWayVC : BaseVC

@property(nonatomic,strong)XDMultTableView *tableView;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

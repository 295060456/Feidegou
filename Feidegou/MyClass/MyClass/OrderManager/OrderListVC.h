//
//  OrderListVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

typedef enum : NSUInteger {//按钮状态，下拉刷新的时候，按照谁进行刷新？
    NetworkingTpye_default,//默认
    NetworkingTpye_time,//时间
    NetworkingTpye_tradeType,//买/卖
    NetworkingTpye_businessType,//交易状态
    NetworkingTpye_ID,//ID
    NetworkingTpye_ProducingArea,//产地
} Networking_tpye;

NS_ASSUME_NONNULL_BEGIN

@interface OrderListVC : ContentBaseViewController

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

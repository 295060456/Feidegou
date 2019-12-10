//
//  OrderDetailVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "OrderDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailVC (VM)
//buyer_CatfoodRecord_checkURL 喵粮订单查看
-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSNumber *)Order_type;
-(void)CancelDelivery_NetWorking;//喵粮订单撤销 #5
#pragma mark —— 喵粮产地
-(void)cancelOrder_producingArea_netWorking;//喵粮产地购买取消 #9
#pragma mark —— 喵粮抢摊位
-(void)boothDeliver_networking;//喵粮抢摊位发货 #21
-(void)CatfoodBooth_del_netWorking;//喵粮抢摊位取消 #22_1
-(void)CatfoodBooth_del_time_netWorking;//喵粮抢摊位取消剩余时间 #22_2


@end

NS_ASSUME_NONNULL_END

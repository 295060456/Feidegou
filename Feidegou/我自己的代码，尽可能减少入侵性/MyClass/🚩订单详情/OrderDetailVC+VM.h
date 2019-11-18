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

-(void)buyer_CatfoodRecord_checkURL_NetWorking;//buyer_CatfoodRecord_checkURL 喵粮订单查看 3小时 del_wait_left_time #3
-(void)CancelDelivery_NetWorking;//喵粮订单撤销 #5
#pragma mark —— 喵粮产地
-(void)netWorking;//喵粮产地购买 #7
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image;//喵粮产地购买已支付 #8
-(void)cancelOrder_producingArea_netWorking;//喵粮产地购买取消 #9
#pragma mark —— 喵粮批发
-(void)deliver_wholesaleMarket_PNetworking;//喵粮批发订单发货 #14
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic;//喵粮批发已支付 #17
-(void)cancelOrder_wholesaleMarket_netWorking;//喵粮批发取消 #18
#pragma mark —— 喵粮抢摊位
-(void)boothDeliver_networking;//喵粮抢摊位发货 #21
-(void)CatfoodBooth_del_netWorking;//喵粮抢摊位取消 #22_1
-(void)CatfoodBooth_del_time_netWorking;//喵粮抢摊位取消剩余时间 #22_2


-(void)联系买家;

@end

NS_ASSUME_NONNULL_END

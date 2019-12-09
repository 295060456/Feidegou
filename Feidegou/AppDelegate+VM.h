//
//  AppDelegate+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/24.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (VM)

//Catfood_statisticsUrl 统计直通车在线人数 35
-(void)onlinePeople:(NSString *)onlinePeople;

-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSString *)order_type
                                                    Order_id:(NSString *)order_id;

-(void)updateAPP;

@end

NS_ASSUME_NONNULL_END

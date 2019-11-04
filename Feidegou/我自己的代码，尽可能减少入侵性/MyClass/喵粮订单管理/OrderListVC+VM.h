//
//  OrderListVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderListVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListVC (VM)

-(void)networking_default;//默认排序
-(void)networking_time;//按时间
-(void)networking_tradeType;//按买/卖
-(void)networking_type;//按交易状态
-(void)networking_ID:(NSString *)identity;//按输入的查询ID

@end

NS_ASSUME_NONNULL_END

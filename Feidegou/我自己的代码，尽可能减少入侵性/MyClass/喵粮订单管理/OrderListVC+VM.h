//
//  OrderListVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "OrderListVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListVC (VM)

-(void)networking_default;//默认排序
-(void)networking_time:(UIButton *)sender;//按时间
-(void)networking_tradeType:(UIButton *)sender;//按买/卖
-(void)networking_type:(BusinessType)businessType;//按交易状态
-(void)networking_ID:(NSString *)identity;//按输入的查询ID
-(void)networking_platformType:(PlatformType)platformType;//1、摊位;2、批发;3、产地

@end

NS_ASSUME_NONNULL_END

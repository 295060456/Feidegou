//
//  ThroughTrainToPromoteVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughTrainToPromoteVC (VM)

-(void)checkThroughTrainToPromoteStyle_netWorking;//查看直通车状态
-(void)deleteThroughTrainToPromote_netWorking;//关闭直通车
-(void)check;// 喵粮直通车机会查询 微信3 支付宝3 别人购买的机会 用完今天就不能开启直通车 先查看机会 再开
-(void)CatfoodTrainURL_networking;//开启直通车


@end

NS_ASSUME_NONNULL_END

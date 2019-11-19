//
//  UpLoadCancelReasonVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "UpLoadCancelReasonVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadCancelReasonVC (VM)

-(void)CancelDelivery_NetWorking;

-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image;//喵粮产地购买已支付 #8
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic;//喵粮批发已支付 #17

@end

NS_ASSUME_NONNULL_END

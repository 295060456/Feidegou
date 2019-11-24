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

////CatfoodRecord_delURL 喵粮订单撤销 #5
//-(void)CancelDelivery_NetWorking;
////喵粮订单撤销 post 5 Y PIC 不加catfoodapp
//-(void)CancelDelivery_NetWorking1;

//CatfoodCO_payURL 喵粮产地购买已支付  #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image;
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic;

@end

NS_ASSUME_NONNULL_END

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

//CatfoodCO_payURL 喵粮产地购买已支付 #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image;
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic;//
//CatfoodRecord_delURL
-(void)CatfoodRecord_delURL_netWorking:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

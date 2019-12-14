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

//CatfoodCO_payURL 喵粮产地购买已支付 #8 喵粮产地专用上传凭证
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image;

////喵粮订单撤销 post 5 Y PIC 不加catfoodapp 直通车专用上传凭证
-(void)CatfoodRecord_delURL_netWorking:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

//
//  ShopReceiptQRcodeVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "ShopReceiptQRcodeVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopReceiptQRcodeVC (VM)

-(void)netWorking;
-(void)uploadQRcodePic:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

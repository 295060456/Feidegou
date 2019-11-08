//
//  OrderDetail_BuyerVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/8.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "OrderDetail_BuyerVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail_BuyerVC (VM)

-(void)netWorking;
-(void)uploadPic_netWorking:(UIImage *)image;
-(void)cancelOrder_netWorking;

@end

NS_ASSUME_NONNULL_END

//
//  OrderDetail_SellerVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_SellerVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail_SellerVC (VM)

-(void)netWorking;

-(void)ConfirmDelivery_NetWorking;//喵粮订单发货

-(void)netWorkingWithArgumentURL:(NSString *)url
                         ORDERID:(int)orderID;

-(void)发货;

@end

NS_ASSUME_NONNULL_END

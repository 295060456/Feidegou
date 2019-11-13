//
//  WholesaleOrders_VipVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/12.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleOrders_VipVC (VM)

-(void)netWorking;//拉取数据
-(void)deliver_Networking;//发货
-(void)cancelOrder_netWorking;//取消订单
-(void)uploadPrint_netWorking:(UIImage *)pic;//上传支付凭证

@end

NS_ASSUME_NONNULL_END

//
//  PayMonyForGoodController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"

@interface PayMonyForGoodController : JJBaseViewController
@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) NSString *strTotalPrice;





@property (strong, nonatomic) NSString *strOfId;
//如果isPayTheBill== yes，则表示商家买单
@property (assign, nonatomic) BOOL isPayTheBill;
//如果isCart== yes，则表示购物车
@property (assign, nonatomic) BOOL isCart;
//如果isMneber== yes，则表示会员买单
@property (assign, nonatomic) BOOL isMneber;
//如果isJifen== yes，则表示积分买单
@property (assign, nonatomic) BOOL isJifen;
@property (strong, nonatomic) NSString *not_cash_total;
@end

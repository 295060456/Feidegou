//
//  ModelCenter.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/12.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ModelCenter.h"

@implementation ModelCenter

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"userName":@"userName",
             @"inviter_id":@"inviter_id",
             @"availableBalance":@"availableBalance",
             @"redbags":@"redbags",
             @"integral":@"integral",
             @"store_id":@"store_id",
             @"store_status":@"store_status",
             @"inviterSize":@"inviterSize",
             @"head":@"head",
             @"waitPay":@"waitPay",
             @"waitShip":@"waitShip",
             @"waitConfirm":@"waitConfirm",
             @"waitEvaluate":@"waitEvaluate",
             @"alipayName":@"alipayName",
             @"alipay":@"alipay",
             @"refundNo":@"refundNo",
             @"level":@"level",
             @"regional":@"regional",
             @"corporate":@"corporate"
             };
}
@end

//
//  ModelOrderList.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/18.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelOrderList.h"

@implementation ModelOrderList
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"count":@"count",
             @"goods_name":@"goods_name",
             @"orderId":@"orderId",
             @"order_status":@"order_status",
             @"outline":@"outline",
             @"path":@"path",
             @"state":@"state",
             @"store_id":@"store_id",
             @"store_name":@"store_name",
             @"totalPrice":@"totalPrice",
             @"order_id":@"order_id",
             @"goodsId":@"goodsId",
             @"company_mark":@"company_mark",
             @"company_name":@"company_name",
             @"courierCode":@"courierCode",
             @"goodsList":@"goodsList",
             @"if_cart":@"if_cart",
             @"ID":@"ID"
             };
}
@end

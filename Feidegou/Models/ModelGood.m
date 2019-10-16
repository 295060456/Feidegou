//
//  ModelGood.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelGood.h"

@implementation ModelGood

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"goods_id":@"goods_id",
             @"goods_name":@"goods_name",
             @"goods_price":@"goods_price",
             @"goods_salenum":@"goods_salenum",
             @"path":@"path",
             @"store_price":@"store_price",
             @"use_integral_set":@"use_integral_set",
             @"use_integral_value":@"use_integral_value",
             @"good_area":@"good_area",
             @"give_integral":@"give_integral"
             };
}

@end

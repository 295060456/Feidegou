//
//  ModelEreaExchageList.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/7.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelEreaExchageList.h"

@implementation ModelEreaExchageList
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"ig_exchange_count":@"ig_exchange_count",
             @"ig_goods_id":@"ig_goods_id",
             @"ig_goods_integral":@"ig_goods_integral",
             @"ig_goods_name":@"ig_goods_name",
             @"img":@"img",
             @"ig_goods_price":@"ig_goods_price",
             @"ig_goods_count":@"ig_goods_count"
             };
}
@end

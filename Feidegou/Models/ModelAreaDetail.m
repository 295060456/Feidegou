//
//  ModelAreaDetail.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelAreaDetail.h"

@implementation ModelAreaDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"addTime":@"addTime",
             @"area_info":@"area_info",
             @"count":@"count",
             @"ig_goods_name":@"ig_goods_name",
             @"ig_goods_price":@"ig_goods_price",
             @"igo_pay_time":@"igo_pay_time",
             @"igo_status":@"igo_status",
             @"integral":@"integral",
             @"mobile":@"mobile",
             @"orderid":@"orderid",
             @"path":@"path",
             @"ship_code":@"ship_code",
             @"ship_name":@"ship_name",
             @"trueName":@"trueName",
             @"igo_ship_code":@"igo_ship_code",
             @"igo_ship_time":@"igo_ship_time"
             };
}

@end

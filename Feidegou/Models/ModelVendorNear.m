//
//  ModelVendorNear.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/29.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ModelVendorNear.h"

@implementation ModelVendorNear
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"ID":@"ID",
             @"selNum":@"selNum",
             @"distance":@"distance",
             @"store_evaluate1":@"store_evaluate1",
             @"store_name":@"store_name",
             @"path":@"path",
             @"areaName":@"areaName",
             @"gift_integral":@"gift_integral"
             };
}
@end

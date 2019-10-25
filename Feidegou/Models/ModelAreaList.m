//
//  ModelAreaList.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelAreaList.h"

@implementation ModelAreaList

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"count":@"count",
             @"ig_goods_name":@"ig_goods_name",
             @"igo_status":@"igo_status",
             @"integral":@"integral",
             @"orderId":@"orderId",
             @"path":@"path",
             @"ship_code":@"ship_code",
             @"ship_name":@"ship_name",
             @"igo_ship_code":@"igo_ship_code"
             };
}

@end

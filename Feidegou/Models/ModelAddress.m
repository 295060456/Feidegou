//
//  ModelAddress.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/26.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelAddress.h"

@implementation ModelAddress
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"area":@"area",
             @"area_id":@"area_id",
             @"area_info":@"area_info",
             @"mobile":@"mobile",
             @"ID":@"ID",
             @"trueName":@"trueName",
             @"user_id":@"user_id",
             @"defaultAddr":@"defaultAddr"
             };
}
@end

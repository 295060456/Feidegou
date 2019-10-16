//
//  ModelInfo.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/7/4.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ModelInfo.h"

@implementation ModelInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"region":@"region",
             @"mobile":@"mobile",
             @"area_id":@"area_id",
             @"userName":@"userName",
             @"birthday":@"birthday",
             @"email":@"email",
             @"trueName":@"trueName",
             @"photoUrl":@"photoUrl",
             @"sex":@"sex",
             @"birthday_gai":@"birthday_gai"
             };
}
@end

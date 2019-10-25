//
//  ModelRankList.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ModelRankList.h"

@implementation ModelRankList

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"level":@"level",
             @"lastLoginDate":@"lastLoginDate",
             @"commission":@"commission",
             @"userName":@"userName",
             @"head":@"head"
             };
}

@end

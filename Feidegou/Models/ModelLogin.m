//
//  ModelLogin.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/20.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "ModelLogin.h"

@implementation ModelLogin
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"userName":@"userName",
             @"trueName":@"trueName",
             @"password":@"password",
             @"userId":@"userId",
             @"head":@"head"
             };
}
@end

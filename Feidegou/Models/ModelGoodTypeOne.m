//
//  ModelGoodTypeOne.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelGoodTypeOne.h"

@implementation ModelGoodTypeOne
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"className":@"className",
             @"goodsType_id":@"goodsType_id",
             @"level":@"level"
             };
}
@end

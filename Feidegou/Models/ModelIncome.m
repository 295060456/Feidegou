//
//  ModelIncome.m
//  guanggaobao
//
//  Created by 谭自强 on 16/3/7.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelIncome.h"

@implementation ModelIncome
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"deleteStatus":@"deleteStatus",
             @"pd_log_user_id":@"pd_log_user_id",
             @"ID":@"ID",
             @"pd_log_amount":@"pd_log_amount",
             @"pd_op_type":@"pd_op_type",
             @"pd_log_admin_id":@"pd_log_admin_id",
             @"addTime":@"addTime",
             @"pd_log_info":@"pd_log_info",
             @"pd_type":@"pd_type"
             };
}
@end

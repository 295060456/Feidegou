//
//  ModelOrderDtail.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/18.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ModelOrderDtail.h"

@implementation ModelOrderDtail
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"state":@"state",
             @"goodsSumPrice":@"goodsSumPrice",
             @"store_name":@"store_name",
             @"mobile":@"mobile",
             @"invoiceType":@"invoiceType",
             @"transport":@"transport",
             @"area_info":@"area_info",
             @"ship_price":@"ship_price",
             @"store_telephone":@"store_telephone",
             @"order_status":@"order_status",
             @"store_id":@"store_id",
             @"addTime":@"addTime",
             @"invoice":@"invoice",
             @"goods":@"goods",
             @"company_mark":@"company_mark",
             @"company_name":@"company_name",
             @"courierCode":@"courierCode",
             @"trueName":@"trueName",
             @"totalPrice":@"totalPrice",
             @"payTime":@"payTime",
             @"shipTime":@"shipTime",
             @"refund":@"refund",
             @"return_company_mark":@"return_company_mark",
             @"return_company":@"return_company",
             @"return_shipCode":@"return_shipCode"
             };
}
@end

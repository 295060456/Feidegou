//
//  ModelOrderDtail.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/18.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelOrderDtail : JJBaseModel

/**
 *
 */
@property (nonatomic,copy) NSString *state;
/**
 *
 */
@property (nonatomic,copy) NSString *goodsSumPrice;
/**
 *
 */
@property (nonatomic,copy) NSString *store_name;
/**
 *
 */
@property (nonatomic,copy) NSString *mobile;
/**
 *
 */
@property (nonatomic,copy) NSString *invoiceType;
/**
 *
 */
@property (nonatomic,copy) NSString *transport;
/**
 *
 */
@property (nonatomic,copy) NSString *order_id;
/**
 *
 */
@property (nonatomic,copy) NSString *area_info;
/**
 *
 */
@property (nonatomic,copy) NSString *ship_price;
/**
 *
 */
@property (nonatomic,copy) NSString *store_telephone;
/**
 *
 */
@property (nonatomic,copy) NSString *order_status;
/**
 *
 */
@property (nonatomic,copy) NSString *store_id;
/**
 *
 */
@property (nonatomic,copy) NSString *addTime;
/**
 *
 */
@property (nonatomic,copy) NSString *invoice;
/**
 *
 */
@property (nonatomic,copy) NSArray *goods;
/**
 *
 */
@property (nonatomic,copy) NSString *trueName;
/**
 *
 */
@property (nonatomic,copy) NSString *totalPrice;
/**
 *
 */
@property (nonatomic,copy) NSString *company_mark;
/**
 *
 */
@property (nonatomic,copy) NSString *company_name;
/**
 *
 */
@property (nonatomic,copy) NSString *courierCode;
/**
 *
 */
@property (nonatomic,copy) NSString *payTime;
/**
 *
 */
@property (nonatomic,copy) NSString *shipTime;
/**
 *
 */
@property (nonatomic,copy) NSDictionary *refund;

/**
 *
 */
@property (nonatomic,copy) NSString *return_company_mark;
/**
 *
 */
@property (nonatomic,copy) NSString *return_company;
/**
 *
 */
@property (nonatomic,copy) NSString *return_shipCode;

@end

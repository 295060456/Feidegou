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
@property (nonatomic,strong) NSString *state;
/**
 *
 */
@property (nonatomic,strong) NSString *goodsSumPrice;
/**
 *
 */
@property (nonatomic,strong) NSString *store_name;
/**
 *
 */
@property (nonatomic,strong) NSString *mobile;
/**
 *
 */
@property (nonatomic,strong) NSString *invoiceType;
/**
 *
 */
@property (nonatomic,strong) NSString *transport;
/**
 *
 */
@property (nonatomic,strong) NSString *order_id;
/**
 *
 */
@property (nonatomic,strong) NSString *area_info;
/**
 *
 */
@property (nonatomic,strong) NSString *ship_price;
/**
 *
 */
@property (nonatomic,strong) NSString *store_telephone;
/**
 *
 */
@property (nonatomic,strong) NSString *order_status;
/**
 *
 */
@property (nonatomic,strong) NSString *store_id;
/**
 *
 */
@property (nonatomic,strong) NSString *addTime;
/**
 *
 */
@property (nonatomic,strong) NSString *invoice;
/**
 *
 */
@property (nonatomic,strong) NSArray *goods;
/**
 *
 */
@property (nonatomic,strong) NSString *trueName;
/**
 *
 */
@property (nonatomic,strong) NSString *totalPrice;
/**
 *
 */
@property (nonatomic,strong) NSString *company_mark;
/**
 *
 */
@property (nonatomic,strong) NSString *company_name;
/**
 *
 */
@property (nonatomic,strong) NSString *courierCode;
/**
 *
 */
@property (nonatomic,strong) NSString *payTime;
/**
 *
 */
@property (nonatomic,strong) NSString *shipTime;
/**
 *
 */
@property (nonatomic,strong) NSDictionary *refund;

/**
 *
 */
@property (nonatomic,strong) NSString *return_company_mark;
/**
 *
 */
@property (nonatomic,strong) NSString *return_company;
/**
 *
 */
@property (nonatomic,strong) NSString *return_shipCode;
@end

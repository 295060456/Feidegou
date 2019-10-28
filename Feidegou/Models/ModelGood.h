//
//  ModelGood.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelGood : JJBaseModel
/**
 *
 */
@property (nonatomic,strong) NSString *goods_id;
/**
 *
 */
@property (nonatomic,strong) NSString *goods_name;
/**
 *
 */
@property (nonatomic,strong) NSString *goods_price;
/**
 *
 */
@property (nonatomic,strong) NSString *goods_salenum;
/**
 *
 */
@property (nonatomic,strong) NSString *path;
/**
 *
 */
@property (nonatomic,strong) NSString *store_price;
/**
 *use_integral_set == 2显示积分，1表示可用积分，也可以不用积分，0表示不要积分。0和1不显示
 */
@property (nonatomic,strong) NSString *use_integral_set;
/**
 *
 */
@property (nonatomic,strong) NSString *use_integral_value;
/**
 *
 */
@property (nonatomic,strong) NSString *good_area;

/**
 *
 */
@property (nonatomic,strong) NSString *give_integral;
@end

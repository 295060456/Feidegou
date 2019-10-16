//
//  GoodsListController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"

@interface GoodsListController : JJBaseViewController
/**
 *来自分类列表
 */
@property (strong, nonatomic) NSDictionary *dicInfo;
/**
 *搜索的字
 */
@property (strong, nonatomic) NSString *strSearch;
/**
 *品牌ID
 */
@property (strong, nonatomic) NSString *strGoods_brand_id;
/**
 *salenum销量 price价格
 */
@property (strong, nonatomic) NSString *strOrder;
/**
 *1升序，2降序
 */
@property (strong, nonatomic) NSString *strSort;
/**
 *1升序，2降序
 */
@property (assign, nonatomic) BOOL isShow;
/**
 *1积分，2报单
 */
@property (strong, nonatomic) NSString *goodArea;
/**
 *专题ID goodActivity
 */
@property (strong, nonatomic) NSString *goodActivity;

/**
 *专题ID 分类
 */
@property (strong, nonatomic) NSString *goodsType_id;

/**
 *vip专区
 */
@property (strong, nonatomic) NSString *good_area;
@end

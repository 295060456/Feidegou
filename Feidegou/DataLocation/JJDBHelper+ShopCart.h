//
//  JJDBHelper+ShopCart.h
//  Vendor
//
//  Created by 谭自强 on 2017/3/14.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper.h"
#import "ModelAddress.h"

@interface JJDBHelper (ShopCart)

/**
 *  查询购物车
 *
 *  @return NSDictionary
 */
- (NSArray *)fetchShopCart;


/**
 *  保存购物车
 *
 */
- (void)saveShopCart:(NSDictionary *)dictionary andIntBuyNum:(NSString *)historyNum andhistoryAttribute:(NSString *)historyAttribute andhistoryAttributeName:(NSString *)historyAttributeName andhistoryGood_id:(NSString *)historyGood_id andhistoryPrice:(NSString *)historyPrice;
/**
 *  删除购物车
 *
 */
- (void)deleteShopCart;


/**
 *  查询默认收货地址
 *
 *  @return NSDictionary
 */
- (ModelAddress *)fetchAddressDefault;


/**
 *  保存默认收货地址
 *
 */
- (void)saveAddressDefault:(ModelAddress *)model;
/**
 *  删除默认收货地址
 *
 */
- (void)deleteAddressDefault;
@end

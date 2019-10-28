//
//  JJDBHelper+ShopCart.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/14.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper+ShopCart.h"

#define ShopCartLocation @"shopCartLocation"
#define AddressDefault @"addressDefault"
@implementation JJDBHelper (ShopCart)

- (NSArray *)fetchShopCart{
    
    NSData *data = [self queryCacheDataWithCacheId:ShopCartLocation];
    
    NSArray *array = [self convertData:data];
    if (![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }
    return array;
}
- (void)saveShopCart:(NSDictionary *)dictionary andIntBuyNum:(NSString *)historyNum andhistoryAttribute:(NSString *)historyAttribute andhistoryAttributeName:(NSString *)historyAttributeName andhistoryGood_id:(NSString *)historyGood_id andhistoryPrice:(NSString *)historyPrice{
    NSMutableArray *arrHistory = [NSMutableArray arrayWithArray:[self fetchShopCart]];
    BOOL isContarinShop = NO;
    BOOL isContarinGood = NO;
    for (int i = 0; i<arrHistory.count; i++) {
        NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:arrHistory[i]];
//        如果商品的商家ID一样，则查看是否是同一个商品的同一种属性
        if ([TransformString(arrMiddle[0][@"dictionary"][@"goods"][@"goods_store_id"]) isEqualToString:TransformString(dictionary[@"goods"][@"goods_store_id"])]) {
            isContarinShop = YES;
//            商家ID一样
            for (int j = 0; j<arrMiddle.count; j++) {
                NSMutableDictionary *dictionaryMiddle = [NSMutableDictionary dictionaryWithDictionary:arrMiddle[j]];
                NSString *historyAttributeMiddle = dictionaryMiddle[@"historyAttribute"];
                NSString *historyAttributeNameMiddle = dictionaryMiddle[@"historyAttributeName"];
                NSString *historyGood_idMiddle = dictionaryMiddle[@"historyGood_id"];
                NSString *historyPriceMiddle = dictionaryMiddle[@"historyPrice"];
                //            如果ID，属性，属性名字，价格都一样，则添加数量，否则添加另一个
                if ([TransformString(historyGood_idMiddle) isEqualToString:TransformString(historyGood_id)]&&[TransformString(historyAttributeMiddle) isEqualToString:TransformString(historyAttribute)]&&[TransformString(historyAttributeNameMiddle) isEqualToString:TransformString(historyAttributeName)]&&[TransformString(historyPriceMiddle) isEqualToString:TransformString(historyPrice)]) {
//                    商品ID和属性一样，则把该商品添加数量并把该商品添加到改商家的第一个，商家也排到第一个
                    isContarinGood = YES;
                    [dictionaryMiddle setObject:TransformNSInteger([dictionaryMiddle[@"historyNum"] intValue]+[historyNum intValue]) forKey:@"historyNum"];
                    [arrMiddle removeObjectAtIndex:j];
                    [arrMiddle insertObject:dictionaryMiddle atIndex:0];
                    [arrHistory removeObjectAtIndex:i];
                    [arrHistory insertObject:arrMiddle atIndex:0];
                }
            }
//            商品属于该商家，但是如果没有该商品，则添加到改商家第一个
            if (!isContarinGood) {
                NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
                [dicAdd setValue:dictionary forKey:@"dictionary"];
                [dicAdd setValue:historyNum forKey:@"historyNum"];
                [dicAdd setValue:historyAttribute forKey:@"historyAttribute"];
                [dicAdd setValue:historyAttributeName forKey:@"historyAttributeName"];
                [dicAdd setValue:historyGood_id forKey:@"historyGood_id"];
                [dicAdd setValue:historyPrice forKey:@"historyPrice"];
                
                [arrMiddle insertObject:dicAdd atIndex:0];
                [arrHistory removeObjectAtIndex:i];
                [arrHistory insertObject:arrMiddle atIndex:0];
            }
            
        }
    }
    
//    如果商家不一样，则另添加一个商家并把该商品排在第一
    if (!isContarinShop) {
        NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
        [dicAdd setValue:dictionary forKey:@"dictionary"];
        [dicAdd setValue:historyNum forKey:@"historyNum"];
        [dicAdd setValue:historyAttribute forKey:@"historyAttribute"];
        [dicAdd setValue:historyAttributeName forKey:@"historyAttributeName"];
        [dicAdd setValue:historyGood_id forKey:@"historyGood_id"];
        [dicAdd setValue:historyPrice forKey:@"historyPrice"];
        
        [arrHistory insertObject:[NSArray arrayWithObject:dicAdd] atIndex:0];
    }
    [self updateCacheForId:ShopCartLocation cacheArray:arrHistory];
    
    
//    D_NSLog(@"arrHistory is %@",arrHistory);
}

- (void)deleteShopCart{
    [self updateCacheForId:ShopCartLocation cacheArray:[NSArray array]];
}


- (ModelAddress *)fetchAddressDefault{
    
    NSData *data = [self queryCacheDataWithCacheId:AddressDefault];
    
    NSDictionary *dictionray = [self convertData:data];
    ModelAddress *model = [MTLJSONAdapter modelOfClass:[ModelAddress class] fromJSONDictionary:dictionray error:nil];
    return model;
}
- (void)saveAddressDefault:(ModelAddress *)model{
    [self updateCacheForId:AddressDefault cacheDictionry:[model toDictionary]];
}

- (void)deleteAddressDefault{
    [self updateCacheForId:AddressDefault cacheDictionry:[NSDictionary dictionary]];
}
@end

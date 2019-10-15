//
//  JJHttpClient+ShopGood.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient+ShopGood.h"
#import "JJDBHelper+Center.h"

@implementation JJHttpClient (ShopGood)

-(RACSignal*)requestShopGoodMainGoodLimit:(NSString *)limit
                                  andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3062"
                                                data:@{@"limit":limit,
                                                       @"page":page}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodTypeSubjectWeb:(NSString *)type{
    NSDictionary *param = [self paramStringWithStype:@"3043"
                                                data:@{@"type":type}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
            return dictionary[@"data"];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodTypeOne{
    NSDictionary *param = [self paramStringWithStype:@"3002"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        NSArray *array = [NSArray arrayWithArray:dictionary[@"goodsClass"]];
        RACSequence *sequence=[array rac_sequence];
        return [[sequence map:^id(NSDictionary *item){
            ModelGoodTypeOne *model = [MTLJSONAdapter modelOfClass:[ModelGoodTypeOne class] fromJSONDictionary:item error:nil];
            return model;
        }] array];
    }];
}

-(RACSignal*)requestShopGoodBrandRone{
    NSDictionary *param = [self paramStringWithStype:@"3007"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodTypeTwoGoodsType_id:(NSString *)goodsType_id{
    NSDictionary *param = [self paramStringWithStype:@"3002"
                                                data:@{@"level":@"1",
                                                       @"goodsType_id":goodsType_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary[@"goodsClass"];
    }];
}
-(RACSignal*)requestShopGoodGoodTypeLimit:(NSString *)limit
                                  andPage:(NSString *)page
                          andGoodsType_id:(NSString *)goodsType_id
                             andgoodsName:(NSString *)goodsName
                        andgoods_brand_id:(NSString *)goods_brand_id
                                  andsort:(NSString *)sort
                                 andorder:(NSString *)order
                            andpriceStart:(NSString *)priceStart
                              andpriceEnd:(NSString *)priceEnd
                              andgoodArea:(NSString *)goodArea
                          andgoodActivity:(NSString *)goodActivity
                             andgood_area:(NSString *)good_area{
    NSDictionary *param = [self paramStringWithStype:@"3003"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"goodsType_id":goodsType_id,
                                                       @"goodsName":goodsName,
                                                       @"goods_brand_id":goods_brand_id,
                                                       @"sort":sort,
                                                       @"order":order,
                                                       @"priceStart":priceStart,
                                                       @"priceEnd":priceEnd,
                                                       @"goodArea":goodArea,
                                                       @"goodActivity":goodActivity,
                                                       @"good_area":good_area
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        return dictionary;
//        if ([dictionary[@"goodsList"] isKindOfClass:[NSArray class]]) {
//            NSArray *array = [NSArray arrayWithArray:dictionary[@"goodsList"]];
//            RACSequence *sequence=[array rac_sequence];
//            return [[sequence map:^id(NSDictionary *item){
//                ModelGood *model = [MTLJSONAdapter modelOfClass:[ModelGood class] fromJSONDictionary:item error:nil];
//                return model;
//            }] array];
//        }
//        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodDetailGoods_id:(NSString *)goods_id{
    NSDictionary *param = [self paramStringWithStype:@"3004"
                                                data:@{@"goods_id":goods_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodGoodNumGoodsspecpropertyId:(NSString *)goodsspecpropertyId
                                            andGoodsId:(NSString *)goodsId{
    NSDictionary *param = [self paramStringWithStype:@"3010"
                                                data:@{@"goodsspecpropertyId":goodsspecpropertyId,
                                                       @"goods_id":goodsId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodOrderListLimit:(NSString *)limit
                                   andPage:(NSString *)page
                           andOrder_status:(NSString *)order_status
                                andUser_id:(NSString *)user_id{
    NSDictionary *param = [self paramStringWithStype:@"3013"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"order_status":order_status,
                                                       @"user_id":user_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"orderInfo"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"orderInfo"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelOrderList *model = [MTLJSONAdapter modelOfClass:[ModelOrderList class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodOrderDetailOrderId:(NSString *)orderId{
    NSDictionary *param = [self paramStringWithStype:@"3014"
                                                data:@{@"orderId":orderId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
//        D_NSLog(@"msg is %@",dictionary[@"msg"]);
        ModelOrderDtail *model = [MTLJSONAdapter modelOfClass:[ModelOrderDtail class] fromJSONDictionary:dictionary[@"orderInfo"] error:nil];
        return model;
    }];
}

-(RACSignal*)requestShopGoodOrderDetailLogisticsInformationType:(NSString *)type
                                                      andPostid:(NSString *)postid{
//    @"postid":@"882283795698412885"
    NSInteger integerTemp = random();
    NSString *strTemp = StringFormat(@"%ld",(long)integerTemp);
    NSDictionary *param = @{@"type":type,
                            @"postid":postid,
                            @"id":@"1",
                            @"valicode":@"",
                            @"temp":strTemp};
    return [[self requestPOSTWithRelativePathByBaseURL:@"http://m.kuaidi100.com" andRelativePath:@"query" parameters:param] map:^id(NSDictionary* dictionary) {
        D_NSLog(@"msg is %@",dictionary);
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodAreaListLevel:(NSString *)level
                                    andID:(NSString *)ID{
    NSDictionary *param = [self paramStringWithStype:@"3011"
                                                data:@{@"level":level,
                                                       @"id":ID}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"area"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"area"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelArea *model = [MTLJSONAdapter modelOfClass:[ModelArea class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodAddressListUserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3006"
                                                data:@{@"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"addrList"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"addrList"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelAddress *model = [MTLJSONAdapter modelOfClass:[ModelAddress class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        D_NSLog(@"msg is %@",dictionary[@"msg"]);
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodPayByType:(NSString *)payType
                          andOrder_id:(NSString *)order_id{
    NSDictionary *param = [self paramStringWithStype:@"4025"
                                                data:@{@"payment":payType,
                                                       @"order_id":order_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodVendorOtherGoodGoods_store_id:(NSString *)goods_store_id
                                                 andLimit:(NSString *)limit andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3005"
                                                data:@{@"goods_store_id":goods_store_id,
                                                       @"limit":limit,
                                                       @"page":page}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"goodsList"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionary[@"goodsList"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelGood *model = [MTLJSONAdapter modelOfClass:[ModelGood class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }else{
            return [NSArray array];
        }

    }];

}

-(RACSignal*)requestShopGoodDiscussListGoods_id:(NSString *)goods_id
                                       andLimit:(NSString *)limit
                                        andPage:(NSString *)page
                                       andState:(NSString *)state
                                    andstore_id:(NSString *)store_id{
    NSDictionary *param = [self paramStringWithStype:@"3052"
                                                data:@{@"goods_id":goods_id,
                                                       @"limit":limit,
                                                       @"page":page,
                                                       @"state":state,
                                                       @"store_id":store_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodSearchGoodsName:(NSString *)goodsName{
    NSDictionary *param = [self paramStringWithStype:@"3009"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
        
    }];
}

-(RACSignal*)requestShopGoodEreaExchangeListLimit:(NSString *)limit
                                          andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3017"
                                                data:@{@"limit":limit,
                                                       @"page":page}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"data"][@"list"]];
        for (int i = 0; i<array.count; i++) {
            NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
            [dicInfo setObject:dicInfo[@"id"] forKey:@"ig_goods_id"];
            [array replaceObjectAtIndex:i withObject:dicInfo];
        }
        RACSequence *sequence=[array rac_sequence];
        return [[sequence map:^id(NSDictionary *item){
            ModelEreaExchageList *model = [MTLJSONAdapter modelOfClass:[ModelEreaExchageList class] fromJSONDictionary:item error:nil];
            return model;
        }] array];
    }];
}

-(RACSignal*)requestShopGoodEreaExchangeDetailIg_goods_id:(NSString *)ig_goods_id{
    NSDictionary *param = [self paramStringWithStype:@"3018"
                                                data:@{@"goods_id":ig_goods_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        ModelEreaExchangeDetail *model = [MTLJSONAdapter modelOfClass:[ModelEreaExchangeDetail class] fromJSONDictionary:dictionary[@"data"] error:nil];
        model.ig_goods_id = dictionary[@"data"][@"id"];
        return model;
    }];
}

-(RACSignal*)requestShopGoodOrderListAreaExchangeLimit:(NSString *)limit
                                               andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3020"
                                                data:@{@"limit":limit,
                                                       @"page":page}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
            return dictionary[@"data"];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodOrderDetailAreaExchangeorderId:(NSString *)orderId{
    NSDictionary *param = [self paramStringWithStype:@"3021"
                                                data:@{@"orderId":orderId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"integral"]];
//        [dicMiddle setObject:@"882283795698412885" forKey:@"igo_ship_code"];
        
        ModelAreaDetail *model = [MTLJSONAdapter modelOfClass:[ModelAreaDetail class] fromJSONDictionary:dicMiddle error:nil];
        return model;
        
        
    }];
}

-(RACSignal*)requestShopGoodOrderPayWay{
    NSDictionary *param = [self paramStringWithStype:@"3061"
                                                data:@{@"userId":[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId],
                                                       @"pay_way":@"app"
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodCartListLimit:(NSString *)limit
                                  andPage:(NSString *)page
                               anduser_id:(NSString *)user_id{
    NSDictionary *param = [self paramStringWithStype:@"3030"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"user_id":user_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        
        return dictionary[@"goodsCart"];
    }];
}
-(RACSignal*)requestShopGoodCartToOrderDetailsc_id:(NSString *)sc_id
                                         andUserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3033"
                                                data:@{@"sc_id":sc_id,
                                                       @"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodCenterInfoUserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3063"
                                                data:@{@"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        ModelCenter *model = [MTLJSONAdapter modelOfClass:[ModelCenter class] fromJSONDictionary:dictionary[@"data"] error:nil];
        [[JJDBHelper sharedInstance] saveCenterMsg:model];
        return model;
    }];
}

-(RACSignal*)requestShopGoodBlanceDetialLimit:(NSString *)limit
                                      andPage:(NSString *)page
                                    anduserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3039"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionary[@"list"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelIncome *model = [MTLJSONAdapter modelOfClass:[ModelIncome class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodPerformanceDetialLimit:(NSString *)limit
                                           andPage:(NSString *)page
                                         anduserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3046"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionary[@"list"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelPerformance *model = [MTLJSONAdapter modelOfClass:[ModelPerformance class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodRedpacketDetialLimit:(NSString *)limit
                                         andPage:(NSString *)page
                                         andmode:(NSString *)mode{
    NSDictionary *param = [self paramStringWithStype:@"3066"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"mode":mode
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
            return dictionary[@"data"];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodIntegralDetialLimit:(NSString *)limit
                                        andPage:(NSString *)page
                                      andGrouId:(NSString *)group_id{
    NSDictionary *param = [self paramStringWithStype:@"3067"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"level":@"1",
                                                       @"group_id":group_id
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
            return dictionary[@"data"];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodRankListLimit:(NSString *)limit
                                  andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3038"
                                                data:@{@"limit":limit,
                                                       @"page":page}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionary[@"list"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelRankList *model = [MTLJSONAdapter modelOfClass:[ModelRankList class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodVenderType{
    NSDictionary *param = [self paramStringWithStype:@"3041"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        return dictionary[@"data"];
    }];
}

-(RACSignal*)requestShopGoodPersonalInfoUserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"3063"
                                                                                                              data:@{@"userId":userId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        ModelInfo *model = [MTLJSONAdapter modelOfClass:[ModelInfo class] fromJSONDictionary:dictionary[@"data"] error:nil];
        [[JJDBHelper sharedInstance] savePersonalInfo:model];
        return model;
    }];
}
-(RACSignal*)requestShopGoodVenderMain{
    NSDictionary *param = [self paramStringWithStype:@"3049"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit
                                      andPage:(NSString *)page
                                       andlat:(NSString *)lat
                                       andlng:(NSString *)lng
                                       andkey:(NSString *)key{
    NSDictionary *param = [self paramStringWithStype:@"3050"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"lat":lat,
                                                       @"lng":lng,
                                                       @"key":key}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"list"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelVendorNear *model = [MTLJSONAdapter modelOfClass:[ModelVendorNear class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit
                                      andPage:(NSString *)page
                                      andclas:(NSString *)clas
                                       andkey:(NSString *)key{
    NSDictionary *param = [self paramStringWithStype:@"3053"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"clas":clas,
                                                       @"key":key}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"list"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelVendorNear *model = [MTLJSONAdapter modelOfClass:[ModelVendorNear class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodVendorDetailstore_id:(NSString *)store_id{
    NSDictionary *param = [self paramStringWithStype:@"3051"
                                                data:@{@"store_id":store_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        return dictionary;
    }];
}
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit
                                      andPage:(NSString *)page
                            andgoods_store_id:(NSString *)goods_store_id{
    NSDictionary *param = [self paramStringWithStype:@"3005"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"goods_store_id":goods_store_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        if ([dictionary[@"goodsList"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"goodsList"]];
            return array;
        }
        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodVendorOtherGoodGoods_store_id:(NSString *)goods_store_id
                                                 andLimit:(NSString *)limit
                                                  andPage:(NSString *)page
                                     andrealstore_approve:(NSString *)realstore_approve{
    NSDictionary *param = [self paramStringWithStype:@"3005"
                                                data:@{@"goods_store_id":goods_store_id,
                                                       @"limit":limit,
                                                       @"page":page,
                                                       @"realstore_approve":realstore_approve
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"goodsList"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionary[@"goodsList"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelGood *model = [MTLJSONAdapter modelOfClass:[ModelGood class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }else{
            return [NSArray array];
        }
        
    }];
    
}

-(RACSignal*)requestShopGoodVendorBillHistoryuser_id:(NSString *)user_id
                                            andLimit:(NSString *)limit
                                             andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3069"
                                                data:@{@"limit":limit,
                                                       @"page":page
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"data"]];
            return array;
        }
        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit
                                      andPage:(NSString *)page
                                      andclas:(NSString *)clas
                                       andkey:(NSString *)key
                                       andLat:(NSString *)lat
                                       andLng:(NSString *)lng{
    NSDictionary *param = [self paramStringWithStype:@"3053"
                                                data:@{@"limit":limit,
                                                       @"page":page,
                                                       @"clas":clas, @"lat":lat, @"lng":lng,
                                                       @"key":key}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        if ([dictionary[@"list"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"list"]];
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [dicInfo setObject:dicInfo[@"id"] forKey:@"ID"];
                [array replaceObjectAtIndex:i withObject:dicInfo];
            }
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelVendorNear *model = [MTLJSONAdapter modelOfClass:[ModelVendorNear class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        return [NSArray array];
    }];
}
-(RACSignal*)requestShopGoodOrderEnergy:(NSString *)ofId{
    NSDictionary *param = [self paramStringWithStype:@"3052"
                                                data:@{@"ofId":ofId}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodPayTheBillType:(NSString *)payType
                               andOrder_id:(NSString *)order_id{
    NSDictionary *param = [self paramStringWithStype:@"3040"
                                                data:@{@"payType":payType,
                                                       @"order_id":order_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodPayByType:(NSString *)payType
                          andOrder_id:(NSString *)order_id
                           andpay_msg:(NSString *)pay_msg
                               andNum:(NSString *)strNum{
    NSDictionary *param = [self paramStringWithStype:strNum
                                                data:@{@"payType":payType,
                                                       @"order_id":order_id,
                                                       @"pay_msg":pay_msg}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestShopGoodCartToOrderDetailsc_list:(NSArray *)sc_list
                                          anduser_id:(NSString *)user_id{
    NSDictionary *param = [self paramStringWithStype:@"3060"
                                                data:@{@"sc_list":sc_list,
                                                       @"user_id":user_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        if ([dictionary[@"storeList"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"storeList"]];
            RACSequence *sequence=[array rac_sequence];
            return [[sequence map:^id(NSDictionary *item){
                ModelOrderGoodList *model = [MTLJSONAdapter modelOfClass:[ModelOrderGoodList class] fromJSONDictionary:item error:nil];
                model.billType = enum_billType_no;
                
                if ([model.isPackageMail boolValue]) {
                    model.sendWay = enum_sendWay_express;
                }else{
                    model.sendWay = enum_sendWay_no;
                }
                return model;
            }] array];
        }
        return [NSArray array];
        
        //        NSArray *arrInfo = dictionary[@"storeList"];
        //        if (![arrInfo isKindOfClass:[NSArray class]]) {
        //            arrInfo = [NSArray array];
        //        }
        //        return arrInfo;
    }];
}

-(RACSignal*)requestShopGoodSignIn{
    NSDictionary *param = [self paramStringWithStype:@"3200"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
//        if ([dictionary[@"signGoods"] isKindOfClass:[NSArray class]]) {
//            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"signGoods"]];
//            RACSequence *sequence=[array rac_sequence];
//            return [[sequence map:^id(NSDictionary *item){
//                ModelOrderGoodList *model = [MTLJSONAdapter modelOfClass:[ModelOrderGoodList class] fromJSONDictionary:item error:nil];
//                model.billType = enum_billType_no;
//
//                if ([model.isPackageMail boolValue]) {
//                    model.sendWay = enum_sendWay_express;
//                }else{
//                    model.sendWay = enum_sendWay_no;
//                }
//                return model;
//            }] array];
//        }
//        return [NSArray array];
    }];
}

-(RACSignal*)requestShopGoodSignInShare{
    NSDictionary *param = [self paramStringWithStype:@"3068"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary[@"data"];
    }];
}

-(RACSignal*)requestShopGoodInviteFriend{
    NSDictionary *param = [self paramStringWithStype:@"3072"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary[@"data"];
    }];
}

-(RACSignal*)requestShopGoodChivement:(NSString *)way{
    NSDictionary *param = [self paramStringWithStype:@"3070"
                                                data:@{@"way":way}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary[@"data"];
    }];
}

-(RACSignal*)requestShopGoodWithdrawHistoryLimit:(NSString *)limit
                                         andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"3071"
                                                data:@{
                                                       @"limit":limit,
                                                       @"page":page}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictinary) {
        
        return dictinary[@"data"];
    }];
}

-(RACSignal*)requestShopGoodWuliuList{
    NSDictionary *param = [self paramStringWithStype:@"3074"
                                                data:@{}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictinary) {
        
        return dictinary[@"data"];
    }];
}

@end

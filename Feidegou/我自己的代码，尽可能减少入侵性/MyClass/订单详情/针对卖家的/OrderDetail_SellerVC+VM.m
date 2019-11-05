//
//  OrderDetail_SellerVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_SellerVC+VM.h"

@implementation OrderDetail_SellerVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dictionary;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dictionary = (NSDictionary *)self.requestParams;
        
    }
    NSDictionary *dic = @{
//         @"order_id":dictionary[@"order_id"],//订单id
//         @"order_type":dictionary[@"order_type"]//订单类型 —— 1、摊位;2、批发;3、产地
        @"order_id":dictionary[@"order_id"],//订单id
        @"order_type":dictionary[@"order_type"]//订单类型 —— 1、摊位;2、批发;3、产地
    };
       
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_checkURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            self.tableView.mj_footer.hidden = NO;
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                self.orderDetail_SellerModel = [OrderDetail_SellerModel mj_objectWithKeyValues:dic[@"catFoodOrder"]];
                self.orderDetail_SellerModel.deal = [dic[@"deal"] intValue];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void)ConfirmDelivery_NetWorking{
    extern NSString *randomStr;
    NSDictionary *dictionary;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dictionary = (NSDictionary *)self.requestParams;
        
    }
    NSDictionary *dic = @{
         @"order_id":dictionary[@"order_id"],//订单id
         @"order_type":dictionary[@"order_type"]//订单类型 —— 1、摊位;2、批发;3、产地
    };
       
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:seller_CatfoodRecord_goodsURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);

        }
    }];
}




@end

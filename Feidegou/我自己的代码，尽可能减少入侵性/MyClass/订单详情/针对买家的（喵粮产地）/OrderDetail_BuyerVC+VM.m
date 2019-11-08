//
//  OrderDetail_BuyerVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/8.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_BuyerVC+VM.h"

@implementation OrderDetail_BuyerVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]) {
        CatFoodProducingAreaModel *model = (CatFoodProducingAreaModel *)self.requestParams;
        NSDictionary *dataDic = @{
            @"order_id":[model.ID stringValue]//order_id
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodCO_BuyerURL
                                                         parameters:@{
                                                             @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            [self.tableView.mj_header endRefreshing];
            @strongify(self)
            if ([response isKindOfClass:[NSDictionary class]]) {
                self.model = [OrderDetail_BuyerModel mj_objectWithKeyValues:response];
            }
        }];

    }
}

@end

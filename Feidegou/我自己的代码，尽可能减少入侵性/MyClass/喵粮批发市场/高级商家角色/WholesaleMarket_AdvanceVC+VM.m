//
//  WholesaleMarket_AdvanceVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_AdvanceVC+VM.h"

@implementation WholesaleMarket_AdvanceVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"currentpage":[NSString stringWithFormat:@"%ld",self.currentpage],
        @"pagesize":@"32"
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSaleURL //#15
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSArray *array = [WholesaleMarket_Advance_ListModel mj_objectArrayWithKeyValuesArray:response];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {
                    @strongify(self)
                    WholesaleMarket_Advance_ListModel *model = array[idx];
                    [self.dataMutArr addObject:model];
                }];
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    }];
}

-(void)purchase:(NSArray *)arr{//order_id quantity payment_status
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":arr[0],
        @"quantity":arr[1],
        @"payment_status":arr[2]
    };
    
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_BuyeroneURL //喵粮批发购买 post 16 Y
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                WholesaleMarket_Advance_purchaseModel *model = [WholesaleMarket_Advance_purchaseModel mj_objectWithKeyValues:response];
                [OrderDetailVC ComingFromVC:self_weak_
                                  withStyle:ComingStyle_PUSH
                              requestParams:model
                                    success:^(id data) {}
                                   animated:YES];
            }
        }
    }];
}

@end

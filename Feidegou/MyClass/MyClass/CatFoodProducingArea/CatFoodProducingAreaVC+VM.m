//
//  CatFoodProducingAreaVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodProducingAreaVC+VM.h"

@implementation CatFoodProducingAreaVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"currentpage":[NSString stringWithFormat:@"%ld",self.currentpage],
        @"pagesize":@"32"
    };
       
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCOURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *array = [CatFoodProducingAreaModel mj_objectArrayWithKeyValuesArray:response];
                if (array) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                        NSUInteger idx,
                                                        BOOL * _Nonnull stop) {
                        @strongify(self)
                        CatFoodProducingAreaModel *model = array[idx];
                        [self.dataMutArr addObject:model];
                    }];
                }
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    }];
}
//CatfoodCO_BuyerURL 喵粮产地购买 #7
-(void)purchase_netWorking:(CatFoodProducingAreaModel *)model{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":model.ID
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCO_BuyerURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        @weakify(self)
        [OrderDetailVC ComingFromVC:self_weak_
                          withStyle:ComingStyle_PUSH
                      requestParams:model
                            success:^(id data) {}
                           animated:YES];
    }];
}

@end

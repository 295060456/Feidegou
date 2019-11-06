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
        @"currentPage":[NSString stringWithFormat:@"%ld",self.currentPage],
        @"pagesize":@"32"
    };
       
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCOURL
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

@end

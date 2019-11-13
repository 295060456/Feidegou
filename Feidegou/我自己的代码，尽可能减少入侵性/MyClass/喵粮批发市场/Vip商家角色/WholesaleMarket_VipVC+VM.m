//
//  WholesaleMarket_VipVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_VipVC+VM.h"

@implementation WholesaleMarket_VipVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"currentPage":[NSString stringWithFormat:@"%ld",self.currentPage],
        @"pagesize":@"32"
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_listURL //#15
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
                NSArray *array = [WholesaleMarket_VipModel mj_objectArrayWithKeyValuesArray:response];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {
                    @strongify(self)
                    WholesaleMarket_VipModel *model = array[idx];
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

@end

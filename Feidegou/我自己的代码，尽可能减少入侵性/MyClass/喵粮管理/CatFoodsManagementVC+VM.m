//
//  CatFoodsManagementVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC+VM.h"

NSString *randomStr;

@implementation CatFoodsManagementVC (VM)

-(void)networking{
    NSDictionary *dataDic = @{
        @"user_id":@"1"//KKK
    };
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodManageURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) { 
        if (response) {
            NSLog(@"--%@",response);
            NSDictionary *dic = (NSDictionary *)response;
            [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodsell"]] ReplaceStr:@""]];
            [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodstuff"]] ReplaceStr:@""]];
            [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"market_price"]] ReplaceStr:@""]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

@end

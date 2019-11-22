//
//  WholesaleMarket_VipVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_VipVC+VM.h"

@implementation WholesaleMarket_VipVC (VM)
//喵粮批发管理 #10
-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"currentPage":[NSString stringWithFormat:@"%ld",self.currentPage],
        @"pagesize":@"32"
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_listURL
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

-(void)CatfoodSale_delURL_networking:(long)indexPathRow{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.wholesaleMarket_VipModel.ID
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_delURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response) {
            NSLog(@"--%@",response);
            Toast(@"下架成功");
            [self.dataMutArr removeObjectAtIndex:indexPathRow];
            [self.tableView reloadData];
//            [self.tableView.mj_header beginRefreshing];
            
        }
    }];
}

@end

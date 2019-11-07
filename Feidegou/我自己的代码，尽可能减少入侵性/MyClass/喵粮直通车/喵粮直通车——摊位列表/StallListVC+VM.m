//
//  StallListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC+VM.h"

@implementation StallListVC (VM)

//正式请求
-(void)networking{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"":@""
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_listURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
//            StallListModel
            NSArray *array = [OrderListModel mj_objectArrayWithKeyValuesArray:response];
            if (array) {
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {
                    @strongify(self)
//                    OrderListModel *model = array[idx];
//                    [self.dataMutArr addObject:model];
                }];
//                self.tableView.mj_footer.hidden = NO;
//                [self.tableView reloadData];
            }
        }
    }];
}


@end

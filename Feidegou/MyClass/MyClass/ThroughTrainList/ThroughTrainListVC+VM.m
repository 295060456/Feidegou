//
//  ThroughTrainListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/28.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainListVC+VM.h"

@implementation ThroughTrainListVC (VM)

-(void)netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"currentpage":[NSNumber numberWithInt:self.page],
        @"pagesize":@""
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_listURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        NSLog(@"%@",response);
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)response;
            if (arr.count) {
                NSArray *array = [ThroughTrainListModel mj_objectArrayWithKeyValuesArray:arr];
                if (array) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                        NSUInteger idx,
                                                        BOOL * _Nonnull stop) {
                        @strongify(self)
                        ThroughTrainListModel *model = array[idx];
                        [self.dataMutArr addObject:model];
                    }];
                    if (self.dataMutArr.count) {
                        self.collectionView.mj_footer.hidden = NO;
                    }else{
                        self.collectionView.mj_footer.hidden = YES;
                    }
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                    [self.collectionView reloadData];
                }
            }
        }
    }];
}

@end

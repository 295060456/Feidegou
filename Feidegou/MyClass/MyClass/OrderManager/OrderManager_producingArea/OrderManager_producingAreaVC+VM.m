//
//  OrderManager_producingAreaVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "OrderManager_producingAreaVC+VM.h"

@implementation OrderManager_producingAreaVC (VM)

-(void)networking_platformType:(PlatformType)platformType{//1、摊位;2、批发;3、产地
    NSLog(@"%lu",(unsigned long)platformType);
    NSDictionary *dic = @{
        @"currentpage":[NSString stringWithFormat:@"%d",self.page],//分页数 默认1
        @"pagesize":@"",//分页大小 默认12
        @"order_status":@"",//状态：0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
        @"type":@"",//买家1;卖家2;默认查全部
        @"order_code":@"",//搜索订单号
        @"order_type":[NSString stringWithFormat:@"%lu",(unsigned long)platformType]//1、直通车;2、批发;3、厂家;默认查全部
    };[self networkingWithArgument:dic];
}

-(void)networking_type:(BusinessType)businessType{//按交易状态
    NSDictionary *dic = @{
        @"currentpage":[NSString stringWithFormat:@"%d",self.page],//分页数 默认1
        @"pagesize":@"",//分页大小 默认12
        @"order_status":[NSString stringWithFormat:@"%lu",(unsigned long)businessType],//状态：0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
        @"type":@"",//买家1;卖家2;默认查全部
        @"order_code":@"",//搜索订单号
        @"order_type":@""//1、直通车;2、批发;3、厂家;默认查全部
    };
    [self networkingWithArgument:dic];
}
//正式请求
-(void)networkingWithArgument:(NSDictionary *)dic{
    extern NSString *randomStr;
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_listURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)response;
                if (arr.count) {
                    if ([response isKindOfClass:[NSArray class]]) {
                        NSArray *array = [OrderListModel mj_objectArrayWithKeyValuesArray:response];
                        if (array) {
                            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                                NSUInteger idx,
                                                                BOOL * _Nonnull stop) {
                                @strongify(self)
                                OrderListModel *model = array[idx];
                                ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
                                if ([modelLogin.userId intValue] == [model.seller intValue]) {
                                    model.identity = @"卖家";
                                }else{
                                    model.identity = @"买家";
                                }
                                [self.dataMutArr addObject:model];
                            }];
                            if (self.dataMutArr.count) {
                                self.tableView.mj_footer.hidden = NO;
                            }else{
                                self.tableView.mj_footer.hidden = YES;
                            }
                            [self.tableView.mj_header endRefreshing];
                            [self.tableView.mj_footer endRefreshing];
                            [self.tableView reloadData];
                        }
                    }
                }else{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        Toast(@"没数据了");
                    }];
                }
            }
        }
    }];
}

@end

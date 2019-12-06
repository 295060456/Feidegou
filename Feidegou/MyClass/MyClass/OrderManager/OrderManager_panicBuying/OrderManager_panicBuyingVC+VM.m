//
//  OrderManager_panicBuyingVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderManager_panicBuyingVC+VM.h"

@implementation OrderManager_panicBuyingVC (VM)

-(void)networking_platformType:(PlatformType)platformType{//1、摊位;2、批发;3、产地
    NSLog(@"%lu",(unsigned long)platformType);
    NSDictionary *dic = @{
        @"currentpage":[NSString stringWithFormat:@"%d",self.page],//分页数 默认1
        @"pagesize":@"",//分页大小 默认12
        @"order_status":@"",//状态：0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
        @"type":@"",//买家1;卖家2;默认查全部
        @"order_code":@"",//搜索订单号
        @"order_type":[NSString stringWithFormat:@"%lu",(unsigned long)platformType]//1、直通车;2、批发;3、厂家;默认查全部
    };
    [self networkingWithArgument:dic];
}

-(void)networking_type:(BusinessType)businessType{//按交易状态
    NSString *str;
    if (businessType == BusinessType_ALL) {
        str = @"-1";
    }else{
        str = [NSString stringWithFormat:@"%lu",(unsigned long)businessType];//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
    }
    NSString *USERID = @"";
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        USERID = model.userId;
    }
    NSDictionary *dic = @{
        @"currentpage":[NSString stringWithFormat:@"%d",self.page],//分页数 默认1
        @"pagesize":@"12",//分页大小 默认12
        @"order_status":str,
        @"type":@"",//买家1;卖家0;默认查全部
        @"order_code":@"",//搜索订单号
        @"order_type":@"1",//订单类型 1、直通车;2、批发;3、平台
        @"user_id":USERID,
        @"identity":[YDDevice getUQID]
    };
    [self networkingWithArgument:dic];
}
//正式请求
-(void)networkingWithArgument:(NSDictionary *)dic{
    NSString *randomStr = @"NMYUIXOJSPHTAKFG";//[EncryptUtils shuffledAlphabet:16];
    
    NSLog(@"KKK = %@",dic[@"order_status"]);//状态：0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
    NSLog(@"DDD = %@",dic[@"currentpage"]);//状态：0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
//    NSLog(@"AAAA = %ld",self.dataMutArr.count);
    
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_listURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)response;
                if (self.dataMutArr.count) {
                    [self.dataMutArr removeAllObjects];
                }
                if (arr.count) {
                    NSArray *array = [OrderManager_panicBuyingModel mj_objectArrayWithKeyValuesArray:response];
                    if (array) {
                        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                            NSUInteger idx,
                                                            BOOL * _Nonnull stop) {
                            @strongify(self)
                            OrderManager_panicBuyingModel *model = array[idx];
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
                    }
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    NSLog(@"没数据了");
                }
            }
        }
        NSLog(@"AAAA = %ld",self.dataMutArr.count);
        [self.tableView reloadData];
        [self.timer setFireDate:[NSDate date]];//开始
    }];
}

@end

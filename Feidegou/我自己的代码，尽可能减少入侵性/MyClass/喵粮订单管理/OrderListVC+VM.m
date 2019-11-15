//
//  OrderListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderListVC+VM.h"

@implementation OrderListVC (VM)

-(void)networking_default{//默认
    NSDictionary *dic = @{
        @"user_id":@"1",
        @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
        @"pagesize":@"10",
        @"order_status":@"",//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        @"type":@"",//买家1;卖家0
        @"user_id":@"",//搜索用户
        @"beginTime":@"",//时间从*
        @"endTime":@"",//到*
        @"order_type":@"",//订单类型 —— 1、摊位;2、批发;3、产地
        @"Order_code":@"",//搜索订单号
        @"time_order":@""//1升2降
    };
    [self networkingWithArgument:dic];
}

-(void)networking_time:(UIButton *)sender{//按时间
    NSDictionary *dic = @{
        @"user_id":@"1",
        @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
        @"pagesize":@"10",
        @"order_status":@"",//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        @"type":@"",//买家1;卖家0
        @"user_id":@"",//搜索用户
        @"beginTime":@"",//时间从*
        @"endTime":@"",//到*
        @"order_type":@"",//订单类型 —— 1、摊位;2、批发;3、产地
        @"Order_code":@"",//搜索订单号
        @"time_order":[NSString stringWithFormat:@"%d",sender.selected + 1]//1升2降
    };
//    NSLog(@"KKK = %@",[NSString stringWithFormat:@"%d",sender.selected]);
    [self networkingWithArgument:dic];
}

-(void)networking_tradeType:(UIButton *)sender{//按买/卖
    NSDictionary *dic = @{
        @"user_id":@"1",
        @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
        @"pagesize":@"10",
        @"order_status":@"",//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        @"type":[NSString stringWithFormat:@"%d",sender.selected + 1],//买家1;卖家2
        @"user_id":@"",//搜索用户
        @"beginTime":@"",//时间从*
        @"endTime":@"",//到*
        @"order_type":@"",//订单类型 —— 1、摊位;2、批发;3、产地
        @"Order_code":@"",//搜索订单号
        @"time_order":@""//1升2降
    };
//    NSLog(@"KKK = %@",[NSString stringWithFormat:@"%d",sender.selected]);
    [self networkingWithArgument:dic];
}

-(void)networking_type:(BusinessType)businessType{//按交易状态
    NSDictionary *dic = @{
        @"user_id":@"1",
        @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
        @"pagesize":@"10",
        @"order_status":[NSString stringWithFormat:@"%lu",(unsigned long)businessType],//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        @"type":@"",//买家1;卖家0
        @"user_id":@"",//搜索用户
        @"beginTime":@"",//时间从*
        @"endTime":@"",//到*
        @"order_type":@"",//订单类型 —— 1、摊位;2、批发;3、产地
        @"Order_code":@"",//搜索订单号
        @"time_order":@""//1升2降
    };
    [self networkingWithArgument:dic];
}

-(void)networking_ID:(NSString *)identity{//按输入的查询ID
    if (![NSString isNullString:identity]) {
        NSDictionary *dic = @{
            @"user_id":@"1",
            @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
            @"pagesize":@"10",
            @"order_status":@"",//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
            @"type":@"",//买家1;卖家0
            @"user_id":identity,//搜索用户
            @"beginTime":@"",//时间从*
            @"endTime":@"",//到*
            @"order_type":@"",//订单类型 —— 1、摊位;2、批发;3、产地
            @"Order_code":identity,//搜索订单号
            @"time_order":@""//1升2降
        };
        [self networkingWithArgument:dic];
    }else{
        [YKToastView showToastText:@"请键入查询内容"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)networking_platformType:(PlatformType)platformType{//1、摊位;2、批发;3、产地
    NSLog(@"%lu",(unsigned long)platformType);
    NSDictionary *dic = @{
        @"user_id":@"1",
        @"currentPage":[NSString stringWithFormat:@"%d",self.page],//分页数
        @"pagesize":@"10",
        @"order_status":@"",//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
        @"type":@"",//买家1;卖家0
        @"user_id":@"",//搜索用户
        @"beginTime":@"",//时间从*
        @"endTime":@"",//到*
        @"order_type":[NSString stringWithFormat:@"%lu",(unsigned long)platformType],//订单类型 —— 1、摊位;2、批发;3、产地
        @"Order_code":@"",//搜索订单号
        @"time_order":@""//1升2降
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
                    self.tableView.mj_footer.hidden = NO;
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
            }
        }
    }];
}


@end

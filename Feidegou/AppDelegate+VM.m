//
//  AppDelegate+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/24.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate+VM.h"

@implementation AppDelegate (VM)
//Catfood_statisticsUrl 统计直通车在线人数 35
-(void)onlinePeople:(NSString *)onlinePeople{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSNumber *num;
    if ([onlinePeople isEqualToString:@"Online"]) {
        num = [NSNumber numberWithInt:1];
    }else if ([onlinePeople isEqualToString:@"Offline"]){
        num = [NSNumber numberWithInt:-1];
    }else{}
    NSDictionary *dic = @{
        @"type":num,
        @"randomStr":randomStr
    };
    NSLog(@"%lu",(unsigned long)onlinePeople)
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfood_statisticsUrl
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)

    }];
}
//buyer_CatfoodRecord_checkURL 喵粮订单查看
-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSString *)order_type
                                                    Order_id:(NSString *)order_id{//订单类型 —— 1、摊位;2、批发;3、产地
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
        NSDictionary *dataDic = @{
            @"order_id":[NSString ensureNonnullString:order_id
                                           ReplaceStr:@"无"],//订单id
            @"order_type":[NSString ensureNonnullString:order_type
                                             ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
            @"randomStr":randomStr
        };
           
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:buyer_CatfoodRecord_checkURL
                                                         parameters:@{
                                                             @"data":dataDic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response) {
                @strongify(self)
                NSLog(@"--%@",response);
                
                //    if (!self.orderDetailVC) {
                //        @weakify(self)
                //        self.orderDetailVC = [OrderDetailVC ComingFromVC:self_weak_.window.rootViewController
                //                                               withStyle:ComingStyle_PUSH
                //                                           requestParams:nil
                //                                                 success:^(id data) {}
                //                                                animated:YES];
                //    }
                
                //1、支付宝;2、微信;3、银行卡
//                if ([response isKindOfClass:[NSDictionary class]]) {
//                    NSDictionary *dataDic = (NSDictionary *)response;
//                    OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
//                    [self.titleMutArr addObject:@"订单号:"];
//                    [self.titleMutArr addObject:@"单价:"];
//                    [self.titleMutArr addObject:@"数量:"];
//                    [self.titleMutArr addObject:@"总价:"];
//                    [self.titleMutArr addObject:@"支付方式:"];
//
//                    [self.dataMutArr addObject:[NSString ensureNonnullString:model.ordercode ReplaceStr:@"暂无"]];//订单号
//                    [self.dataMutArr addObject:[[NSString ensureNonnullString:model.price ReplaceStr:@"暂无"] stringByAppendingString:@"CNY"]];//单价
//                    [self.dataMutArr addObject:[[NSString ensureNonnullString:model.quantity ReplaceStr:@"暂无"] stringByAppendingString:@" g"]];//数量
//                    [self.dataMutArr addObject:[[NSString ensureNonnullString:model.rental ReplaceStr:@"暂无"] stringByAppendingString:@" CNY"]];//总价
//
//                    if ([model.payment_status intValue] == 3) {//3、银行卡
//                        [self.titleMutArr addObject:@"银行卡号:"];
//                        [self.titleMutArr addObject:@"姓名:"];
//                        [self.titleMutArr addObject:@"银行类型:"];
//                        [self.titleMutArr addObject:@"支行信息:"];
//
//                        [self.dataMutArr addObject:@"银行卡"];//支付方式
//                        [self.dataMutArr addObject:model.bankCard];//银行卡号
//                        [self.dataMutArr addObject:model.bankUser];//姓名
//                        [self.dataMutArr addObject:model.bankName];//银行类型
//                        [self.dataMutArr addObject:model.bankaddress];//支行信息
//
//                    }else if ([model.payment_status intValue] == 2){//2、微信
//                        [self.titleMutArr addObject:@"账号:"];
//                        [self.dataMutArr addObject:@"微信"];//支付方式
//                        [self.dataMutArr addObject:model.payment_weixin];//账号
//                    }else if ([model.payment_status intValue] == 1){//1、支付宝
//                        [self.titleMutArr addObject:@"账号:"];
//                        [self.dataMutArr addObject:@"支付宝"];//支付方式
//                        [self.dataMutArr addObject:model.payment_alipay];//账号
//                    }else{
//                        [self.titleMutArr addObject:@"异常:"];
//                        [self.dataMutArr addObject:@"支付方式数据异常"];//支付方式
//                        [self.dataMutArr addObject:@"支付账号数据异常"];//账号
//                    }
//                    [self.titleMutArr addObject:@"下单时间:"];
//                    [self.titleMutArr addObject:@"订单状态:"];
//
//                    [self.dataMutArr addObject:[NSString ensureNonnullString:model.updateTime ReplaceStr:@"暂无"]];//下单时间
//                    //状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                    if ([model.order_status intValue] == 0) {//已支付
//                         [self.dataMutArr addObject:@"订单已支付"];
//                    }else if ([model.order_status intValue] == 1){//已发单
//                         [self.dataMutArr addObject:@"订单已发单"];
//                    }else if ([model.order_status intValue] == 2){//已下单
//                         [self.dataMutArr addObject:@"订单已下单"];
//                    }else if ([model.order_status intValue] == 3){//已作废
//                         [self.dataMutArr addObject:@"订单已作废"];
//                    }else if ([model.order_status intValue] == 4){//已发货
//                         [self.dataMutArr addObject:@"订单已发货"];
//                    }else if ([model.order_status intValue] == 5){//已完成
//                         [self.dataMutArr addObject:@"订单已完成"];
//                    }else{
//                        [self.dataMutArr addObject:@"订单状态异常"];
//                    }
//
//                    if (![NSString isNullString:model.payment_print]) {
//                        [self.titleMutArr addObject:@"凭证:"];
//                        [self.dataMutArr addObject:model.payment_print];
//                    }
//                }
                
//                self.tableView.mj_footer.hidden = NO;
//                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshing];
//                [self.tableView reloadData];
            }
        }];
}

@end

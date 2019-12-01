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
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = (NSDictionary *)response;
                OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
                if (!self.orderDetailVC) {
                    @weakify(self)
                    self.orderDetailVC = [OrderDetailVC ComingFromVC:self_weak_.window.rootViewController
                                                           withStyle:ComingStyle_PUSH
                                                       requestParams:model
                                                             success:^(id data) {}
                                                            animated:YES];
                }
            }
        }
    }];
}




@end

//
//  ReleaseOrderVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ReleaseOrderVC+VM.h"

@implementation ReleaseOrderVC (VM)
//发布订单
-(void)releaseOrder_netWorking{
    extern NSString *randomStr;
    NSString *str = @"";
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;
        NSNumber *b = (NSNumber *)arr[2];
        str = [NSString stringWithFormat:@"%f",[b floatValue]];
    }
    if ([NSString isNullString:self.str_1]) {
        Toast(@"请输入发布数量");
        return;
    }
    if ([NSString isNullString:self.str_2]) {
        Toast(@"请输入最低限额");
        return;
    }
    if ([NSString isNullString:self.str_3]) {
        Toast(@"请输入最高限额");
        return;
    }
    if ([NSString isNullString:self.str_4]) {
        Toast(@"请选择付款方式");
        return;
    }
    
    if ([self.str_4 isEqualToString:@"3"]) {//银行卡
        if ([NSString isNullString:self.str_7]) {
            Toast(@"请填写银行卡账号"); return;
        }else if ([NSString isNullString:self.str_8]){
            Toast(@"请填写姓名"); return;
        }else if ([NSString isNullString:self.str_9]){
            Toast(@"请填写银行类型"); return;
        }else if ([NSString isNullString:self.str_10]){
            Toast(@"请填写支行信息"); return;
        }
    }else if ([self.str_4 isEqualToString:@"2"]){//微信
        if ([NSString isNullString:self.str_5]) {
             Toast(@"请填写微信账号"); return;
        }
    }else if ([self.str_4 isEqualToString:@"1"]){//支付宝
        if ([NSString isNullString:self.str_6]){
             Toast(@"请填写支付宝账号"); return;
        }
    }else{}
    
    NSDictionary *dataDic = @{
        @"quantity":self.str_1,//数量
        @"quantity_min":self.str_2,//最小
        @"quantity_max":self.str_3,//最大可购数量
        @"price":str,//单价
        @"payment_status":self.str_4,//支付类型 1、支付宝；2、微信；3、银行卡
        @"Weixin_id":[NSString isNullString:self.str_5] ? @"" : self.str_5,//微信账户
        @"Alipay_id":[NSString isNullString:self.str_6] ? @"" : self.str_6,//支付宝账户
        @"bankcard":[NSString isNullString:self.str_7] ? @"" : self.str_7,//银行卡号
        @"bankuser":[NSString isNullString:self.str_8] ? @"" : self.str_8,//用户名
        @"bankname":[NSString isNullString:self.str_9] ? @"" : self.str_9,//银行名字
        @"bankaddress":[NSString isNullString:self.str_10] ? @"" : self.str_10//支行
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_add_URL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
 

        }
    }];
}

@end

//
//  ReleaseOrderVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ReleaseOrderVC+VM.h"

@implementation ReleaseOrderVC (VM)

-(void)gettingPaymentWay{
    extern NSString *randomStr;
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodPayment_quaryURL
                                                     parameters:@{
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
            [self.tableView.mj_header endRefreshing];
            self.releaseOrderModel = [ReleaseOrderModel mj_objectWithKeyValues:response];
            [self.tableView reloadData];
        }
    }];
}

-(void)netWorking{
    extern NSString *randomStr;
    NSString *str = @"";
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;
        NSNumber *b = (NSNumber *)arr[2];
        str = [NSString stringWithFormat:@"%f",[b floatValue]];
    }
    
    if (![NSString isNullString:self.str_1] &&
        ![NSString isNullString:self.str_2] &&
        ![NSString isNullString:self.str_3]) {

        NSDictionary *dataDic = @{
            @"quantity":self.str_1,//数量
            @"quantity_max":self.str_3,//最大可购数量
            @"quantity_min":self.str_2,//最小
            @"price":str,//单价
            @"payment_status":self.str_4,//支付类型 1、支付宝；2、微信；3、银行卡
            @"Alipay_id":@"",//账户
            @"Alipay_img":@"",//二维码
            @"Weixin_id":@"",//账户
            @"Weixin_img":@"",//二维码
            @"bankcard":@"",//银行卡号
            @"bankname":@"",//银行名字
            @"bankuser":@"",//用户名
            @"bankaddress":@""//支行
        };
        randomStr = [EncryptUtils shuffledAlphabet:16];
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
    }else{
        Toast(@"请完善资料");
    }
}




@end

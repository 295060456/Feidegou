//
//  ReleaseOrderVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ReleaseOrderVC+VM.h"

@implementation ReleaseOrderVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"quantity":self.str_1,//数量
        @"quantity_max":self.str_3,//最大可购数量
        @"quantity_min":self.str_2,//最小
        @"price":@"",//单价
        @"payment_status":@"",//支付类型
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
}

@end

//
//  SettingPaymentWayVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SettingPaymentWayVC+VM.h"

@implementation SettingPaymentWayVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"alipay":[NSString ensureNonnullString:self.aliPayAccStr ReplaceStr:@""],//支付宝账户
        @"weixin":[NSString ensureNonnullString:self.wechatAccStr ReplaceStr:@""],//微信账户
        @"bank":@{
                @"bankcard":[NSString ensureNonnullString:self.bankAccStr ReplaceStr:@""],//银行卡号
                @"bankname":[NSString ensureNonnullString:self.bankNameStr ReplaceStr:@""],//银行名字
                @"bankuser":[NSString ensureNonnullString:self.bankCardNameStr ReplaceStr:@""],//持卡人姓名
                @"bankaddress":[NSString ensureNonnullString:self.branchInfoStr ReplaceStr:@""]//所属分行
        }
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodPayment_setURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (!response) {
            NSLog(@"--%@",response);
            Toast(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end


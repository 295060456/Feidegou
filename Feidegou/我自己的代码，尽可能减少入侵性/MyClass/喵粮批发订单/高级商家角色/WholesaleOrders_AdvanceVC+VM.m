//
//  WholesaleOrders_AdvanceVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_AdvanceVC+VM.h"

@implementation WholesaleOrders_AdvanceVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSString *text;
    WholesaleMarket_AdvanceModel *model;
    
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;
        text = arr[0];
        model = arr[1];
    }

    NSDictionary *dataDic = @{
        @"order_id":model.ID,
        @"quantity":text,
        @"payment_status": model.payment_type//支付类型 ：1、支付宝;2、微信;3、银行卡
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_BuyeroneURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
        }
    }];
}

-(void)upLoadPic_netWorking:(UIImage *)pic{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        
        @"pagesize":@"32"
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_payURL 
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
        }
    }];
}



@end

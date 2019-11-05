//
//  GiftVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GiftVC+VM.h"

@implementation GiftVC (VM)

-(void)netWorking{
    
    if (![NSString isNullString:self.User_phone] &&
        ![NSString isNullString:self.value]) {
        extern NSString *randomStr;
        NSDictionary *dictionary;
        if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
            dictionary = (NSDictionary *)self.requestParams;
            
        }
        NSDictionary *dic = @{
            @"User_phone":self.User_phone,//被赠送用户手机
            @"User_id":@"1",//用户id KKK
            @"value":self.value//数量
        };
           
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodRecord_goodsURL
                                                         parameters:@{
                                                             @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response) {
//                @strongify(self)
                NSLog(@"--%@",response);

            }
        }];
    }else{
        Toast(@"请输入数据");
    }
    
}

@end

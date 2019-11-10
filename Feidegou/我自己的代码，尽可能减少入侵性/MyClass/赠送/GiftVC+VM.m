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
    extern NSString *randomStr;
    if (![NSString isNullString:self.User_phone] &&
        ![NSString isNullString:self.value]) {
        NSDictionary *dictionary;
        if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
            dictionary = (NSDictionary *)self.requestParams;
        }
//        self.User_phone = @"13220332922";
//        self.value = @"10";
        
        NSDictionary *dic = @{
            @"user_phone":self.User_phone,//被赠送用户手机
            @"user_pid":@"",//屏蔽了
            @"value":self.value//数量
        };
           
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodRecord_goodsURL
                                                         parameters:@{
                                                             @"data":dic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response) {
                @strongify(self)
                NSLog(@"--%@",response);
                Toast(@"赠送成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        Toast(@"请输入数据");
    }
}

@end

//
//  LookUpContactWayVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/26.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "LookUpContactWayVC+VM.h"

@implementation LookUpContactWayVC (VM)

-(void)netWorking{
//    if ([PersonalInfo sharedInstance].isLogined) {
//        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//        //0、普通用户;1、普通商家;2、高级商家;3、vip商家
//        if ([model.grade_id intValue] == 0) {//普通用户
//            
//        }else if ([model.grade_id intValue] == 1){//普通商家
//            
//        }else if ([model.grade_id intValue] == 2){//高级商家  买家
//            
//        }else if ([model.grade_id intValue] == 3){//vip商家 卖家
//            
//        }else{}
//    }
    
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    if ([[PersonalInfo sharedInstance]isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        NSDictionary *dic = @{
            @"user_id":model.userId
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:GetSuperior
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
            NSLog(@"");
        }];
    }
    
    
}

@end

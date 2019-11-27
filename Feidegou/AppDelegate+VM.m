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
    extern NSString *randomStr;
    NSNumber *num;
    if ([onlinePeople isEqualToString:@"Online"]) {
        num = [NSNumber numberWithInt:1];
    }else if ([onlinePeople isEqualToString:@"Offline"]){
        num = [NSNumber numberWithInt:-1];
    }else{}
    NSDictionary *dic = @{
        @"type":num
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

@end

//
//  Q_Pet+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/18.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "Q_Pet+VM.h"

@implementation Q_Pet (VM)

-(void)feed{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic = @{
        @"lifeValue":[NSNumber numberWithInt:1]
    };

    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:PestFeedUrl
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
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
                if (self.block) {
                    self.block(str);
                }
            }
        }
    }];
}

@end

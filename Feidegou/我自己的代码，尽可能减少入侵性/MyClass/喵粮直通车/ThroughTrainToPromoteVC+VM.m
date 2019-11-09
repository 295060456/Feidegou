//
//  ThroughTrainToPromoteVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC+VM.h"

@implementation ThroughTrainToPromoteVC (VM)

-(void)netWorking:(NSString *)quantity{
//    if (![NSString isNullString:self.quantity]) {
//            extern NSString *randomStr;
//        NSDictionary *dataDic = @{
//            @"user_id":@"1",//KKK
//            @"quantity":quantity
//        };
//        randomStr = [EncryptUtils shuffledAlphabet:16];
//        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
//                                                               path:CatfoodTrainURL
//                                                         parameters:@{
//                                                             @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
//                                                             @"key":[RSAUtil encryptString:randomStr
//                                                                                 publicKey:RSA_Public_key]
//                                                         }];
//        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//#warning 以下是临时的
//            @weakify(self)
//            [StallListVC pushFromVC:self_weak_
//                      requestParams:nil
//                            success:^(id data) {}
//                           animated:YES];
//#warning 以上是临时的
////            if ([response isKindOfClass:[NSArray class]]) {
////
////            }
//
////            if (response) {
////                NSLog(@"--%@",response);\
//                if (!response.reqError) {
//                    @weakify(self)
//                    [StallListVC pushFromVC:self_weak_
//                              requestParams:nil
//                                    success:^(id data) {}
//                                   animated:YES];
//                }
////            }
//        }];
//    }
}//说是废弃了




@end

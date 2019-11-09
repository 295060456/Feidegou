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

#pragma mark —— SRWebSocketDelegate
- (void)SRWebSocketDidOpen {//开启
    NSLog(@"开启成功");
    //在成功后需要做的操作...
}
//WebSocketURL
-(void)webSocket:(NSString *)quantity{
    if (![NSString isNullString:quantity]) {//
        NSString *urlStr = [BaseWebSocketURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",@"1",quantity]];
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlStr];
    }else{
        Toast(@"请输入参与抢摊位的数量");
    }
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {//接受消息
    @weakify(self)
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    //收到服务端发送过来的消息
    if ([note.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)note.object;
        
        NSArray *array = [ThroughTrainToPromoteModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        if (array) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop) {
                @strongify(self)
                ThroughTrainToPromoteModel *model = array[idx];
                [self.dataMutArr addObject:model];
            }];
        }
    }else{}
    
    if (self.dataMutArr.count) {
        [StallListVC pushFromVC:self_weak_
                  requestParams:self.dataMutArr
                        success:^(id data) {}
                        animated:YES];
    }
}

- (void)SRWebSocketDidClose:(NSNotification *)note {//断开
    
}

@end

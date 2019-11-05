//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)

-(void)CancelDelivery_NetWorking{

    extern NSString *randomStr;
    NSDictionary *dic;
    OrderListModel *model;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)self.requestParams;
        model = dic[@"OrderListModel"];
    }
    NSDictionary *dataDic = @{
         @"order_id":[NSString stringWithFormat:@"%d",model.ID],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString stringWithFormat:@"%d",model.order_type]//订单类型 —— 1、摊位;2、批发;3、产地
    };
    
    NSDictionary *picDic = @{
        @"del_print":self.pic,//上传凭证图片,图片放request,不加密
    };
    
    NSData *picData = [NSJSONSerialization dataWithJSONObject:picDic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    
    self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:CatfoodRecord_delURL
                                                               params:dataDic
                                                            fileDatas:@[picData]//(NSArray<NSData *> *)
                                                                 name:@"撤销凭证"
                                                             mimeType:@""];
    
//    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
//            @strongify(self)
            NSLog(@"--%@",response);
        }
    }];
    
    
//    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
//                                                           path:CatfoodRecord_delURL
//                                                     parameters:@{
//                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
//                                                         @"key":[RSAUtil encryptString:randomStr
//                                                                             publicKey:RSA_Public_key]
//                                                     }];
//    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//    @weakify(self)
//    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//        if (response) {
//            @strongify(self)
//            NSLog(@"--%@",response);
//
//        }
//    }];
}

@end

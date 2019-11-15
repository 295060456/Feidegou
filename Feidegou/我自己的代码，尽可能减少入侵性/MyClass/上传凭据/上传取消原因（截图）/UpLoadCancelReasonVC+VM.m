//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)
//#5
-(void)CancelDelivery_NetWorking{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    extern NSString *randomStr;
    NSDictionary *dic;
    OrderListModel *model;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)self.requestParams;
        model = dic[@"OrderListModel"][@"OrderListModel"];
    }
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@"无"],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
         @"user_id":modelLogin.userId,
         @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:self.pic];
    [mgr POST:API(BaseUrl2, CatfoodRecord_delURL)
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key]
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"del_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        Toast(@"上传图片中...");
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        Toast(@"上传图片成功");
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        Toast(@"上传图片失败");
    }];
}

-(void)CancelDelivery_NetWorking1{

    extern NSString *randomStr;
    NSDictionary *dic;
    OrderListModel *model;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)self.requestParams;
        model = dic[@"OrderListModel"][@"OrderListModel"];
    }
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@"无"],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@"无"]//订单类型 —— 1、摊位;2、批发;3、产地
    };

    NSData *picData = [UIImage imageZipToData:self.pic];
    
//    NSDictionary *picDic = @{
//        @"del_print":self.pic,//上传凭证图片,图片放request,不加密
//    };
//    NSData *picData = [NSJSONSerialization dataWithJSONObject:picDic
//                                                   options:NSJSONWritingPrettyPrinted
//                                                     error:nil];

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
}

@end

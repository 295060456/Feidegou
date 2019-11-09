//
//  ShopReceiptQRcodeVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ShopReceiptQRcodeVC+VM.h"

@implementation ShopReceiptQRcodeVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodWeixin_quarURL
                                                     parameters:@{
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                self.QRcodeStr = dic[@"weixin_qr_img"];
                [self QRcode];
            }
        }
    }];
}

-(void)uploadQRcodePic:(UIImage *)image{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    extern NSString *randomStr;
//    NSDictionary *dic;
//    OrderListModel *model;
//    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
//        dic = (NSDictionary *)self.requestParams;
//        model = dic[@"OrderListModel"][@"OrderListModel"];
//    }
//
//    NSDictionary *dataDic = @{
//         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@""],//订单id
//         @"reason":dic[@"Result"],//撤销理由
//         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@""]//订单类型 —— 1、摊位;2、批发;3、产地
//    };
    __block NSData *picData = [UIImage imageZipToData:image];
    [mgr POST:API(BaseUrl2, Catfood_qr_addURL)
   parameters:@{
//       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key]
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"weixin_qr"//Key
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

@end

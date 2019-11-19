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
                if ([dic[@"weixin_qr_img"] isKindOfClass:[NSString class]]) {
                    if (![NSString isNullString:dic[@"weixin_qr_img"]]) {
                        self.QRcodeStr = dic[@"weixin_qr_img"];
                        @weakify(self)
                        dispatch_async(dispatch_get_main_queue(), ^{
                           @strongify(self)
                           [self QRcode];
                        });
                    }
                }
                if ([NSString isNullString:self.QRcodeStr]) {
                    @weakify(self)
                    dispatch_async(dispatch_get_main_queue(), ^{
                       @strongify(self)
                       self.QRcodeIMGV.image = kIMG(@"上传二维码");
                    });
                }
            }
        }
    }];
}

-(void)uploadQRcodePic:(UIImage *)image{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    extern NSString *randomStr;
    
    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
    //每个接口都加 user_id 和 identity
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        [dataMutDic setObject:model.userId
                       forKey:@"user_id"];
    }
    [dataMutDic setObject:[YDDevice getUQID]
                   forKey:@"identity"];
    
    __block NSData *picData = [UIImage imageZipToData:image];
    [mgr POST:API(BaseUrl, Catfood_qr_addURL)
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataMutDic], randomStr),
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
        CGFloat _percent = uploadProgress.fractionCompleted * 100;
        NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
        NSLog(@"%@",str);
        Toast(@"str");
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

@end


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
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodWeixin_quarURL
                                                     parameters:@{
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
                        self.QRcodeStr_wechatPay = dic[@"weixin_qr_img"];
                        @weakify(self)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @strongify(self)
                            [self.qrCodeIMGV_wechatPay imgCode:dic[@"weixin_qr_img"]];
                        });
                    }
                }
                if ([dic[@"alipay_qr_img"] isKindOfClass:[NSString class]]) {
                    if (![NSString isNullString:dic[@"alipay_qr_img"]]) {
                        self.QRcodeStr_alipay = dic[@"alipay_qr_img"];
                        @weakify(self)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @strongify(self)
                            [self.qrCodeIMGV_alipay imgCode:dic[@"alipay_qr_img"]];
                        });
                    }
                }
            }
        }
    }];
}

-(void)uploadQRcodePic:(UIImage *)image
             withStyle:(PaywayType)paywayType{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
    //每个接口都加 user_id 和 identity
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        [dataMutDic setObject:model.userId
                       forKey:@"user_id"];
    }
    [dataMutDic setObject:[YDDevice getUQID]
                   forKey:@"identity"];
    
    if (paywayType == PaywayTypeWX) {
        [dataMutDic setObject:@"weixin_qr"
                       forKey:@"qr_type"];
    }else if (paywayType == PaywayTypeZFB){
        [dataMutDic setObject:@"alipay_qr"
                       forKey:@"qr_type"];
    }else{
        NSLog(@"错误");
        return;
    }
    __block NSData *picData = [UIImage imageZipToData:image];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,Catfood_qr_addURL];
    [mgr POST:str
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataMutDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key],
       @"randomStr":randomStr
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (paywayType == PaywayTypeWX) {
            [formData appendPartWithFileData:picData
                                        name:@"qr_type"//Key
                                    fileName:@"weixin_qr"//图片名
                                    mimeType:@"image/jpeg"];
        }else if (paywayType == PaywayTypeZFB){
            [formData appendPartWithFileData:picData
                                        name:@"qr_type"//Key
                                    fileName:@"alipay_qr"//图片名
                                    mimeType:@"image/jpeg"];
        }else{
            NSLog(@"错误");
            return;
        }
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        CGFloat _percent = uploadProgress.fractionCompleted * 100;
        NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
        NSLog(@"%@",str);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(str);
        }];
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary *dic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
        NSNumber *b = dic[@"code"];
        if ([b intValue] == 500) {
            NSString *str = dic[@"message"];
            Toast(str);
        }else if ([b intValue] == 200){
            NSString *str = dic[@"message"];
            Toast(str);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                Toast(@"上传图片成功");
            }];
            [self backBtnClickEvent:UIButton.new];
        }else{}
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
    }];
}

@end


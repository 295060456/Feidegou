//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)

-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    __block NSData *picData = [UIImage imageZipToData:image];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    
    NSDictionary *dic = @{
        @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
        @"key":[RSAUtil encryptString:randomStr
                            publicKey:RSA_Public_key],
        @"randomStr":randomStr
    };
    
    self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:CatfoodCO_payURL
                                                               params:dic
                                                            fileDatas:@[picData]
                                                                 name:@"payment_print"//字段名
                                                             mimeType:@"image/png"];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        NSDictionary *dic = [NSString dictionaryWithJsonString:aesDecryptString(response.reqResult, randomStr)];
        NSLog(@"%@",dic);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(dic[@"message"]);
        }];
        if ([dic[@"code"] intValue] == 200) {
            NSArray *vcArr = self.navigationController.viewControllers;
            UIViewController *vc = vcArr[2];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }];
}
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic{//
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:pic];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    @weakify(self)
    [mgr POST:[NSString stringWithFormat:@"%@%@",ImgBaseURL,CatfoodSale_payURL]//正式BaseURL 测试BaseUrl
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key],
       @"randomStr":randomStr
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"payment_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
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
        @strongify(self)
        NSDictionary *dataDic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(dataDic[@"message"]);
        }];
        NSArray *vcArr = self.navigationController.viewControllers;
        UIViewController *vc = vcArr[2];
        [self.navigationController popToViewController:vc animated:YES];
    }
      failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}
 //上传图片
 -(void)CatfoodRecord_delURL_netWorking:(UIImage *)image{
     NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
     __block NSData *picData = [UIImage imageZipToData:image];
     ModelLogin *modelLogin;
     if ([[PersonalInfo sharedInstance] isLogined]) {
         modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
     }
     NSDictionary *dataDic = @{
         @"order_id":self.Order_id,
         @"user_id":modelLogin.userId,
         @"identity":[YDDevice getUQID]
     };

     NSDictionary *dic = @{
         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
         @"key":[RSAUtil encryptString:randomStr
                             publicKey:RSA_Public_key],
         @"randomStr":randomStr
     };

     self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:CatfoodRecord_delURL
                                                                params:dic
                                                             fileDatas:@[picData]
                                                                  name:@"test.png"
                                                              mimeType:@"image/png"];
     @weakify(self)
     [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
         @strongify(self)
         NSDictionary *dic = [NSString dictionaryWithJsonString:aesDecryptString(response.reqResult, randomStr)];
         NSLog(@"%@",dic);
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             Toast(dic[@"message"]);
         }];
         if ([dic[@"code"] intValue] == 200) {
                     NSArray *vcArr = self.navigationController.viewControllers;
             UIViewController *vc = vcArr[2];
             [self.navigationController popToViewController:vc animated:YES];
         }
     }];
 }



@end

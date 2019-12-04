//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)
//CatfoodCO_payURL 喵粮产地购买已支付  #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block NSData *picData = [UIImage imageZipToData:image];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    @weakify(self)
    NSString *str = [NSString jointMakeURL:@[ImgBaseURL,@"/catfoodapp",@"/CatfoodCO_payURL"]];
    [mgr POST:str//正式BaseURL 测试BaseUrl
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
      success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"responseObject = %@",responseObject);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传凭证成功");
        }];
        NSArray *vcArr = self.navigationController.viewControllers;
        UIViewController *vc = vcArr[2];
        [self.navigationController popToViewController:vc animated:YES];
        }
      failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
    }];
}
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic{
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
//CatfoodRecord_delURL 喵粮订单撤销 #5
-(void)CancelDelivery_NetWorking{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)self.requestParams;
    }
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:self.Order_id ReplaceStr:@"无"],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:self.Order_type ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
         @"user_id":modelLogin.userId,
         @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:self.pic];
    @weakify(self)
    [mgr POST:[NSString stringWithFormat:@"%@%@",ImgBaseURL,CatfoodRecord_delURL]//正式BaseURL 测试BaseUrl
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key],
       @"randomStr":randomStr
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"del_print"
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
        NSLog(@"responseObject = %@",responseObject);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片成功");
        }];
        NSArray *vcArr = self.navigationController.viewControllers;
        UIViewController *vc = vcArr[2];
        [self.navigationController popToViewController:vc animated:YES];
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
    }];
}
//喵粮订单撤销 post 5 Y PIC 不加catfoodapp
-(void)CancelDelivery_NetWorking1{//废弃
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
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

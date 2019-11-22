//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)
//CatfoodRecord_delURL 喵粮订单撤销 #5
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
    [mgr POST:API(BaseUrl, CatfoodRecord_delURL)
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
        CGFloat _percent = uploadProgress.fractionCompleted * 100;
        NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
        NSLog(@"%@",str);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(str);
        }];
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片成功");
        }];
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
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
//CatfoodCO_payURL 喵粮产地购买已支付  #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image{
    extern NSString *randomStr;
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    if (self.orderListModel) {
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        __block NSData *picData = [UIImage imageZipToData:image];
        NSDictionary *dataDic = @{
            @"order_id":[self.orderListModel.ID stringValue],//order_id
            @"user_id":modelLogin.userId,
            @"identity":[YDDevice getUQID]
        };
        [mgr POST:API(BaseUrl, CatfoodCO_payURL)
       parameters:@{
           @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
           @"key":[RSAUtil encryptString:randomStr
                               publicKey:RSA_Public_key]
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
}
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic{//真正开始购买
    extern NSString *randomStr;
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:pic];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr POST:API(BaseUrl, CatfoodSale_payURL)
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key]
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
        NSDictionary *dataDic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(dataDic[@"message"]);
        }];
//        switch ([dataDic[@"code"] longValue]) {
//            case 200:{//已完成付款.请等待审核后发货！
////                [self.sureBtn setTitle:@"已付款"
////                              forState:UIControlStateNormal];
//            }break;
//            case 300:{//订单状态异常，请检查！
//                
//            }break;
//            case 500:{//订单有误，请检查订单！
//                
//            }break;
//            default:
//                break;
//        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"error = %@",error);

    }];
}

@end

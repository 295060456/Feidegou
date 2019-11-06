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
    
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@""],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@""]//订单类型 —— 1、摊位;2、批发;3、产地
    };
    __block NSData *picData = [UIImage imageZipToData:self.pic];
    [mgr POST:@"http://10.1.41.158:8080/user/seller/CatfoodRecord_del.htm"
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
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
        
//        [mgr POST:@"http://120.25.226.186:32812/upload"
//       parameters:@{
//           @"username" : @"123"
//       }
//            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//             在这个block中设置需要上传的文件
//                NSData *data = [NSData dataWithContentsOfFile:@"/Users/xiaomage/Desktop/placeholder.png"];
//
////                方法一
//                [formData appendPartWithFileData:data name:@"file" fileName:@"test.png" mimeType:@"image/png"];
//
////                方法二：自动给封装filename、mimeType
//                [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/placeholder.png"] name:@"file" fileName:@"xxx.png" mimeType:@"image/png" error:nil];
//
//                //方法三：自动给封装filename、mimeType
//                [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/placeholder.png"] name:@"file" error:nil];
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"-------%@", responseObject);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        }];
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
         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@""],//订单id
         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@""]//订单类型 —— 1、摊位;2、批发;3、产地
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

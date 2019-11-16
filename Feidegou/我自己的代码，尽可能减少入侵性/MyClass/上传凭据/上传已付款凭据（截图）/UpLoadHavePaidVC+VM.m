//
//  UpLoadHavePaidVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/8.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadHavePaidVC+VM.h"

@implementation UpLoadHavePaidVC (VM)

-(void)uploadPic_netWorking:(UIImage *)image{
//    extern NSString *randomStr;
//    ModelLogin *modelLogin;
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//    }
//    if ([self.requestParams isKindOfClass:[OrderDetail_BuyerModel class]]) {
//        OrderDetail_BuyerModel *model = (OrderDetail_BuyerModel *)self.requestParams;
//        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//        __block NSData *picData = [UIImage imageZipToData:image];
//        NSDictionary *dataDic = @{
//            @"order_id":[model.ID stringValue],//order_id
//            @"user_id":modelLogin.userId,
//            @"identity":[YDDevice getUQID]
//        };
//        [mgr POST:API(BaseUrl2, CatfoodCO_payURL)
//       parameters:@{
//           @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
//           @"key":[RSAUtil encryptString:randomStr
//                               publicKey:RSA_Public_key]
//       }
//    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            [formData appendPartWithFileData:picData
//                                        name:@"payment_print"
//                                    fileName:@"test.png"
//                                    mimeType:@"image/png"];
//        }
//         progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"uploadProgress = %@",uploadProgress);
//            Toast(@"上传图片中...");
//        }
//          success:^(NSURLSessionDataTask * _Nonnull task,
//                    id  _Nullable responseObject) {
//            NSLog(@"responseObject = %@",responseObject);
//            Toast(@"上传凭证成功");
//            NSArray *vcArr = self.navigationController.viewControllers;
//            UIViewController *vc = vcArr[2];
//            [self.navigationController popToViewController:vc animated:YES];
//            }
//          failure:^(NSURLSessionDataTask * _Nullable task,
//                    NSError * _Nonnull error) {
//            NSLog(@"error = %@",error);
//            Toast(@"上传图片失败");
//        }];
//    }
}


@end

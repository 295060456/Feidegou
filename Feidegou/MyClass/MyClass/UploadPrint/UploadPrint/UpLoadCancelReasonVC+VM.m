//
//  UpLoadCancelReasonVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC+VM.h"

@implementation UpLoadCancelReasonVC (VM)
//CatfoodCO_payURL 喵粮产地购买已支付 #8 喵粮产地专用上传凭证
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
////喵粮订单撤销 post 5 Y PIC 不加catfoodapp 直通车专用上传凭证
 -(void)CatfoodRecord_delURL_netWorking:(UIImage *)image{
     NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
     __block NSData *picData = [UIImage imageZipToData:image];
     ModelLogin *modelLogin;
     if ([[PersonalInfo sharedInstance] isLogined]) {
         modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
     }
     NSDictionary *dataDic = @{
         @"order_id":self.Order_id,
     };

     NSDictionary *dic = @{
         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
         @"key":[RSAUtil encryptString:randomStr
                             publicKey:RSA_Public_key],
         @"randomStr":randomStr
     };

     self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:Booth_order_del_printURL
                                                                params:dic
                                                             fileDatas:@[picData]
                                                                  name:@"del_print"
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
             [self chat];
         }
     }];
 }



@end

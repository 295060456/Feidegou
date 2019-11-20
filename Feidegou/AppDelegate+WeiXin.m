//
//  AppDelegate+WeiXin.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate+WeiXin.h"

@implementation AppDelegate (WeiXin)

- (void)shareWeixin{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
//        [platformsRegister setupWeChatWithAppId:@"wx7d314006a5998a80" appSecret:@"36f4c00f85dfeef68df209402ff9c726"];
        
    }];
//    [ShareSDK registerActivePlatforms:@[
//                                        @(SSDKPlatformTypeWechat)                                        ]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx7d314006a5998a80"
//                                       appSecret:@"ab2c06d73b7f8a63be70046d8dc0b6d8"];
//                 break;
//             default:
//                 break;
//         }
//     }];
}

- (void)_sendPay:(NSDictionary *)dict{
    if(dict != nil){
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //        NSString *stamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        D_NSLog(@"timeSp:%@",stamp); //时间戳的值
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
//        [WXApi sendReq:req];
        //日志输出
        D_NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}

-(void)onReq:(BaseReq*)req{
    
    D_NSLog(@"onReq is %@",req);
}
//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
- (void)onResp:(BaseResp *)resp{
    D_NSLog(@"- (void)onResp:(BaseResp *)resp %@",resp);
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        D_NSLog(@"error is %@",response);
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"成功!";
                NSLog(@"支付结果: 成功!");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                strMsg = @"失败!";
                NSLog(@"支付结果: 失败!");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                
                strMsg = @"取消支付!";
                NSLog(@"取消支付!");
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                strMsg = @"发送失败!";
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                strMsg = @"微信不支持!";
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                strMsg = @"授权失败!";
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
        if (resp.errCode!=WXSuccess) {
            NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                            message:strMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end

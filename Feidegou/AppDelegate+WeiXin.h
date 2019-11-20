//
//  AppDelegate+WeiXin.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WeiXin)
<
WXApiDelegate
>

-(void)shareWeixin;
-(void)_sendPay:(NSDictionary *)dict;
-(void)onReq:(BaseReq*)req;
-(void)onResp:(BaseResp *)resp;

@end

NS_ASSUME_NONNULL_END

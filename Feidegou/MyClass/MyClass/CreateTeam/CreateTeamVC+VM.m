//
//  CreateTeamVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "CreateTeamVC+VM.h"

@implementation CreateTeamVC (VM)

//#define GetTeam @"/catfoodapp/user/getTeam.htm"//查看用戶信息
-(void)lookUserInfo{
    extern NSString *randomStr;
    if ([[PersonalInfo sharedInstance]isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        NSDictionary *dic = @{
            @"user_id":model.userId
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:GetTeam
                                                         parameters:@{
                                                             @"data":dic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            NSLog(@"");
        }];
    }
}
//#define Updatewx @"/catfoodapp/user/updatewx.htm"//我的团队修改信息 需要传给我的值   微信必填其余可不填：weixin_account QQ user_id  contactmobile手机号
-(void)ChangeMyInfo{
    extern NSString *randomStr;
    if ([NSString isNullString:self.telePhoneStr]) {
        Toast(@"请填写微信账号");
        return;
    }
    if ([[PersonalInfo sharedInstance]isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        NSDictionary *dic = @{
            @"user_id":model.userId,
            @"weixin_account":[NSString isNullString:self.wechatStr] ? @"" : self.wechatStr,//微信账号 必填
            @"QQ":[NSString isNullString:self.QQStr] ? @"" : self.QQStr,//QQ号码 选填
            @"contactmobile": [NSString isNullString:self.telePhoneStr] ? @"" :self.telePhoneStr//手机号 选填
        };
        
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:Updatewx
                                                         parameters:@{
                                                             @"data":dic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
        }];
    }
}






@end

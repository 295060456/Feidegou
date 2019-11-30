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
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                if (dic[@"weixin_account"]) {
                    self.wechatPlaceholderStr = dic[@"weixin_account"];
                    [self.sendBtn setTitle:@"点我修改"
                                  forState:UIControlStateNormal];
                    [self.titleMutArr addObject:[self.invitationCodeStr stringByAppendingString:[NSString ensureNonnullString:dic[@"code"] ReplaceStr:@"暂无信息"]]];
                }else{
                    [self.sendBtn setTitle:@"点我发送"
                                  forState:UIControlStateNormal];
                }
                for (ZYTextField *tf in self.dataMutSet) {
                    if ([tf.placeholder isEqualToString:self.titleMutArr[0]]) {//手机
                        tf.text = dic[@"contactmobile"];
                    }else if ([tf.placeholder isEqualToString:self.titleMutArr[1]]){//QQ
                        tf.text = dic[@"QQ"];
                    }else if ([tf.placeholder isEqualToString:self.titleMutArr[2]]){//微信
                        tf.text = dic[@"weixin_account"];
                    }else{}
                }
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }];
    }
}
//#define Updatewx @"/catfoodapp/user/updatewx.htm"//我的团队修改信息 需要传给我的值   微信必填其余可不填：weixin_account QQ user_id  contactmobile手机号
-(void)ChangeMyInfo{
    extern NSString *randomStr;
    if ([NSString isNullString:self.wechatStr]) {
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
            NSLog(@"");//OK
        }];
    }
}






@end

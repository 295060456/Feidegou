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
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
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
                                                                                 publicKey:RSA_Public_key],
                                                             @"randomStr":randomStr
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
                    if ([[PersonalInfo sharedInstance] isLogined]) {
                        [self.titleMutArr addObject:[self.invitationCodeStr stringByAppendingString:[NSString ensureNonnullString:[[PersonalInfo sharedInstance] fetchLoginUserInfo].code
                                                                                                                       ReplaceStr:@"暂无信息"]]];
                    }
                }else{
                    [self.sendBtn setTitle:@"点我发送"
                                  forState:UIControlStateNormal];
                }
                for (ZYTextField *tf in self.dataMutSet) {
                    if ([tf.placeholder isEqualToString:self.titleMutArr[0]]) {//手机
                        tf.text = dic[@"contactmobile"];
                        self.telePhoneStr = tf.text;
                    }else if ([tf.placeholder isEqualToString:self.titleMutArr[1]]){//QQ
                        tf.text = dic[@"QQ"];
                        self.QQStr = tf.text;
                    }else if ([tf.placeholder isEqualToString:self.titleMutArr[2]]){//微信
                        tf.text = dic[@"weixin_account"];
                        self.wechatStr = tf.text;
                    }else{}
                }
            
//                self.tableView.mj_footer.hidden = NO;
                [self.tableView reloadData];
            }
        }];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
//#define Updatewx @"/catfoodapp/user/updatewx.htm"//我的团队修改信息 需要传给我的值   微信必填其余可不填：weixin_account QQ user_id  contactmobile手机号
-(void)ChangeMyInfo{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
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
                                                                                 publicKey:RSA_Public_key],
                                                             @"randomStr":randomStr
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            NSLog(@"");//OK
            Toast(@"修改成功");
            [self backBtnClickEvent:UIButton.new];
        }];
    }
}


//-(void)my_NetworkingWithArgumentUsername:(NSString *)username
//                                password:(NSString *)password{
//
//    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
//    NSMutableDictionary *params = NSMutableDictionary.dictionary;
//    [params setObject:username forKey:@"userName"];
//    [params setObject:[EncryptUtils md5_32bits:password] forKey:@"password"];
//    // 设置为中国时区
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
//    [params setObject:strToday forKey:@"datetoken"];//token
//    [params setObject:[YDDevice getUQID] forKey:@"identity"];//设备号
//    [params setObject:[GettingDeviceIP getNetworkIPAddress] forKey:@"loginIp"];//ip
//
//    NSString *strJson = [self DataTOjsonString:params];// 字典转为json
//    strJson = [NSString encodeToPercentEscapeString:strJson];// encodeing  json
//    NSString *strKey =  [self encryptionTheParameter:strJson];// 根据json生成Key
//    [dataMutDic setObject:strKey forKey:@"key"];
//    //最后拼接
//    [dataMutDic setObject:strJson forKey:@"data"];
//    [dataMutDic setObject:@"4" forKey:@"version"];
//    [dataMutDic setObject:@"3203" forKey:@"num"];
//    [dataMutDic setObject:@"Yes" forKey:@"isIphone"];
//
//    //1.创建会话管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //2.发送GET请求
//    /*
//     第一个参数:请求路径(不包含参数).NSString
//     第二个参数:字典(发送给服务器的数据~参数)
//     第三个参数:progress 进度回调
//     第四个参数:success 成功回调
//        task:请求任务
//        responseObject:响应体信息(JSON--->OC对象)
//     第五个参数:failure 失败回调
//        error:错误信息
//     响应头:task.response
//     */
//    NSString *str = AK;//http://10.10.37.35:8080/SHOPAPP2.0/appShop7/query.do
//    [manager POST:AK
//       parameters:dataMutDic
//         progress:nil
//          success:^(NSURLSessionDataTask * _Nonnull task,
//                    id  _Nullable responseObject) {
//        NSLog(@"%@---%@",[responseObject class],responseObject);
//
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dataDic = (NSDictionary *)responseObject;
//            NSString *str = (NSString *)dataDic[@"data"][@"msg"];
//            if ([str isEqualToString:@"用户名或密码错误"]) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    Toast(str);
//                }];
//            }else if ([str isEqualToString:@"登录成功"]){
//                ModelLogin *model = [ModelLogin mj_objectWithKeyValues:responseObject[@"data"][@"data"]];
//                [[PersonalInfo sharedInstance] updateLoginUserInfo:model];
//                if ([[PersonalInfo sharedInstance] isLogined]) {
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//        //            [SVProgressHUD showSuccessWithStatus:@"登录成功但是存取状态异常"];
//        //            Toast(@"登录成功但是存取状态异常");
//                }
//            }else{}
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task,
//                NSError * _Nonnull error) {
//        NSLog(@"请求失败--%@",error);
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
//}



@end

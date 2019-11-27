//
//  JoinInTeamVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "JoinInTeamVC+VM.h"

@implementation JoinInTeamVC (VM)

//-(void)netWorking:(NSString *)inviter{
//
//    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
//    NSMutableDictionary *params = NSMutableDictionary.dictionary;
//    [params setObject:inviter forKey:@"inviter"];
//    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        [params setObject:model.userId forKey:@"user_id"];//[NSNumber numberWithInt:[model.userId intValue]]
//    }
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
//    [params setObject:strToday forKey:@"datetoken"];
//    [params setObject:[YDDevice getUQID] forKey:@"identity"];
//
//
//
//    NSString *strJson = [self DataTOjsonString:params];// 字典转为json
//    strJson = [NSString encodeToPercentEscapeString:strJson];// encodeing  json
//    NSString *strKey =  [self encryptionTheParameter:strJson];// 根据json生成Key
//    [dataMutDic setObject:strKey forKey:@"key"];
//    //最后拼接
//    [dataMutDic setObject:strJson forKey:@"data"];
//    [dataMutDic setObject:@"4" forKey:@"version"];
//    [dataMutDic setObject:@"4103" forKey:@"num"];
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
//    NSString *str = YQM;//http://10.1.41.174:8888/SHOPAPP2.0/appShop7/write.do
//                        //http://10.1.41.174:8888/SHOPAPP2.0/appShop7/query.do
//
//    [manager POST:@"http://10.1.41.174:8080/SHOPAPP3.0/appShop7/write.do"//YQM
//       parameters:dataMutDic
//         progress:nil
//          success:^(NSURLSessionDataTask * _Nonnull task,
//                    id  _Nullable responseObject) {
//        NSLog(@"%@---%@",[responseObject class],responseObject);
//        if ([responseObject[@"msg"] isEqualToString:@"成功"]) {
//            Toast(@"邀请码发送成功");
//            //跳到登陆页
//            [self.navigationController pushViewController:self.loginVC
//                                                 animated:YES];
//        }else{
//            Toast(responseObject[@"msg"]);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task,
//                NSError * _Nonnull error) {
//        NSLog(@"请求失败--%@",error);
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
//}

-(void)netWorking:(NSString *)inviter{
#warning tempData
//    inviter = @"1111";
    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
    NSMutableDictionary *params = NSMutableDictionary.dictionary;
    [params setObject:inviter forKey:@"inviter"];
    // 设置为中国时区
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
    [params setObject:strToday forKey:@"datetoken"];
    [params setObject:[YDDevice getUQID] forKey:@"identity"];
    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    if ([[PersonalInfo sharedInstance] isLogined]) {
        [params setObject:model.userId forKey:@"user_id"];//[NSNumber numberWithInt:[model.userId intValue]]
    }
    
    NSString *strJson = [self DataTOjsonString:params];// 字典转为json
    strJson = [NSString encodeToPercentEscapeString:strJson];// encodeing  json
    NSString *strKey =  [self encryptionTheParameter:strJson];// 根据json生成Key
    [dataMutDic setObject:strKey forKey:@"key"];
    //最后拼接
    [dataMutDic setObject:strJson forKey:@"data"];
    [dataMutDic setObject:@"4" forKey:@"version"];
    [dataMutDic setObject:@"4103" forKey:@"num"];
    [dataMutDic setObject:@"Yes" forKey:@"isIphone"];
    
//    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        [dataMutDic setObject:model.userId forKey:@"user_id"];
//    }
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
        task:请求任务
        responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
        error:错误信息
     响应头:task.response
     */
    NSString *str = YQM;//http://10.1.41.174:8888/SHOPAPP2.0/appShop7/write.do
                        //http://10.1.41.174:8888/SHOPAPP2.0/appShop7/query.do
    [manager POST:YQM //@"http://10.1.41.174:8080/SHOPAPP3.0/appShop7/write.do"
       parameters:dataMutDic
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        if ([responseObject[@"data"][@"msg"] isEqualToString:@"成功"]) {
            Toast(@"邀请码发送成功");
            //跳到登陆页
            [self.navigationController pushViewController:self.loginVC
                                                 animated:YES];
        }else{
            Toast(responseObject[@"data"][@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSString *)encryptionTheParameter:(NSString *)strJson{
    NSString *strKey = [EncryptUtils md5_32bits:strJson];
//    strKey = StringFormat(@"%@unknown",strKey);
    strKey = StringFormat(@"%@2200820a3e35ed74648e775cf3164e9d",strKey);
    strKey = [EncryptUtils md5_32bits:strKey];
    return strKey;
}

-(NSString*)DataTOjsonString:(id)object{
    // Pass 0 if you don't care about the readability of the generated string
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

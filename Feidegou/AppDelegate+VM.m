//
//  AppDelegate+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/24.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate+VM.h"

@implementation AppDelegate (VM)
//Catfood_statisticsUrl 统计直通车在线人数 35
-(void)onlinePeople:(NSString *)onlinePeople{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSNumber *num;
    if ([onlinePeople isEqualToString:@"Online"]) {
        num = [NSNumber numberWithInt:1];
    }else if ([onlinePeople isEqualToString:@"Offline"]){
        num = [NSNumber numberWithInt:-1];
    }else{}
    NSDictionary *dic = @{
        @"type":num,
        @"randomStr":randomStr
    };
    NSLog(@"%lu",(unsigned long)onlinePeople)
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfood_statisticsUrl
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

    }];
}
//buyer_CatfoodRecord_checkURL 喵粮订单查看
-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSString *)order_type
                                                    Order_id:(NSString *)order_id{//订单类型 —— 1、摊位;2、批发;3、产地
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":[NSString ensureNonnullString:order_id
                                       ReplaceStr:@"无"],//订单id
        @"order_type":[NSString ensureNonnullString:order_type
                                         ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
        @"randomStr":randomStr
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_checkURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = (NSDictionary *)response;
                JPushOrderDetailModel *model = [JPushOrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
                if (!self.orderDetailVC) {
                    @weakify(self)
                    self.orderDetailVC = [OrderDetailVC ComingFromVC:self_weak_.window.rootViewController
                                                           withStyle:ComingStyle_PUSH
                                                       requestParams:model
                                                             success:^(id data) {}
                                                            animated:YES];
                }
            }
        }
    }];
}

-(void)updateAPP{
    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
    NSMutableDictionary *params = NSMutableDictionary.dictionary;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];//获取app版本信息
    // 设置为中国时区
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
    [params setObject:strToday forKey:@"datetoken"];//token
    [params setObject:[YDDevice getUQID] forKey:@"identity"];//设备号
    [params setObject:[GettingDeviceIP getNetworkIPAddress] forKey:@"loginIp"];//ip

    NSString *strJson = [NSString DataTOjsonString:params];// 字典转为json
    strJson = [NSString encodeToPercentEscapeString:strJson];// encodeing  json
    NSString *strKey =  [NSString encryptionTheParameter:strJson];// 根据json生成Key
    [dataMutDic setObject:strKey forKey:@"key"];
    //最后拼接
    [dataMutDic setObject:strJson forKey:@"data"];
    [dataMutDic setObject:@"4" forKey:@"version"];
    [dataMutDic setObject:@"1021" forKey:@"num"];
    [dataMutDic setObject:@"Yes" forKey:@"isIphone"];

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
    NSString *str = AK;
    @weakify(self)
    [manager POST:AK
       parameters:dataMutDic
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"%@---%@",[responseObject class],responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *str = (NSString *)dic[@"msg"];
            if ([str isEqualToString:@"成功"]) {
                NSNumber *newBuild = dic[@"data"][@"VERSION"];
                // app版本
//                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                // app build版本
                NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
                if (newBuild.intValue > app_build.intValue) {
                    NSLog(@"是新版本");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新"
                                                                                             message:dic[@"data"][@"MSG"]
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去更新"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"data"][@"URL"]]];
                    }];
                    [alertController addAction:confirm];
                    [self.window.rootViewController presentViewController:alertController
                                                                 animated:YES
                                                               completion:nil];
                }else{
                    NSLog(@"不是新版本");
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end

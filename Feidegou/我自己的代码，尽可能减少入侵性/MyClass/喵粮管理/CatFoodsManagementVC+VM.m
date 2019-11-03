//
//  CatFoodsManagementVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC+VM.h"

@implementation CatFoodsManagementVC (VM)

-(void)networking1{
    
    NSDictionary *dic = @{
        @"user_id":@"1"
    };
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDict = @{
        @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
        @"key":[RSAUtil encryptString:randomStr
                            publicKey:RSA_Public_key]
    };
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
    [manager POST:@"http://10.1.41.158:8080/user/seller/Catfoodmanage.htm"
       parameters:paramDict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {

    }];
}

-(void)networking{
    /// 1. 配置参数
//    NSMutableDictionary *easyDict = [NSMutableDictionary dictionary];
    /// 2. 配置参数模型
    
//    NSString *str = [EncryptUtils shuffledAlphabet:16];
//
//    NSString *str = [RSAUtil encryptString:[EncryptUtils shuffledAlphabet:16] publicKey:RSA_Public_key];
    
//    @"user_id":@"1"
    
    NSDictionary *dic = @{
        @"user_id":@"1"
    };
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodManageURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) { 
        if (response.isSuccess) {
            NSLog(@"%p",response.reqResult);
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSLog(@"--%@",response.reqResult);

        }
    }];
}

@end

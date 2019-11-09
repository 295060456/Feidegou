//
//  JJHttpClient.m
//
//  Created by Joker on 15/1/24.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#define HTTPTimeoutInterval 10.0f //请求超时时间
#define HTTPTimeoutIntervalForPicture 60.0f //图片请求超时时间

#import "JJHttpClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

@interface JJHttpClient()
@end

@implementation JJHttpClient

- (RACSignal *)requestPOSTWithRelativePathByBaseURL:(NSString *)strBaseUrl andRelativePath:(NSString *)relativePath
                                         parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [self __httpSessionManagerWithBaseUrl:strBaseUrl];
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [manager POST:relativePath parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
//            [self __handleResponseObject:responseObject subscriber:subscriber];
            
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask *_Nullable task,NSError *_Nonnull error) {
            [self __handleRequestFailure:error subscriber:subscriber];
            
        }];
        return [RACDisposable disposableWithBlock:^{
            
            [dataTask cancel];
            
        }];
        
    }] doError:^(NSError *error) {
        
        NSLog(@"ERROR:%@",error);
        
    }];
    
}

/*!
 * 功能描述:POST请求
 * @param relativePath 请求相对路径地址
 * @param parameters 请求参数
 */
- (RACSignal *)requestPOSTWithRelativePath:(NSString *)relativePath
                                parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [self __httpSessionManagerWithBaseUrl:BASE_URL];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [manager POST:relativePath parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
            [self __handleResponseObject:responseObject subscriber:subscriber];
            
        } failure:^(NSURLSessionDataTask *_Nullable task,NSError *_Nonnull error) {
            [self __handleRequestFailure:error subscriber:subscriber];
            
        }];
        return [RACDisposable disposableWithBlock:^{

            [dataTask cancel];
            
        }];
        
    }] doError:^(NSError *error) {
        
        NSLog(@"ERROR:%@",error);
        
    }];

}


#pragma mark -
#pragma mark - 创建AFHTTPSessionManager
-(AFHTTPSessionManager*)__httpSessionManagerWithBaseUrl:(NSString*)baseUrl{

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求超时时间
    sessionConfiguration.timeoutIntervalForRequest =HTTPTimeoutInterval;
    //设置请求headers
    sessionConfiguration.HTTPAdditionalHeaders = @{@"source":@"ios"};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:baseUrl]  sessionConfiguration:sessionConfiguration];
    
    //设置请求数据格式(默认二进制)
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];//(二进制)
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];//(JSON)
    //manager.requestSerializer = [AFPropertyListRequestSerializer serializer];//(plist)
    
    //设置响应的数据格式(默认JSON);响应者的MIMEType不正确,就要修改acceptableContentTypes
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];//(二进制)
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];//(JSON)
    //manager.responseSerializer = [AFPropertyListResponseSerializer serializer];//(plist)
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];//(XML)
    //manager.responseSerializer = [AFImageResponseSerializer serializer];//(Image)
    //manager.responseSerializer = [AFCompoundResponseSerializer serializer];//(组合的)
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/plan",
                                                         @"text/html", nil];
    
    
    return manager;
}
#pragma mark -
#pragma mark - 请求成功,处理响应数据
-(void)__handleResponseObject:(id)responseObject subscriber:(id<RACSubscriber>)subscriber{
    
    D_NSLog(@"请求完成!ResponseObject:%@",responseObject);
    NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
    if (result == 1) {
        NSDictionary *dicData = [responseObject objectForKey:@"data"];
        [subscriber sendNext:dicData];
        [subscriber sendCompleted];
    }else{
        NSString *strMsg = responseObject[@"msg"];
        if ([NSString isNullString:strMsg]) {
//            strMsg= @"请求失败!";
            
            strMsg = StringFormat(@"%ld请求失败!",(long)result);

        }
        [subscriber sendError:[self requestErrorWithDescription:strMsg errorCode:result]];
    }
}
#pragma mark -
#pragma mark - 请求失败
-(void)__handleRequestFailure:(NSError*)error subscriber:(id<RACSubscriber>)subscriber{
    D_NSLog(@"请求失败 - error:[%@]%@",@(error.code),error.userInfo);
    D_NSLog(@"msg_server is %@",error.description);
    NSString *errorMsg = nil;
    errorMsg = error.localizedDescription;
    if ([NSString isNullString:errorMsg]) {
//        errorMsg = @"请求失败";
        
        errorMsg = StringFormat(@"%ld请求失败",(long)error.code);

    }
    errorMsg = StringFormat(@"%ld,%@",(long)error.code,errorMsg);
    [subscriber sendError:[self requestErrorWithDescription:errorMsg errorCode:error.code]];
}


#pragma mark -
#pragma mark - 生成错误信息
-(NSError*)requestErrorWithDescription:(NSString*)description errorCode:(NSInteger)errorCode{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"Domain" code:errorCode userInfo:userInfo];
    return error;
}
/**
 *  拼接参数
 *
 *  @param stype 接口编号
 *  @param data  参数
 *
 *  @return 参数字符串
 */
-(NSDictionary*)paramStringWithStype:(NSString*)stype
                                data:(NSDictionary*)data{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:data];//??
    [params setObject:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] forKey:@"user_id"];
    [params setObject:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] forKey:@"userId"];
    D_NSLog(@"data is %@",data);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    设置为中国时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
//    strToday = TransformString(strToday);
    [params setObject:strToday forKey:@"datetoken"];
    //    字典转为json
    NSString *strJson = [self DataTOjsonString:params];/////
//    encodeing  json
    strJson = [NSString encodeToPercentEscapeString:strJson];
//    根据json生成Key
    NSString *strKey =  [self encryptionTheParameter:strJson];
    if (stype) {
        [params setObject:stype forKey:@"num"];//x
    }
    [params setObject:strJson forKey:@"data"];//
    [params setObject:strKey forKey:@"key"];//
    [params setObject:@"4" forKey:@"version"];//
    [params setObject:@"Yes" forKey:@"isIphone"];//
    D_NSLog(@"请求数据为：%@",params);
    return params;
}
- (NSString *)encryptionTheParameter:(NSString *)strJson{
    NSString *strKey = [self md5HexDigestSmall:strJson];
//    strKey = StringFormat(@"%@unknown",strKey);
    strKey = StringFormat(@"%@2200820a3e35ed74648e775cf3164e9d",strKey);
    strKey = [self md5HexDigestSmall:strKey];
    return strKey;
}

- (NSString *)md5HexDigestUpper:(NSString*)input
{
//    const char *cStr = [input UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [[NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ] uppercaseString];
    return [[self md5HexDigestSmall:input] uppercaseString];
}

- (NSString *)md5HexDigestSmall:(NSString*)input{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ];
}
-(NSString*)DataTOjsonString:(id)object
{
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
















//
//  FMHttpRequest.m
//  ZFMRACNetwork
//
//  Created by todriver02 on 2018/7/31.
//  Copyright © 2018年 zhufaming. All rights reserved.
//

#import "FMHttpRequest.h"

@implementation ExtendsParameters

+ (instancetype)extendsParameters{
    return self.new;
}

- (instancetype)init{
    if (self = [super init]) {
    }return self;
}

- (NSString *)version{
    static NSString *version = nil;
    if (!version) version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return (version.length > 0) ? version:@"";
}

- (NSString *)token {
    // token 自己的逻辑
    return @"";
}
//设备ID 自行逻辑获取
- (NSString *)deviceid{
    static NSString *deviceidStr = nil;
    return deviceidStr.length > 0 ? deviceidStr:@"";
}

- (NSString *)platform{
    return @"iOS";
}

- (NSString *)channel{
    return @"AppStore";
}

- (NSString *)t{
    return [NSString stringWithFormat:@"%.f", [NSDate date].timeIntervalSince1970];
}

@end

@implementation FMHttpRequest

+(instancetype)urlParametersWithMethod:(NSString *)method
                                  path:(NSString *)path
                            parameters:(NSDictionary *)parameters{
    extern NSString *randomStr;
    NSDictionary *dataDic = parameters[@"data"];
    NSMutableDictionary *dataMutDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        [dataMutDic setObject:model.userId
                       forKey:@"user_id"];
        [dataMutDic setObject:[YDDevice getUQID]
                       forKey:@"identity"];
        
    }

    NSMutableDictionary *returnMutDic = NSMutableDictionary.dictionary;
    for (int f = 0; f < parameters.count; f ++) {
        [returnMutDic setValue:parameters[@"key"]
                        forKey:@"key"];
        [returnMutDic setValue:aesEncryptString([NSString convertToJsonData:dataMutDic], randomStr)
                        forKey:@"data"];
    }
    NSLog(@"");
    
//    //每个接口都加 user_id 和 identity
//    NSMutableDictionary *mutData = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    NSDictionary *dataDic = mutData[@"data"];//不动，在此基础上进行拼接
//    NSMutableDictionary *mutDataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//        [mutDataDic setObject:aesEncryptString(model.userId, randomStr)
//                       forKey:@"user_id"];
//    }else{
//        Toast(@"获取user_id失败");
//    }
//    [mutDataDic setObject:aesEncryptString([YDDevice getUQID], randomStr)
//                   forKey:@"identity"];
//    [mutData removeObjectForKey:@"data"];//只剩下@“key”
//    for (int d = 0; d < mutData.count; d++) {
//        [mutDataDic setObject:mutData.allValues[d]
//                       forKey:mutData.allKeys[d]];
//    }

    return [[self alloc]initUrlParametersWithMethod:method
                                               path:path
                                         parameters:returnMutDic];
}

-(instancetype)initUrlParametersWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters{
    if (self = [super init]) {
        self.method = method;
        self.path = path;
        self.parameters = parameters;
        self.extendsParameters = ExtendsParameters.new;
    }return self;
}

@end

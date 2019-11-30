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
    //取出
    NSDictionary *dataDic = parameters[@"data"];
    NSMutableDictionary *dataMutDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    for (int i = 0; i < dataDic.count; i++) {
        [dataMutDic setValue:dataDic.allValues[i]
                      forKey:dataDic.allKeys[i]];
    }
    //每个接口都加 user_id 和 identity
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        [dataMutDic setObject:model.userId
                       forKey:@"user_id"];
    }
    [dataMutDic setObject:[YDDevice getUQID]
                   forKey:@"identity"];
    //封装
    NSMutableDictionary *returnMutDic = NSMutableDictionary.dictionary;
    for (int f = 0; f < parameters.count; f ++) {
        [returnMutDic setValue:parameters.allValues[f]
                        forKey:parameters.allKeys[f]];
    }return [[self alloc]initUrlParametersWithMethod:method
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

//
//  JJDBHelper+Center.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/11.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper+Center.h"
#define CenterMsg @"centerMsg"
#define AlipayInfo @"alipayInfo"
#define PersonalInfo @"personalInfo"

@implementation JJDBHelper (Center)

- (ModelCenter *)fetchCenterMsg{
    
    NSData *data = [self queryCacheDataWithCacheId:CenterMsg];
    
    NSDictionary *dictionray = [self convertData:data];
    ModelCenter *model = [MTLJSONAdapter modelOfClass:[ModelCenter class]
                                   fromJSONDictionary:dictionray
                                                error:nil];
    return model;
}

- (void)saveCenterMsg:(ModelCenter *)model{
    NSDictionary *dicInfo = [model toDictionary];
    if (!dicInfo) {
        dicInfo = [NSDictionary dictionary];
    }
    [self updateCacheForId:CenterMsg cacheDictionry:dicInfo];
}

- (NSString *)fetchAlipayName{
    NSString *strName;
    
    NSData *data = [self queryCacheDataWithCacheId:AlipayInfo];
    
    NSDictionary *dictionray = [self convertData:data];
    strName = dictionray[@"name"];
    if ([NSString isNullString:strName]) {
        strName = @"";
    }
    return strName;
}
/**
 *  查询支付宝账户
 *
 *  @return NSString
 */
- (NSString *)fetchAlipayAccount{
    
    NSString *strAccount;
    NSData *data = [self queryCacheDataWithCacheId:AlipayInfo];
    
    NSDictionary *dictionray = [self convertData:data];
    strAccount = dictionray[@"account"];
    if ([NSString isNullString:strAccount]) {
        strAccount = @"";
    }
    return strAccount;
}
/**
 *  保存支付宝信息
 *
 */
- (void)saveAlipayName:(NSString *)strName
            andAccount:(NSString *)strAccount{
    if (![NSString isNullString:strName]&&![NSString isNullString:strAccount]) {
        NSMutableDictionary *dicInfo = [NSMutableDictionary dictionary];
        [dicInfo setObject:strName forKey:@"name"];
        [dicInfo setObject:strAccount forKey:@"account"];
        [self updateCacheForId:AlipayInfo cacheDictionry:dicInfo];
    }
}

- (ModelInfo *)fetchPersonalInfo{
    
    NSData *data = [self queryCacheDataWithCacheId:PersonalInfo];
    
    NSDictionary *dictionray = [self convertData:data];
    ModelInfo *model = [MTLJSONAdapter modelOfClass:[ModelInfo class]
                                 fromJSONDictionary:dictionray
                                              error:nil];
    return model;
}

- (void)savePersonalInfo:(ModelInfo *)model{
    NSDictionary *dicInfo = [model toDictionary];
    if (!dicInfo) {
        dicInfo = [NSDictionary dictionary];
    }
    [self updateCacheForId:PersonalInfo cacheDictionry:dicInfo];
}

@end

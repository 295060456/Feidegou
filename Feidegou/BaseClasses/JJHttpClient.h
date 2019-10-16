//
//  JJHttpClient.h
//
//  Created by Joker on 15/1/24.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>

/**
 *  网络请求管理类，封装常用的请求方法
 */
@interface JJHttpClient : NSObject

/**
 *  POST请求
 *
 *  @param relativePath 请求相对路径地址
 *
 *  @return RACSignal
 */
- (RACSignal *)requestPOSTWithRelativePathByBaseURL:(NSString *)strBaseUrl
                                    andRelativePath:(NSString *)relativePath
                                         parameters:(NSDictionary *)parameters;
/**
*  POST请求
*
*  @param relativePath 请求相对路径地址
*  @param parameters   请求参数
*
*  @return RACSignal
*/
- (RACSignal *)requestPOSTWithRelativePath:(NSString *)relativePath
                                parameters:(NSDictionary *)parameters;
/**
 *  拼接参数
 *
 *  @param stype 接口编号
 *  @param data  参数
 *
 *  @return 参数字符串
 */
-(NSDictionary *)paramStringWithStype:(NSString *)stype
                                 data:(NSDictionary *)data;
//MD5大写加密
- (NSString *)md5HexDigestUpper:(NSString *)input;
//MD5小写加密
- (NSString *)md5HexDigestSmall:(NSString *)input;
//转化为json
-(NSString *)DataTOjsonString:(id)object;

@end








//
//  JJHttpClient+TwoZero.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient+TwoZero.h"

@implementation JJHttpClient (TwoZero)

-(RACSignal*)requestLeftNickname:(NSString *)nickname andUserid:(NSString *)userid{
    NSDictionary *param = [self paramStringWithStype:@"2068"
                                                data:@{@"nickname":nickname,
                                                       @"userid":userid}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary){
        return dictionary;
    }];
}

-(RACSignal*)requestHeadImageHead:(NSData *)data andUserid:(NSString *)user_id{
    NSString *_encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *param = [self paramStringWithStype:@"4021"
                                                data:@{@"head":_encodedImageStr}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary){
        return dictionary;
    }];
}
@end

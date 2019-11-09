//
//  JJHttpClient+Login.m
//  guanggaobao
//
//  Created by 谭自强 on 15/12/1.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient+Login.h"
#import "AppDelegate.h"

@implementation JJHttpClient (Login)

-(RACSignal*)requestLoginUSERNAME:(NSString *)USERNAME
                      andPASSWORD:(NSString *)PASSWORD
                  andIsChangedPsw:(BOOL)isChanged{
    if (isChanged == NO) {
        PASSWORD = [self md5HexDigestSmall:PASSWORD];
    }
    NSDictionary *param = [self paramStringWithStype:@"3028"
                                                data:@{
                                                    @"userName":USERNAME,
                                                    @"password":PASSWORD,
                                                }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param]
            map:^id(NSDictionary* dictionary) {
        [SVProgressHUD dismiss];
        NSInteger code = [[dictionary objectForKey:@"code"] integerValue];
        NSDictionary *datalist = [dictionary objectForKey:@"data"];
        NSMutableDictionary *dicInfo;
        if ([datalist isKindOfClass:[NSDictionary class]]) {
            dicInfo = [NSMutableDictionary dictionaryWithDictionary:datalist];
            [dicInfo setObject:dicInfo[@"id"] forKey:@"userId"];
        }
        if (code == 1) {
            ModelLogin *model = [MTLJSONAdapter modelOfClass:[ModelLogin class] fromJSONDictionary:dicInfo error:nil];
            [[PersonalInfo sharedInstance] updateLoginUserInfo:model];
            return model;
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
            [alertView showAlertView:appDelegate.window.rootViewController andTitle:nil andMessage:StringFormat(@"%@,请重新登录",dictionary[@"msg"])  andCancel:@"确定" andCanelIsRed:YES andBack:^{
                D_NSLog(@"点击了确定");
                [[PersonalInfo sharedInstance] deleteLoginUserInfo];
            }];
            return nil;
        }
    }];
}

-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE{
    
    NSDictionary *param = [self paramStringWithStype:@"2008"
                                                data:@{@"PHONE":PHONE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE andCODE:(NSString *)CODE{
    NSDictionary *param = [self paramStringWithStype:@"1010"
                                                data:@{@"PHONE":PHONE,
                                                       @"CODE":CODE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestIsRegisterPHONE:(NSString *)PHONE{
    NSDictionary *param = [self paramStringWithStype:@"3029"
                                                data:@{@"phone":PHONE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestIsRegisterinviterCode:(NSString *)inviterCode{
    NSDictionary *param = [self paramStringWithStype:@"3042"
                                                data:@{@"inviterCode":inviterCode}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE andPASSWORD:(NSString *)PASSWORD andinviter_id:(NSString *)inviter_id{
    
    PASSWORD = [self md5HexDigestSmall:PASSWORD];
    NSDictionary *param = [self paramStringWithStype:@"4008"
                                                data:@{
                                                       @"userName":PHONE,
                                                       @"password":PASSWORD,
                                                       @"inviter":inviter_id}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andType:(NSString *)strType{
    NSDictionary *param = [self paramStringWithStype:@"3047"
                                                data:@{
                                                       @"PHONE":PHONE,
                                                       @"type":strType
                                                       }];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andCODE:(NSString *)CODE{
    NSDictionary *param = [self paramStringWithStype:@"3048"
                                                data:@{
                                                       @"PHONE":PHONE,
                                                       @"CODE":CODE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andpassword_new:(NSString *)password_new{
    NSDictionary *param = [self paramStringWithStype:@"4018"
                                                data:@{
                                                       @"PHONE":PHONE,
                                                       @"password_new":[self md5HexDigestSmall:password_new]}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestForgetPswPHONE:(NSString *)PHONE{
    
    NSDictionary *param = [self paramStringWithStype:@"1067"
                                                data:@{@"PHONE":PHONE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFindBackPswPHONE:(NSString *)PHONE andPASSWORD:(NSString *)PASSWORD andCODE:(NSString *)CODE{
    
    PASSWORD = [self md5HexDigestSmall:PASSWORD];
    NSDictionary *param = [self paramStringWithStype:@"2066"
                                                data:@{@"PHONE":PHONE,
                                                       @"PASSWORD":PASSWORD,
                                                       @"CODE":CODE}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestJPUSHServiceRegistrationId:(NSString *)registrationId andUserid:(NSString *)userid{
    NSDictionary *param = [self paramStringWithStype:@"2972"
                                                data:@{@"registrationId":registrationId,
                                                       @"userid":userid}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestAdverStart{
    NSDictionary *param = [self paramStringWithStype:@"3027"
                                                data:@{}];
    
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        NSArray *arr = dictionary[@"ad"];
        if (![arr isKindOfClass:[NSArray class]]) {
            arr = [NSArray array];
        }
        if ([dictionary[@"code"] intValue]==1) {
            [[JJDBHelper sharedInstance] updateCacheForId:@"3027" cacheArray:arr];
        }
        return arr;
    }];
}
@end

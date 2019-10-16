//
//  PersonalInfo.m
//  fastdrive
//
//  Created by 谭自强 on 15/9/23.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "PersonalInfo.h"
#import "JJDBHelper+ShopCart.h"
#import "JJDBHelper+Center.h"
#define LOGIN_USER_INFO @"LOGIN_USER_INFO"//保存用户登录信息KEY
#define LOCATION_INFO @"LOCATION_INFO"//保存用户经纬度信息KEY
#define VENDOR_ADVERID @"VENDOR_ADVERID"//保存商家ID
#define MAIN_USER_INFO @"MAIN_USER_INFO"//保存用户首页信息KEY
#define StrRegistrationID @"StrRegistrationID"//极光推送ID

@implementation PersonalInfo

static PersonalInfo *personalInfo;

+ (PersonalInfo *)sharedInstance{
    static dispatch_once_t longOnce;
    dispatch_once(&longOnce, ^{
        personalInfo = [[PersonalInfo alloc] init];
    });
    return personalInfo;
}

-(void)updateLoginUserInfo:(ModelLogin*)model{
    NSMutableDictionary *dicInfo = [NSMutableDictionary dictionaryWithDictionary:[model toDictionary]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dicInfo forKey:LOGIN_USER_INFO];
    [userDefaults synchronize];
}

-(ModelLogin*)fetchLoginUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefaults objectForKey:LOGIN_USER_INFO];
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setValue:@"213123" forKey:@"userId"];
    
    ModelLogin *model = [MTLJSONAdapter modelOfClass:[ModelLogin class]
                                  fromJSONDictionary:userInfo
                                               error:nil];
//    D_NSLog(@"UserModel is %@",model);
    return model;
}

-(void)deleteLoginUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:LOGIN_USER_INFO];
    [userDefaults synchronize];
    [[JJDBHelper sharedInstance] deleteAddressDefault];
//    为个人中心的信息值空
    [[JJDBHelper sharedInstance] saveCenterMsg:nil];
}

-(BOOL)isLogined{
//    return YES;
    ModelLogin *model = [self fetchLoginUserInfo];
//    D_NSLog(@"model is %@",model);
    if ([NSString isNullString:model.userId]) {
        return NO;
    }else{
        return YES;
    }
}

@end

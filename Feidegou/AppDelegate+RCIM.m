//
//  AppDelegate+RCIM.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate+RCIM.h"

@implementation AppDelegate (RCIM)

-(void)RCIM{
    [[RCIM sharedRCIM] initWithAppKey:RongCloud_Key];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].isMediaSelectorContainVideo = YES;
}
#pragma mark —— RCIMConnectionStatusDelegate
/*!
 IMKit连接状态的的监听器

 @param status  SDK与融云服务器的连接状态

 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
}
#pragma mark —— RCIMUserInfoDataSource
/*!
 获取用户信息

 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]

 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
}

@end

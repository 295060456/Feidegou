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
    
    // 以下根据自己项目需求.进行配置
//    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;    //  开启用户信息和群组信息的持久化
////    [RCIM sharedRCIM].userInfoDataSource = [RCDRCIMDataSource shareInstance];     //  设置RongCloud用户信息数据源
////    [RCIM sharedRCIM].groupInfoDataSource = [RCDRCIMDataSource shareInstance];    //  设置RongCloud群组信息数据源
//    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;      //  是否在发送的所有消息中携带当前登录的用户信息
////    [RCIM sharedRCIM].receiveMessageDelegate = self;          //  设置接收消息代理
//    [RCIM sharedRCIM].enableTypingStatus =YES;                //  开启输入状态监听
//    [RCIM sharedRCIM].showUnkownMessage = YES;                //  设置显示未注册的消息
//    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;    //  未注册的消息类型是否显示本地通知
//    [RCIM sharedRCIM].disableMessageAlertSound = YES;         //  声音提示
//    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];     //  设置会话列表头像和会话界面头像
////    [[RCIM sharedRCIM] registerMessageType:[RRTCustomFriendMessage class]];   //  注册自定义消息类型
//    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(50, 50);    //  会话列表界面中显示的头像大
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

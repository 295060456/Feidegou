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
    ModelLogin *modelLogin = Nil;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        NSString *tokenStr = modelLogin.token;
        /*
        融云 sdk 的机制是，在 connect 后，会解析 token 获取到对应的 userId，然后根据 userId 打开对应的数据库（如果数据库中有该 userId 的数据），之后，使用者才可以调用获取历史消息，会话列表的接口，并获取到数据。

        所以，不论有没有网络，使用者都应该调用 connect。

        拿不到数据的原因之一，没有调用 connect，没有打开对应用户的数据库。
         */
        RCIM *rcim = [RCIM sharedRCIM];
        rcim.connectionStatusDelegate = self;
        [rcim connectWithToken:tokenStr
                       success:^(NSString *userId) {
            NSLog(@"%@",userId);
        }error:^(RCConnectErrorCode status) {
            NSLog(@"");
        }tokenIncorrect:^{
            NSLog(@"");
        }];
    }else{
        
    }
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].isMediaSelectorContainVideo = YES;
    
    // 以下根据自己项目需求.进行配置
//    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;    //  开启用户信息和群组信息的持久化
//    [RCIM sharedRCIM].userInfoDataSource = [RCDRCIMDataSource shareInstance];     //  设置RongCloud用户信息数据源
//    [RCIM sharedRCIM].groupInfoDataSource = [RCDRCIMDataSource shareInstance];    //  设置RongCloud群组信息数据源
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;      //  是否在发送的所有消息中携带当前登录的用户信息
//    [RCIM sharedRCIM].receiveMessageDelegate = self;          //  设置接收消息代理
    [RCIM sharedRCIM].enableTypingStatus =YES;                //  开启输入状态监听
    [RCIM sharedRCIM].showUnkownMessage = YES;                //  设置显示未注册的消息
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;    //  未注册的消息类型是否显示本地通知
    [RCIM sharedRCIM].disableMessageAlertSound = YES;         //  声音提示
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];     //  设置会话列表头像和会话界面头像
//    [[RCIM sharedRCIM] registerMessageType:[RRTCustomFriendMessage class]];   //  注册自定义消息类型
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(50, 50);    //  会话列表界面中显示的头像大小
    //必须转一遍否则甭
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%@",modelLogin.userId]
                                                                      name:[NSString stringWithFormat:@"%@",modelLogin.userName]
                                                                  portrait:@"http://img.296320.com/xms.jpg"];
//    [RCIM sharedRCIM].userInfoDataSource = RCDataSource.s;
//    [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
//    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
//    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
}
#pragma mark —— RCIMConnectionStatusDelegate
/*!
 IMKit连接状态的的监听器
 @param status  SDK与融云服务器的连接状态
 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
     NSLog(@"");
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
    
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//        if ([modelLogin.userId isEqualToString:userId]) {
//            NSLog(@"%@",modelLogin.userId);
//        }
//    }
    
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    NSLog(@"KKK%@",modelLogin.userId);
//    NSLog(@"KKK %@",userId);
    if ([userId isEqualToString:modelLogin.platform_id.stringValue]) {

         return completion([[RCUserInfo alloc] initWithUserId:userId
                                                         name:@"小喵客服"
                                                     portrait:@"http://img.296320.com/xms.jpg"]);
     }else{
//         根据存储联系人信息的模型，通过 userId 来取得对应的name和头像url，进行以下设置（此处因为项目接口尚未实现，所以就只能这样给大家说说，请见谅）

         //别人的
         return completion([[RCUserInfo alloc] initWithUserId:userId
                                                         name:@"name"
                                                     portrait:@"http://img.296320.com/xms.jpg"]);
     }

}

@end

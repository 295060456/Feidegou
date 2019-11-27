//
//  AppDelegate+JPUSH.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate+JPUSH.h"

@implementation AppDelegate (JPUSH)

- (void)registPushapplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initAPNs];
    [self initJPush:launchOptions];
}
//初始化 APNs
-(void)initAPNs{
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|
        JPAuthorizationOptionBadge|
        JPAuthorizationOptionSound|
        JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}
//初始化 JPush
-(void)initJPush:(NSDictionary *)launchOptions{
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions//详见关于 IDFA
                           appKey:JPush_Key
                          channel:@""//指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
                 apsForProduction:YES//1.3.1 版本新增，用于标识当前应用所使用的 APNs 证书环境;0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。注：此字段的值要与 Build Settings的Code Signing 配置的证书环境一致。
            advertisingIdentifier:advertisingId];
}

-(void)registerDeviceToken:(NSData *)deviceToken{
//    温馨提示：
//    JPush 3.0.9 之前的版本，必须调用此接口，注册 token 之后才可以登录极光，使用通知和自定义消息功能。
//    从 JPush 3.0.9 版本开始，不调用此方法也可以登录极光。但是不能使用 APNs 通知功能，只可以使用 JPush 自定义消息。
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)handleRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
}
#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
    openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    } else {
        // Fallback on earlier versions
    }
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
  completionHandler();  // 系统要求执行这个方法
}



@end

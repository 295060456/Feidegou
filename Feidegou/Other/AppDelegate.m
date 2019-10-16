//
//  AppDelegate.m
//  ZhouShi
//
//  Created by 谭自强 on 2017/11/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JJHttpClient+FourZero.h"
#import "JJHttpClient+Login.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "SDWebImageManager.h"
#import "JJDBHelper+Advertise.h"
#import "AdvertiseStartController.h"
#import "MainNavigationController.h"
#import "GoodDetialAllController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "LocationManager.h"
BMKMapManager* _mapManager;

@interface AppDelegate ()
<
WXApiDelegate,
BMKGeneralDelegate,
JPUSHRegisterDelegate
>

@end

@implementation AppDelegate

static NSInteger seq = 0;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"LLdCD1urvynTBvcw9rlekbCgfBTyQhej" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //    初始化导航
    
    /*===================================*/
    //设置HUD样式
    [SVProgressHUD setMaximumDismissTimeInterval:1.0f];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //    注册推送
    [self registPushapplication:application didFinishLaunchingWithOptions:launchOptions];
//    分享
    
    [self shareWeixin];
    [self loginAgin];
    
    [self requestAdverMain];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Navigation" bundle:nil];
//    self.window.rootViewController = [storyboard instantiateInitialViewController];
    // Override point for customization after application launch.
    return YES;
}

- (void)loginAgin{
    if (![[PersonalInfo sharedInstance] isLogined]) {
        return;
    }
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    
    self.disposableLogin = [[[JJHttpClient new] requestLoginUSERNAME:modelLogin.userName
                                                         andPASSWORD:modelLogin.password andIsChangedPsw:YES]
                            subscribeNext:^(ModelLogin*model) {
        
    }error:^(NSError *error) {
        self.disposableLogin = nil;
    }completed:^{
        self.disposableLogin = nil;
    }];
}


- (void)requestAdverMain{
    NSArray *arrImage = [[JJDBHelper sharedInstance] fetchCacheForAdvertisementStart];
    if (arrImage.count>0) {
        NSString *strPath = arrImage[0][@"photo_url"];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strPath];
        if (image == nil) {
            [self setEntryByIsLogined];
            [self downloadImage:strPath];
        }else{
            //            显示广告照片
            
            [self downloadImage:strPath];
            
            CATransition *transition = [CATransition animation];
            
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            transition.duration = 1.5f;
            transition.type = @"rippleEffect";
            [self.window.layer addAnimation:transition forKey:nil];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdvertiseStart" bundle:nil];
            AdvertiseStartController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AdvertiseStartController"];
            controller.image = image;
            controller.strUrl = arrImage[0][@"ad_url"];
            self.window.rootViewController = controller;
            
        }
    }else{
        [self setEntryByIsLogined];
    }
    
    self.disposableAdver = [[[JJHttpClient new] requestAdverStart] subscribeNext:^(NSArray* array) {
        if (array.count>0) {
            [self downloadImage:array[0][@"photo_url"]];
        }
        
    }error:^(NSError *error) {
        self.disposableAdver = nil;
    }completed:^{
        self.disposableAdver = nil;
    }];
}
- (void)downloadImage:(NSString *)strImage{
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strImage]] options:<#(SDWebImageDownloaderOptions)#> progress:<#^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL)progressBlock#> completed:<#^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished)completedBlock#>]
//    [[SDWebImageManager sharedManager] initWithCache:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strImage] downloader:[[SDWebImageDownloader sharedDownloader]]
//
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:strImage] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize){
//
//    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
//    }];
}

- (void)setEntryByIsLogined{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CydiaIphone" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }else{
        CATransition *transition = [CATransition animation];
        
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        transition.duration = 1.5f;
        transition.type = @"rippleEffect";
        [self.window.layer addAnimation:transition forKey:nil];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Navigation" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }
}

- (void)setEntryByUrl:(NSString *)strUrl{
    [self setEntryByIsLogined];
    if (![NSString isNullString:strUrl]) {
        MainNavigationController *navigationController = (MainNavigationController *)[[(UITabBarController *)self.window.rootViewController viewControllers] objectAtIndex:0];
        if ([NSString isPositiveInteger:strUrl]) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
            controller.strGood_id = strUrl;
            [navigationController pushViewController:controller animated:YES];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
            WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
            controller.strWebUrl = strUrl;
            
            [navigationController pushViewController:controller animated:YES];
        }
    }
}
- (void)shareWeixin{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
        [platformsRegister setupWeChatWithAppId:@"wx7d314006a5998a80" appSecret:@"36f4c00f85dfeef68df209402ff9c726"];
        
    }];
//    [ShareSDK registerActivePlatforms:@[
//                                        @(SSDKPlatformTypeWechat)                                        ]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx7d314006a5998a80"
//                                       appSecret:@"ab2c06d73b7f8a63be70046d8dc0b6d8"];
//                 break;
//             default:
//                 break;
//         }
//     }];
}
- (void)registPushapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"75ad5f0de573d5434d348006"
                          channel:@"iphone"
                 apsForProduction:YES
            advertisingIdentifier:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//推送的信息
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    [self getAlias];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (NSInteger)seq {
    return ++ seq;
}
- (void)getAlias{
    //    获取别名，如果别名和当前登录的id不一样，则重新设置别名
    if ([[PersonalInfo sharedInstance] isLogined]){
        [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSString *strUerId = TransformString([[PersonalInfo sharedInstance] fetchLoginUserInfo].userId);
            D_NSLog(@"setAlias code:%ld iAlias:%@ seq:%ld", iResCode, iAlias, seq);
            if (![TransformString(iAlias) isEqualToString:strUerId]) {
                [self setAlias];
            }
        } seq:[self seq]];
    }
}
- (void)setAlias{
    if ([[PersonalInfo sharedInstance] isLogined]) {
        NSString *strUerId = TransformString([[PersonalInfo sharedInstance] fetchLoginUserInfo].userId);
        [JPUSHService setAlias:strUerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            D_NSLog(@"setAlias code:%ld iAlias:%@ seq:%ld", iResCode, iAlias, seq);
        } seq:[self seq]];
    }
}
- (void)shareSucceed{
    self.disposableShareSucceed = [[[JJHttpClient new] requestFourZeroShare] subscribeNext:^(NSDictionary* dictionray) {
        D_NSLog(@"分享成功 %@",dictionray[@"msg"]);
    }error:^(NSError *error) {
        self.disposableShareSucceed = nil;
    }completed:^{
        self.disposableShareSucceed = nil;
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark --  支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL isWXApi = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[WXApi class]];
    if (isWXApi) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            D_NSLog(@"alipay balance reslut = %@，mome is %@",resultDic,resultDic[@"momo"]);
            int intStatus = [resultDic[@"resultStatus"] intValue];
            if (intStatus==9000) {
                //                [SVProgressHUD showErrorWithStatus:@"订单支付成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }else if (intStatus == 8000){
                [SVProgressHUD showErrorWithStatus:@"订单正在处理中"];
            }else if (intStatus == 4000){
                [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
            }else if (intStatus == 6001){
                [SVProgressHUD showErrorWithStatus:@"取消支付"];
            }else if (intStatus == 6002){
                [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
            }
        }];
    }
    NSString *strUrl = TransformString(url.absoluteString);
    if ([strUrl ContainsString:@"pay"]){
        BOOL isWXApi = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[WXApi class]];
        if (isWXApi) {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            D_NSLog(@"alipay balance reslut = %@，mome is %@",resultDic,resultDic[@"momo"]);
            int intStatus = [resultDic[@"resultStatus"] intValue];
            if (intStatus==9000) {
                //                [SVProgressHUD showErrorWithStatus:@"订单支付成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }else if (intStatus == 8000){
                [SVProgressHUD showErrorWithStatus:@"订单正在处理中"];
            }else if (intStatus == 4000){
                [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
            }else if (intStatus == 6001){
                [SVProgressHUD showErrorWithStatus:@"取消支付"];
            }else if (intStatus == 6002){
                [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
            }
        }];
    }
    NSString *strUrl = TransformString(url.absoluteString);
    if ([strUrl ContainsString:@"pay"]){
        BOOL isWXApi = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[WXApi class]];
        if (isWXApi) {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return YES;
}
- (void)ChangeStateForPay:(NSString *)strOrderId{
    self.disposablePaySucceed = [[[JJHttpClient new] requestFourZeroPayout_trade_no:TransformString(strOrderId)] subscribeNext:^(NSDictionary* dictionray) {
        D_NSLog(@"更新支付状态 msg is %@",dictionray[@"msg"]);
    }error:^(NSError *error) {
        self.disposablePaySucceed = nil;
    }completed:^{
        self.disposablePaySucceed = nil;
    }];
}


- (void)sendPay:(NSDictionary *)dict{
    
    if(dict != nil){
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //        NSString *stamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        D_NSLog(@"timeSp:%@",stamp); //时间戳的值
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        //日志输出
        D_NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}
-(void) onReq:(BaseReq*)req{
    
    D_NSLog(@"onReq is %@",req);
}
//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
- (void)onResp:(BaseResp *)resp
{
    D_NSLog(@"- (void)onResp:(BaseResp *)resp %@",resp);
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        D_NSLog(@"error is %@",response);
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"成功!";
                NSLog(@"支付结果: 成功!");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                strMsg = @"失败!";
                NSLog(@"支付结果: 失败!");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                
                strMsg = @"取消支付!";
                NSLog(@"取消支付!");
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                strMsg = @"发送失败!";
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                strMsg = @"微信不支持!";
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                strMsg = @"授权失败!";
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
        if (resp.errCode!=WXSuccess) {
            NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                            message:strMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


@end

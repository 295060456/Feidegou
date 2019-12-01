//
//  AppDelegate.m
//  ZhouShi
//
//  Created by 谭自强 on 2017/11/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RCIM.h"
#import "AppDelegate+BMKMap.h"
#import "AppDelegate+WeiXin.h"
#import "AppDelegate+JPUSH.h"
#import "AppDelegate+Alipay.h"
#import "AppDelegate+VM.h"

#import "JJHttpClient+FourZero.h"
#import "JJHttpClient+Login.h"
#import "JJDBHelper+Advertise.h"
#import "AdvertiseStartController.h"
#import "MainNavigationController.h"
#import "GoodDetialAllController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSInteger seq = 0;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置HUD样式
    [SVProgressHUD setMaximumDismissTimeInterval:1.0f];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    [self registPushapplication:application
  didFinishLaunchingWithOptions:launchOptions];// 注册推送
    [self shareWeixin];//微信分享
    [self BMKMap];//百度地图
    [self RCIM];//融云
    
    [self loginAgin];
    [self requestAdverMain];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {//退出到后台 1 如果双击home呈现小图 只走1 小图杀死只走1
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //在这里-1
}

- (void)applicationDidEnterBackground:(UIApplication *)application {//退出到后台2 杀死也走
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {//唤醒1
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
//推送的信息
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [self registerDeviceToken:deviceToken];//注册 APNs 成功并上报 DeviceToken
    [self getAlias];//
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {//首次进1
    //实现注册 APNs 失败接口（可选）
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [self handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemoteNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {//唤醒2 首次进2 点击小图进只走2
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //在这里+1
}

- (void)applicationWillTerminate:(UIApplication *)application { //杀死也走
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark --  支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL isWXApi = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[WXApi class]];
    if (isWXApi) {
        return [WXApi handleOpenURL:url delegate:self];
    }return YES;
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
    }return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options{
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
    }return YES;
}
#pragma mark —— 私有方法
- (void)loginAgin{
    if (![[PersonalInfo sharedInstance] isLogined]) {
        return;
    }
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    self.disposableLogin = [[[JJHttpClient new] requestLoginUSERNAME:modelLogin.userName
                                                         andPASSWORD:modelLogin.password
                                                     andIsChangedPsw:YES]
                            subscribeNext:^(ModelLogin*model) {
        
    }error:^(NSError *error) {
        self.disposableLogin = nil;
    }completed:^{
        self.disposableLogin = nil;
    }];
}

- (void)ChangeStateForPay:(NSString *)strOrderId{
    self.disposablePaySucceed = [[JJHttpClient.new requestFourZeroPayout_trade_no:TransformString(strOrderId)] subscribeNext:^(NSDictionary* dictionray){
        D_NSLog(@"更新支付状态 msg is %@",dictionray[@"msg"]);
    }error:^(NSError *error) {
        self.disposablePaySucceed = nil;
    }completed:^{
        self.disposablePaySucceed = nil;
    }];
}

- (void)requestAdverMain{
    NSArray *arrImage = [[JJDBHelper sharedInstance] fetchCacheForAdvertisementStart];
    if (arrImage.count > 0) {
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
        if (array.count > 0) {
            [self downloadImage:array[0][@"photo_url"]];
        }
    }error:^(NSError *error) {
        self.disposableAdver = nil;
    }completed:^{
        self.disposableAdver = nil;
    }];
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
//获取别名
- (void)getAlias{
    if ([[PersonalInfo sharedInstance] isLogined]){
        [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"已经登录");
            [self setAlias];
        } seq:[self seq]];
    }else{
        NSLog(@"还未登录");
        [self setAlias];
    }
}

- (void)setAlias{
    if ([[PersonalInfo sharedInstance] isLogined]) {
        NSString *strUerId = TransformString([[PersonalInfo sharedInstance] fetchLoginUserInfo].userId);
        strUerId = [strUerId stringByAppendingString:@"AA"];
        [JPUSHService setAlias:strUerId completion:^(NSInteger iResCode,
                                                     NSString *iAlias,
                                                     NSInteger seq) {
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

- (NSInteger)seq {
    return ++ seq;
}

- (void)sendPay:(NSDictionary *)dict{
    [self _sendPay:dict];
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



@end

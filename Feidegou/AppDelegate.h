//
//  AppDelegate.h
//  ZhouShi
//
//  Created by 谭自强 on 2017/11/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)RACSignal *reqSignal;
@property(nonatomic,strong)RACDisposable *disposableLogin;
@property(nonatomic,strong)RACDisposable *disposablePaySucceed;
@property(nonatomic,strong)RACDisposable *disposableShareSucceed;
@property(nonatomic,strong)RACDisposable *disposableAdver;
@property(nonatomic,weak)OrderDetailVC *orderDetailVC;

- (void)ChangeStateForPay:(NSString *)strOrderId;

//微信支付请求结果出来后调用此方法
- (void)sendPay:(NSDictionary *)dict;
- (void)setAlias;
- (void)shareSucceed;
- (void)setEntryByUrl:(NSString *)strUrl;

@end


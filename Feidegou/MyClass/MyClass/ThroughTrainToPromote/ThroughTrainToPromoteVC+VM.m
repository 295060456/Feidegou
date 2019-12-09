//
//  ThroughTrainToPromoteVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC+VM.h"

@implementation ThroughTrainToPromoteVC (VM)
//Catfoodbooth_rob_agoUrl 喵粮直通车机会查询 微信3 支付宝3 别人购买的机会 用完今天就不能开启直通车
-(void)check{//
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic = @{
        @"order_type":[NSNumber numberWithInt:1]
    };
    
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfoodbooth_rob_agoUrl
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            Toast(dic[@"message"]);
            if (b.intValue == 200) {
                [self checkThroughTrainToPromoteStyle_netWorking];//查看直通车状态 进来查看直通车看开启与否 开启。。。 继续关闭。
            }else{
                NSLog(@"微信3 支付宝3 别人购买的机会 用完今天就不能开启直通车");
            }
        }
    }];
}
//查看直通车状态
-(void)checkThroughTrainToPromoteStyle_netWorking{//进来查看直通车看开启与否 开启。。。 继续关闭。
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{

    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrain_checkURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    @weakify(self)
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        NSLog(@"1 —— %@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            if (b.intValue == 200) {
                //已经开启直通车 data为字典
                //尚未开通直通车 data为回显数
//                默认开启  0    暂停 1
                if([dic[@"data"] isKindOfClass:[NSDictionary class]]){//已经开通直通车
                    NSNumber *f = (NSNumber *)dic[@"data"][@"train"];
                    self.quantity = f.stringValue;
                    NSNumber *d = (NSNumber *)dic[@"data"][@"train_stop"];
                    
                    if (d.intValue) {//暂停 暂停 1 开启  0
                        self.openBtn.alpha = 0;
                        self.goOnBtn.alpha = 0;
                        self.cancelBtn.alpha = 0;
                        self.suspendBtn.alpha = 1;
                        self.suspendBtn.selected = YES;
                        self.suspendBtn.backgroundColor = kRedColor;
                        [self.suspendBtn setTitle:@"开启直通车出售"
                                         forState:UIControlStateNormal];
                    }else{//开启
                        self.goOnBtn.alpha = 1;
                        self.cancelBtn.alpha = 1;
                        self.suspendBtn.alpha = 1;
                        self.suspendBtn.selected = NO;
                        self.suspendBtn.backgroundColor = KLightGrayColor;
                        [self.suspendBtn setTitle:@"暂停直通车出售"
                                         forState:UIControlStateNormal];
                        self.openBtn.alpha = 0;
                    }
                }else if ([dic[@"data"] isKindOfClass:[NSNumber class]]){//尚未开通直通车
//                    NSNumber *f = (NSNumber *)dic[@"data"];
                    self.openBtn.alpha = 1;
                }else{}
            }
        }
        
//        n *openBtn;
//        @property(nonatomic,strong)UIButton *cancelBtn;
//        @property(nonatomic,strong)UIButton *goOnBtn;
//        @property(nonatomic,strong)UIButton *suspendBtn;

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}
//开启直通车 CatfoodTrainURL
-(void)CatfoodTrainURL_networking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    @weakify(self)
    NSDictionary *dataDic = @{
        @"quantity":self.quantity,
        @"login_ip":[GettingDeviceIP getNetworkIPAddress]//ip 是否在这里加？
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrainURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            Toast(dic[@"message"]);
            //        默认开启  0    暂停 1
            if (b.intValue == 200) {
                [ThroughTrainListVC ComingFromVC:self_weak_
                                       withStyle:ComingStyle_PUSH
                                   requestParams:self.quantity
                                         success:^(id data) {}
                                        animated:YES];
            }else if (b.intValue == 500){
                self.suspendBtn.alpha = 1;
                self.suspendBtn.selected = YES;
                [self.suspendBtn setTitle:@"开启直通车售卖" forState:UIControlStateNormal];
                self.suspendBtn.backgroundColor = kRedColor;
                self.openBtn.alpha = 0;
                self.cancelBtn.alpha = 0;
                self.goOnBtn.alpha = 0;
            }else{}
        }
    }];
}
//暂停/继续 直通车 CatfoodTrain_stopURL
-(void)CatfoodTrain_stopURL_networking{
    NSLog(@"KKK - %d",self.suspendBtn.selected);
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    @weakify(self)
    NSDictionary *dataDic = @{
//        @"train_stop":[NSNumber numberWithBool:self.suspendBtn.selected],
//        默认开启  0    暂停 1
        @"train_stop":[NSNumber numberWithInt:!self.suspendBtn.selected],//用numberWithBool 服务器只会收到0 这是怎么回事？
    };
    NSLog(@"%@",dataDic);
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrain_stopURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        NSLog(@"3 —— %@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            self.train_stop = !self.train_stop;
            self.suspendBtn.selected = !self.suspendBtn.selected;
            if (b.intValue == 200) {
                self.openBtn.alpha = 0;
                if (self.suspendBtn.selected) {
                    self.cancelBtn.alpha = 0;
                    self.goOnBtn.alpha = 0;
                    [self.suspendBtn setTitle:@"开启直通车售卖" forState:UIControlStateNormal];
                    self.suspendBtn.backgroundColor = kRedColor;
                }else{
                    self.cancelBtn.alpha = 1;
                    self.goOnBtn.alpha = 1;
                    [self.suspendBtn setTitle:@"暂停直通车售卖" forState:UIControlStateNormal];
                    self.suspendBtn.backgroundColor = KLightGrayColor;
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    Toast(dic[@"message"]);
                }];
            }
        }
    }];
}

-(void)rank{//继续上一次直通车
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"user_id":modelLogin.userId,
    };
    
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrain_ranking
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            if (b.intValue == 200) {
                [ThroughTrainListVC ComingFromVC:self_weak_
                                       withStyle:ComingStyle_PUSH
                                   requestParams:nil
                                         success:^(id data) {}
                                        animated:YES];
            }
        }
    }];
}
//关闭直通车
-(void)deleteThroughTrainToPromote_netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrain_delURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (!response) {
            NSLog(@"--%@",response);
            Toast(@"取消成功");
        }
    }];
}

@end


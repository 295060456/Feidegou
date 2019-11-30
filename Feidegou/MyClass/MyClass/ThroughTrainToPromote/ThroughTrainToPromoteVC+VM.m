//
//  ThroughTrainToPromoteVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC+VM.h"

@implementation ThroughTrainToPromoteVC (VM)
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
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSNumber class]]) {
                NSNumber *d = (NSNumber *)response;
                if ([d intValue] == 0) {//没开通直通车
                    self.openBtn.alpha = 1;
                }else{//已经开通直通车
                    self.cancelBtn.alpha = 1;
                    self.goOnBtn.alpha = 1;
                }
            }
            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
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
        if ([response isKindOfClass:[NSString class]]) {
            NSLog(@"");
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
                [self CatfoodTrainURL_networking];//查看机会成功，正式开启直通车
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
//开启直通车 CatfoodTrainURL
-(void)CatfoodTrainURL_networking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    @weakify(self)
    NSDictionary *dataDic = @{
        @"quantity":self.quantity
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
        if (!response) {
            NSLog(@"--%@",response);
            Toast(@"开通直通车成功");
            [ThroughTrainListVC ComingFromVC:self_weak_
                                   withStyle:ComingStyle_PUSH
                               requestParams:nil
                                     success:^(id data) {}
                                    animated:YES];
        }
    }];
}

@end

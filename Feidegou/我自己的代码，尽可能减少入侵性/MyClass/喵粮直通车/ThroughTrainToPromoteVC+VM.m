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
-(void)checkThroughTrainToPromoteStyle_netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{

    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrain_checkURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
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
//关闭直通车
-(void)deleteThroughTrainToPromote_netWorking{
        extern NSString *randomStr;
        NSDictionary *dataDic = @{
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodTrain_delURL
                                                         parameters:@{
                                                             @"data":dataDic,//内部加密
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (!response) {
                NSLog(@"--%@",response);
                Toast(@"取消成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
}


@end

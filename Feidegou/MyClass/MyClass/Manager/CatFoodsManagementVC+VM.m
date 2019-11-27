//
//  CatFoodsManagementVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC+VM.h"

NSString *randomStr;
NSString *market_price_booth;//摊位均价
NSString *weixin_qr_img;//微信收款二维码
NSString *Foodstuff;
NSString *market_price_sale;//批发均价
NSString *market_price_co;//产地均价
NSString *Foodsell;
NSString *tokenStr;

@implementation CatFoodsManagementVC (VM)

-(void)networking{
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    tokenStr = modelLogin.token;
    NSDictionary *dataDic = @{
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodManageURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) { 
        if (response) {
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"market_price_booth"]]
                                                              ReplaceStr:@"无"]];// 摊位均价
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"weixin_qr_img"]]
                                                              ReplaceStr:@"无"]];// 微信收款二维码
                [self.dataMutArr addObject:[[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodstuff"]]
                ReplaceStr:@"无"] stringByAppendingString:@" g"]];//余额
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"market_price_sale"]]
                                                              ReplaceStr:@"无"]];//批发均价
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"market_price_co"]]
                                                              ReplaceStr:@"无"]];// 产地均价
                [self.dataMutArr addObject:[[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodsell"]]
                ReplaceStr:@"无"] stringByAppendingString:@" g"]];//出售中
                market_price_booth = self.dataMutArr[0];
                weixin_qr_img = self.dataMutArr[1];
                Foodstuff = self.dataMutArr[2];
                market_price_sale = self.dataMutArr[3];
                market_price_co = self.dataMutArr[4];
                Foodsell = self.dataMutArr[5];
                
                if ([weixin_qr_img intValue] == -1) {
                    [self showAlertViewTitle:@"请重新上传收款二维码"
                                     message:@"现在去上传？"
                                 btnTitleArr:@[@"稍后再说",@"好的"]
                              alertBtnAction:@[@"Later",@"OK"]];
                }
                
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }else{
                if (response.code == 300) {//被挤下线逻辑
#warning KKK
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
//                    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}

//Catfoodbooth_rob_agoUrl 喵粮抢摊位机会查询
-(void)check{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"order_type":[NSNumber numberWithInt:1]
    };
    
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfoodbooth_rob_agoUrl
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
//                [StallListVC pushFromVC:self_weak_
//                          requestParams:Nil
//                                success:^(id data) {}
//                               animated:YES];
                
                [ThroughTrainToPromoteVC ComingFromVC:self_weak_
                                            withStyle:ComingStyle_PUSH
                                        requestParams:nil
                                              success:^(id data) {}
                                             animated:YES];
            }
        }
    }];
}


@end

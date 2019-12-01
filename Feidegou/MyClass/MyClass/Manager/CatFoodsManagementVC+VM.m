//
//  CatFoodsManagementVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC+VM.h"

NSString *tokenStr;//??没有了
NSString *alipay_qr_img;//支付宝收款二维码
NSString *market_price_booth;//摊位均价
NSString *weixin_qr_img;//微信收款二维码
NSString *wait_goods;//待处理订单的数量
NSString *market_price_sale;//批发均价
NSString *Foodsell;
NSString *Foodstuff;
NSString *market_price_co;//产地均价

@implementation CatFoodsManagementVC (VM)

-(void)networking{
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    tokenStr = modelLogin.token;
    NSDictionary *dataDic = @{
    };
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodManageURL
                                                     parameters:@{
                                                         @"data":dataDic,//内部加密
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"alipay_qr_img"]]
                                                              ReplaceStr:@"无"]];//支付宝
                market_price_booth = self.dataMutArr[0];
                weixin_qr_img = self.dataMutArr[1];
                Foodstuff = self.dataMutArr[2];
                market_price_sale = self.dataMutArr[3];
                market_price_co = self.dataMutArr[4];
                Foodsell = self.dataMutArr[5];
                alipay_qr_img = self.dataMutArr[6];
                
                if ([weixin_qr_img intValue] == -1) {//微信是必须的 微信不OK 管他支付宝OK不OK，先解决微信
                    [self showAlertViewTitle:@"请重新上传微信收款二维码"
                                     message:@"现在去上传？"
                                 btnTitleArr:@[@"稍后再说",@"好的"]
                              alertBtnAction:@[@"Later",@"OK"]];
                }else{//在微信OK的基础上，支付宝账号不OK
                    if ([alipay_qr_img intValue] == -1) {
                        [self showAlertViewTitle:@"请重新上传支付宝收款二维码"
                                         message:@"现在去上传？"
                                     btnTitleArr:@[@"稍后再说"]
                                  alertBtnAction:@[@"Later"]];
                    }
                }
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }else{
#warning KKK
//                if (response.code == 300) {//被挤下线逻辑
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
//                    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
            }
        }
    }];
}




@end

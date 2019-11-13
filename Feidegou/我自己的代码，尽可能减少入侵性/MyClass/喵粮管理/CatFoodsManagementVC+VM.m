//
//  CatFoodsManagementVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC+VM.h"

NSString *randomStr;

@implementation CatFoodsManagementVC (VM)

-(void)networking{
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
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodsell"]] ReplaceStr:@"无"]];
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"Foodstuff"]] ReplaceStr:@"无"]];
                [self.dataMutArr addObject:[NSString ensureNonnullString:[NSString stringWithFormat:@"%@",dic[@"market_price"]] ReplaceStr:@"无"]];
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }else{
                if (response.code == 300) {//被挤下线逻辑
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
                    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}

@end

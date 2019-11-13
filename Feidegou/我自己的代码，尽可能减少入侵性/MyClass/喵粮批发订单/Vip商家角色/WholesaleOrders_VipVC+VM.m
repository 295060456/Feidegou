//
//  WholesaleOrders_VipVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/12.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC+VM.h"

@implementation WholesaleOrders_VipVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.requestParams[0]
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_checkURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response) {
            NSLog(@"--%@",response);
            self.wholesaleOrders_VipModel = [WholesaleOrders_VipModel mj_objectWithKeyValues:response];
            [self.detailTextMutArr addObject:[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.ID ReplaceStr:@"无"]];//订单号
            [self.detailTextMutArr addObject:[[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.quantity ReplaceStr:@"无"] stringByAppendingString:@" g"]];//数量
            [self.detailTextMutArr addObject:[[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//单价
            [self.detailTextMutArr addObject:[[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.rental ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//总额
            switch ([self.wholesaleOrders_VipModel.catFoodOrder.payment_status intValue]) {//支付方式 & 付款账户
                case 1:{
                    [self.detailTextMutArr addObject:@"支付宝"];
                    [self.detailTextMutArr addObject:[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.payment_alipay ReplaceStr:@"暂无"]];
                }break;
                case 2:{
                    [self.detailTextMutArr addObject:@"微信"];
                    [self.detailTextMutArr addObject:[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.payment_weixin ReplaceStr:@"暂无"]];
                }break;
                case 3:{
                    [self.detailTextMutArr addObject:@"银行卡"];
                    [self.detailTextMutArr addObject:[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.bankcard ReplaceStr:@"暂无"]];
                }break;
                default:
                    [self.detailTextMutArr addObject:@"异常数据"];
                    [self.detailTextMutArr addObject:[NSString ensureNonnullString:self.wholesaleOrders_VipModel.catFoodOrder.bankcard ReplaceStr:@"异常数据"]];
                    break;
            }
            
            if ([self.requestParams[1] intValue] == 3) {
                [self.detailTextMutArr addObject:@"点击选择凭证(原图)"];//凭证 self.wholesaleOrders_VipModel.catFoodOrder.payment_print
            }
            switch ([self.wholesaleOrders_VipModel.catFoodOrder.order_status intValue]) {//状态
                case 0:{
                    [self.detailTextMutArr addObject:@"已支付"];
                } break;
                case 1:{
                    [self.detailTextMutArr addObject:@"已发单"];
                } break;
                case 2:{
                    [self.detailTextMutArr addObject:@"已接单"];
                } break;
                case 3:{
                    [self.detailTextMutArr addObject:@"已作废"];
                } break;
                case 4:{
                    [self.detailTextMutArr addObject:@"已发货"];
                } break;
                case 5:{
                    [self.detailTextMutArr addObject:@"已完成"];
                } break;
                default:
                    [self.detailTextMutArr addObject:@"异常数据"];
                    break;
            }
            Toast(@"拉取到数据");
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

-(void)deliver_Networking{
    
}

@end



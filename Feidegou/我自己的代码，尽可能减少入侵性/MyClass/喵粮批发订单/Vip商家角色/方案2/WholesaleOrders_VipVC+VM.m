//
//  WholesaleOrders_VipVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/12.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC+VM.h"

@implementation WholesaleOrders_VipVC (VM)
//拉取数据
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
            if ([self.requestParams[1] intValue] == 0) {
                if (![NSString isNullString:self.wholesaleOrders_VipModel.payment_print]) {
                    [self.detailTextMutArr addObject:self.wholesaleOrders_VipModel.payment_print];//凭证
                }
            }
            switch ([self.wholesaleOrders_VipModel.catFoodOrder.order_status intValue]) {//状态
                case 0:{
                    [self.detailTextMutArr addObject:@"已支付"];
                } break;
                case 1:{
                    [self.detailTextMutArr addObject:@"已发单"];
                } break;
                case 2:{
                    [self.detailTextMutArr addObject:@"已下单"];
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
            [self.deliverBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                                    (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                                    [WholesaleOrdersTBVCell cellHeightWithModel:self.detailTextMutArr[6]] +
                                                    SCALING_RATIO(30));//附加值
                 make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - SCALING_RATIO(100)) / 2,
                                                  SCALING_RATIO(50)));
                 make.right.equalTo(self.view).offset(SCALING_RATIO(-30));
            }];
            
            [self.cancelOrderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                                   (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                                   [WholesaleOrdersTBVCell cellHeightWithModel:self.detailTextMutArr[6]] +
                                                   SCALING_RATIO(30));//附加值
                make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - SCALING_RATIO(100)) / 2,
                                                 SCALING_RATIO(50)));
                make.left.equalTo(self.view).offset(SCALING_RATIO(30));
            }];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
//发货
-(void)deliver_Networking{
    extern NSString *randomStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSNumber *order_ID = (NSNumber *)self.requestParams[0];
        order_IDStr = [order_ID stringValue];
    }
    NSDictionary *dataDic = @{
        @"order_id":order_IDStr,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_goodsURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        NSLog(@"%@",response);
//        if ([response isKindOfClass:[NSString class]]) {
//            NSString *str = (NSString *)response;
//            if ([NSString isNullString:str]) {
////                @strongify(self)
//                NSLog(@"--%@",response);
//                Toast(@"取消成功");
//            }
//        }
    }];
}
//取消订单
-(void)cancelOrder_netWorking{
    extern NSString *randomStr;
    NSString *text;
    NSString *paymentWayStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;//订单ID、order_status
        text = arr[0];
        NSNumber *paymentWay = (NSNumber *)arr[1];
        paymentWayStr = [paymentWay stringValue] ;
        NSNumber *order_ID = (NSNumber *)arr[2];
        order_IDStr = [order_ID stringValue];
    }
    NSDictionary *dataDic = @{
        @"order_id":order_IDStr,//订单id
        @"reason":@""//撤销理由 现在不要了
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_pay_delURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
//                @strongify(self)
                NSLog(@"--%@",response);
                Toast(@"取消成功");
            }
        }
    }];
}
//上传支付凭证
-(void)uploadPrint_netWorking:(UIImage *)pic{//真正开始购买
//    extern NSString *randomStr;
//    NSString *order_IDStr;
//    if ([self.requestParams isKindOfClass:[NSArray class]]) {
//        NSArray *arr = (NSArray *)self.requestParams;//购买的数量、付款的方式、订单ID
//        NSNumber *order_ID = (NSNumber *)arr[2];
//        order_IDStr = [order_ID stringValue];
//    }
//    ModelLogin *modelLogin;
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
//    }
//    NSDictionary *dataDic = @{
//        @"order_id":order_IDStr,
//        @"user_id":modelLogin.userId,
//        @"identity":[YDDevice getUQID]
//    };
//    __block NSData *picData = [UIImage imageZipToData:pic];
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [mgr POST:API(BaseUrl2, CatfoodSale_payURL)
//   parameters:@{
//       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
//       @"key":[RSAUtil encryptString:randomStr
//                           publicKey:RSA_Public_key]
//   }
//constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:picData
//                                    name:@"payment_print"
//                                fileName:@"test.png"
//                                mimeType:@"image/png"];
//    }
//     progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"uploadProgress = %@",uploadProgress);
//    }
//      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dataDic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
//        Toast(dataDic[@"message"]);
//        switch ([dataDic[@"code"] longValue]) {
//            case 200:{//已完成付款.请等待审核后发货！
//                [self.paidBtn setTitle:@"已付款"
//                              forState:UIControlStateNormal];
//            }break;
//            case 300:{//订单状态异常，请检查！
//
//            }break;
//            case 500:{//订单有误，请检查订单！
//
//            }break;
//            default:
//                break;
//        }
//    }
//      failure:^(NSURLSessionDataTask * _Nullable task,
//                NSError * _Nonnull error) {
//        NSLog(@"error = %@",error);
//    }];
}

@end



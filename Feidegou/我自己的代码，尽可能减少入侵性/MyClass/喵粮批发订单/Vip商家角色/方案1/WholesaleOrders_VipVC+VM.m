//
//  WholesaleOrders_VipVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC+VM.h"

@implementation WholesaleOrders_VipVC (VM)

-(void)netWorking{//展示数据
    extern NSString *randomStr;
    NSString *text;
    NSString *paymentWayStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;//购买的数量、付款的方式、订单ID
        text = arr[0];
        NSNumber *paymentWay = (NSNumber *)arr[1];
        paymentWayStr = [paymentWay stringValue] ;
        NSNumber *order_ID = (NSNumber *)arr[2];
        order_IDStr = [order_ID stringValue];
    }

    NSDictionary *dataDic = @{
        @"order_id":order_IDStr,//批发id
        @"quantity":text,//数量
        @"payment_status": paymentWayStr//支付类型 ：1、支付宝;2、微信;3、银行卡
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_BuyeroneURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                self.model = [WholesaleOrders_AdvanceModel mj_objectWithKeyValues:dic[@"catFoodOrder"]];
                
                [self.dataArr addObject:@"喵粮"];//商品
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.quantity ReplaceStr:@"暂无信息"]];//数量
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.price ReplaceStr:@"暂无信息"]];//单价
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.rental ReplaceStr:@"暂无信息"]];//总额
                
                switch ([self.model.payment_status intValue]) {//支付类型:1、支付宝;2、微信;3、银行卡
                    case 1:{
                        [self.dataArr addObject:@"支付宝"];
                    }break;
                    case 2:{
                        [self.dataArr addObject:@"微信"];
                    }break;
                    case 3:{
                        [self.dataArr addObject:@"银行卡"];
                    }break;
                    default:
                        [self.dataArr addObject:@"支付方式异常"];
                        break;
                }
                switch ([self.model.order_status intValue]) {//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成
                    case 0:{
                        [self.dataArr addObject:@"已支付"];
                    }break;
                    case 1:{
                         [self.dataArr addObject:@"已发单"];
                    }break;
                    case 2:{
                        [self.dataArr addObject:@"已接单"];
                    }break;
                    case 3:{
                        [self.dataArr addObject:@"已作废"];
                    }break;
                    case 4:{
                        [self.dataArr addObject:@"已发货"];
                    }break;
                    case 5:{
                        [self.dataArr addObject:@"已完成"];
                    }break;
                    default:
                        [self.dataArr addObject:@"订单状态异常"];
                        break;
                }
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    }];
}

-(void)upLoadPic_netWorking:(UIImage *)pic{//真正开始购买
    extern NSString *randomStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;//购买的数量、付款的方式、订单ID
        NSNumber *order_ID = (NSNumber *)arr[2];
        order_IDStr = [order_ID stringValue];
    }
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":order_IDStr,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:pic];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:API(BaseUrl2, CatfoodSale_payURL)
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key]
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"payment_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        Toast(@"上传图片中...");
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
        Toast(dataDic[@"message"]);
        switch ([dataDic[@"code"] longValue]) {
            case 200:{//已完成付款.请等待审核后发货！
                [self.paidBtn setTitle:@"已付款"
                              forState:UIControlStateNormal];
            }break;
            case 300:{//订单状态异常，请检查！
                
            }break;
            case 500:{//订单有误，请检查订单！
                
            }break;
            default:
                break;
        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        Toast(@"上传图片失败");
    }];
}

-(void)cancelOrder_netWorking{//展示数据
    extern NSString *randomStr;
    NSString *text;
    NSString *paymentWayStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;//购买的数量、付款的方式、订单ID
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


@end

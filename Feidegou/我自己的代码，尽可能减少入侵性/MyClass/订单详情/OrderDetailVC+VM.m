//
//  OrderDetailVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC+VM.h"

@implementation OrderDetailVC (VM)
//CatfoodRecord_delURL 喵粮订单撤销 #5
-(void)CancelDelivery_NetWorking{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    extern NSString *randomStr;
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"],//订单id
//         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:self.orderListModel.order_type ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
         @"user_id":modelLogin.userId,
         @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:self.pic];
    [mgr POST:API(BaseUrl2, CatfoodRecord_delURL)
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key]
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"del_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        Toast(@"上传图片中...");
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        Toast(@"上传图片成功");
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        Toast(@"上传图片失败");
    }];
}
//CatfoodCO_BuyerURL 喵粮产地购买 #7
-(void)netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID//order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCO_BuyerURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSDictionary class]]) {
            OrderDetailModel *orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:response];
            NSString *str1 = [NSString ensureNonnullString:orderDetailModel.ID ReplaceStr:@"无"];
            NSString *str2 = [NSString ensureNonnullString:orderDetailModel.quantity ReplaceStr:@""];
//            [self.dataMutArr addObject:[NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2]];
    
            self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
            
            [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.ID ReplaceStr:@"无"]];//订单号
            [self.dataMutArr addObject:[[NSString ensureNonnullString:orderDetailModel.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//单价
            [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.quantity ReplaceStr:@"无"]];//数量
            [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.rental ReplaceStr:@"无"]];//总额
            switch ([self.orderListModel.payment_status intValue]) {//支付方式: 1、支付宝;2、微信;3、银行卡
                case 1:{
                    [self.dataMutArr addObject:@"支付宝"];
                }break;
                case 2:{
                    [self.dataMutArr addObject:@"微信"];
                }break;
                case 3:{
                 [self.dataMutArr addObject:@"银行卡"];
                }break;
                default:
                    break;
            }
            //1、支付宝;2、微信;3、银行卡
            if ([self.orderListModel.payment_status intValue] == 3) {//银行卡
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.bankCard ReplaceStr:@"暂无信息"]];//银行卡号
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.bankUser ReplaceStr:@"暂无信息"]];//姓名
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.bankName ReplaceStr:@"暂无信息"]];//银行类型
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.bankaddress ReplaceStr:@"暂无信息"]];//支行信息
            }else if ([self.orderListModel.payment_status intValue] == 2){//微信
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.payment_weixin ReplaceStr:@"无"]];
            }else if ([self.orderListModel.payment_status intValue] == 1){//支付宝
                [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.payment_alipay ReplaceStr:@"无"]];
            }else{
                [self.dataMutArr addObject:@"无支付账户"];
            }
            
            [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.refer ReplaceStr:@"无"]];//参考号
            [self.dataMutArr addObject:[NSString ensureNonnullString:orderDetailModel.updateTime ReplaceStr:@"无"]];//时间
            
            switch ([orderDetailModel.order_status intValue]) {//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成
                case 0:{
                    [self.dataMutArr addObject:@"已支付"];
                } break;
                case 1:{
                    [self.dataMutArr addObject:@"已发单"];
                } break;
                case 2:{
                    [self.dataMutArr addObject:@"已接单"];
                } break;
                case 3:{
                    [self.dataMutArr addObject:@"已作废"];
                } break;
                case 4:{
                    [self.dataMutArr addObject:@"已发货"];
                } break;
                case 5:{
                    [self.dataMutArr addObject:@"已完成"];
                } break;
                default:
                    [self.dataMutArr addObject:@"异常数据"];
                    break;
            }
            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
//CatfoodCO_payURL 喵粮产地购买已支付  #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image{
    extern NSString *randomStr;
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    if (self.orderListModel) {
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        __block NSData *picData = [UIImage imageZipToData:image];
        NSDictionary *dataDic = @{
            @"order_id":[self.orderListModel.ID stringValue],//order_id
            @"user_id":modelLogin.userId,
            @"identity":[YDDevice getUQID]
        };
        [mgr POST:API(BaseUrl2, CatfoodCO_payURL)
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
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            Toast(@"上传凭证成功");
            NSArray *vcArr = self.navigationController.viewControllers;
            UIViewController *vc = vcArr[2];
            [self.navigationController popToViewController:vc animated:YES];
            }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error) {
            NSLog(@"error = %@",error);
            Toast(@"上传图片失败");
        }];
    }
}
//CatfoodCO_pay_delURL 喵粮产地购买取消 #9
-(void)cancelOrder_producingArea_netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":[self.orderListModel.ID stringValue]//order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCO_pay_delURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([str isEqualToString:@""]) {
                Toast(@"取消成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}
//CatfoodSale_goodsURL 喵粮批发订单发货 #14
-(void)deliver_wholesaleMarket_PNetworking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,//订单id
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
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic{//真正开始购买
    extern NSString *randomStr;
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,
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
                [self.sureBtn setTitle:@"已付款"
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
//CatfoodSale_pay_delURL 喵粮批发取消 18
-(void)cancelOrder_wholesaleMarket_netWorking{//展示数据
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,//订单id
        @"reason":@""
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
//CatfoodBooth_goodsURL 喵粮抢摊位发货 #21
-(void)boothDeliver_networking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_goodsURL
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
//CatfoodBooth_del 喵粮抢摊位取消 22_1
-(void)CatfoodBooth_del_netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del
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
//CatfoodBooth_del_time 喵粮抢摊位取消剩余时间 #22_2
-(void)CatfoodBooth_del_time_netWorking{
    extern NSString *randomStr;
    NSDictionary *dataDic = @{
        @"order_id":self.orderListModel.ID,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del_time
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            self.time = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
            if ([self.orderListModel.order_type intValue] == 1) {
                if ([self.orderListModel.order_status intValue] == 2) {
                    if ([self.orderListModel.del_state intValue] == 0) {
                        self.countDownCancelBtn.titleEndStr = @"取消";
                        [self.countDownCancelBtn addTarget:self
                                                    action:@selector(CatfoodBooth_del_netWorking)
                                          forControlEvents:UIControlEventTouchUpInside];//#22_1
                    }else if ([self.orderListModel.del_state intValue] == 1){
                        [self.contactBuyer addTarget:self
                                              action:@selector(联系买家)
                                    forControlEvents:UIControlEventTouchUpInside];
                    }else{}
                }
            }
        }
    }];
}
//buyer_CatfoodRecord_checkURL 喵粮订单查看 3小时 del_wait_left_time
-(void)buyer_CatfoodRecord_checkURL_NetWorking{
    extern NSString *randomStr;
        NSDictionary *dic = @{
            @"order_id":[NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"],//订单id
            @"order_type":[NSString ensureNonnullString:self.orderListModel.order_type ReplaceStr:@"无"]//订单类型 —— 1、摊位;2、批发;3、产地
        };
           
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:buyer_CatfoodRecord_checkURL
                                                         parameters:@{
                                                             @"data":dic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response) {
                @strongify(self)
                NSLog(@"--%@",response);
                
                
                
//                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }];
    
//    self.time = 8;
//    self.contactBuyer.alpha = 1;
}

-(void)联系买家{
    Toast(@"开发中...");
}


@end

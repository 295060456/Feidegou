//
//  OrderDetailVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC+VM.h"

@implementation OrderDetailVC (VM)
//CatfoodSale_payURL 喵粮批发已支付 #17
-(void)upLoadPic_wholesaleMarket_havePaid_netWorking:(UIImage *)pic{//真正开始购买
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,
        @"user_id":modelLogin.userId,
        @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:pic];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *str = [NSString stringWithFormat:@"%@%@",ImgBaseURL,CatfoodSale_payURL];//正式BaseURL 测试BaseUrl
    [mgr POST:str
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key],
       @"randomStr":randomStr
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"payment_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        CGFloat _percent = uploadProgress.fractionCompleted * 100;
        NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
        NSLog(@"%@",str);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(str);
        }];
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSString dictionaryWithJsonString:aesDecryptString(responseObject, randomStr)];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(dataDic[@"message"]);
        }];
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
    }];
}

-(void)CancelDelivery_NetWorking{//看是否过3分钟
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del_time
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
                [self CancelDelivery_NetWorking2];
//                [self.tableView.mj_header beginRefreshing];
            }
        }
    }];
}

-(void)CancelDelivery_NetWorking2{//CatfoodBooth_del
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }];
}

///user/buyer/CatfoodBooth_del_time.htm // 看是否过3分钟

///user/buyer/CatfoodBooth_del.htm

//CatfoodRecord_delURL 喵粮订单撤销 #5
-(void)CancelDelivery_NetWorking3{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    NSDictionary *dataDic = @{
         @"order_id":[NSString ensureNonnullString:self.Order_id ReplaceStr:@"无"],//订单id
//         @"reason":dic[@"Result"],//撤销理由
         @"order_type":[NSString ensureNonnullString:self.orderListModel.order_type ReplaceStr:@"无"],//订单类型 —— 1、摊位;2、批发;3、产地
         @"user_id":modelLogin.userId,
         @"identity":[YDDevice getUQID]
    };
    __block NSData *picData = [UIImage imageZipToData:self.pic];
    [mgr POST:[NSString stringWithFormat:@"%@%@",ImgBaseURL,CatfoodRecord_delURL]//正式BaseURL 测试BaseUrl
   parameters:@{
       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
       @"key":[RSAUtil encryptString:randomStr
                           publicKey:RSA_Public_key],
       @"randomStr":randomStr
   }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:picData
                                    name:@"del_print"
                                fileName:@"test.png"
                                mimeType:@"image/png"];
    }
     progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
        CGFloat _percent = uploadProgress.fractionCompleted * 100;
        NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
        NSLog(@"%@",str);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(str);
        }];
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片成功");
        }];
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            Toast(@"上传图片失败");
        }];
    }];
}
//CatfoodCO_payURL 喵粮产地购买已支付  #8
-(void)uploadPic_producingArea_havePaid_netWorking:(UIImage *)image{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    ModelLogin *modelLogin;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    }
    if (self.orderListModel) {
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        __block NSData *picData = [UIImage imageZipToData:image];
        NSDictionary *dataDic = @{
            @"order_id":[self.Order_id stringValue],//order_id
            @"user_id":modelLogin.userId,
            @"identity":[YDDevice getUQID]
        };
        [mgr POST:[NSString stringWithFormat:@"%@%@",ImgBaseURL,CatfoodCO_payURL]//正式BaseURL 测试BaseUrl
       parameters:@{
           @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
           @"key":[RSAUtil encryptString:randomStr
                               publicKey:RSA_Public_key],
           @"randomStr":randomStr
       }
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:picData
                                        name:@"payment_print"
                                    fileName:@"test.png"
                                    mimeType:@"image/png"];
        }
         progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress = %@",uploadProgress);
            CGFloat _percent = uploadProgress.fractionCompleted * 100;
            NSString *str = [NSString stringWithFormat:@"上传图片中...%.2f",_percent];
            NSLog(@"%@",str);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                Toast(str);
            }];
        }
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                Toast(@"上传凭证成功");
            }];
            NSArray *vcArr = self.navigationController.viewControllers;
            UIViewController *vc = vcArr[2];
            [self.navigationController popToViewController:vc animated:YES];
            }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error) {
            NSLog(@"error = %@",error);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                Toast(@"上传图片失败");
            }];
        }];
    }
}
//CatfoodCO_BuyerURL 喵粮产地购买 #7
-(void)netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id//order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCO_BuyerURL
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
            OrderDetailModel *orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:response];
            NSString *str1 = [NSString ensureNonnullString:orderDetailModel.ID ReplaceStr:@"无"];//byname
            NSString *str2 = [NSString ensureNonnullString:orderDetailModel.quantity ReplaceStr:@""];
            [self.dataMutArr addObject:[NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2]];
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
//CatfoodCO_pay_delURL 喵粮产地购买取消 #9
-(void)cancelOrder_producingArea_netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":[self.Order_id stringValue]//order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodCO_pay_delURL
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
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_goodsURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
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
//CatfoodSale_pay_delURL 喵粮批发取消 18
-(void)cancelOrder_wholesaleMarket_netWorking{//展示数据
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,//订单id
        @"reason":@""
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_pay_delURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
                @strongify(self)
                NSLog(@"--%@",response);
                Toast(@"取消成功");
                [self.normalCancelBtn setTitle:@"已取消"
                                   forState:UIControlStateNormal];
                self.normalCancelBtn.userInteractionEnabled = NO;
                self.normalCancelBtn.alpha = 0.4f;
            }
        }
    }];
}
//CatfoodBooth_goodsURL 喵粮抢摊位发货 #21
-(void)boothDeliver_networking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_goodsURL
                                                     parameters:@{
                                                         @"data":dataDic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
//                @strongify(self)
                NSLog(@"--%@",response);
                Toast(@"发货成功");
                self.sureBtn.alpha = 0;
                self.countDownCancelBtn.alpha = 0;
                self.normalCancelBtn.alpha = 0;
                [self.dataMutArr removeAllObjects];
                [self.titleMutArr removeAllObjects];
                [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"直通车"];//订单类型 —— 1、直通车;2、批发;3、产地
            }
        }
    }];
}
//CatfoodBooth_del_time 喵粮抢摊位取消剩余时间 #22_2
-(void)CatfoodBooth_del_time_netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id,//订单id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del_time
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
        NSLog(@"");
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            if (b.intValue == 500) {
                Toast(dic[@"message"]);
//                self.countDownCancelBtn.hidden = 0;
                [self.normalCancelBtn setTitle:@"取消"
                                      forState:UIControlStateNormal];
                [self.normalCancelBtn addTarget:self
                                         action:@selector(CatfoodBooth_del_time_netWorking)//先查看剩余时间，过了倒计时才进行下一步
                               forControlEvents:UIControlEventTouchUpInside];//#9
            }else if (b.intValue == 200){//3分钟到了！
//                self.tipsIMGV.alpha = 1;
                [self pullToRefresh];
                self.normalCancelBtn.hidden = YES;
                self.time = 3;
                self.titleEndStr = @"取消";
                self.titleBeginStr = @"取消";
                self.countDownCancelBtn.backgroundColor = kOrangeColor;
                [self.countDownCancelBtn addTarget:self
                                            action:@selector(cancdel)//喵粮抢摊位取消 真正取消
                                  forControlEvents:UIControlEventTouchUpInside];//#21_1
            }else{}
        }


//        if ([response isKindOfClass:[NSString class]]) {
//            NSString *str = (NSString *)response;
//            NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//            self.time = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
//            if ([self.orderListModel.order_type intValue] == 1) {//订单类型 1、直通车;2、批发;3、平台
//                if ([self.orderListModel.order_status intValue] == 2) {//已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                    if ([self.orderListModel.del_state intValue] == 0) {//不影响（驳回） 0、不影响（驳回）;1、待审核;2、已通过
//                        self.countDownCancelBtn.titleEndStr = @"取消";
////                        self.countDownCancelBtn.titleBeginStr = @"";
//                        [self.countDownCancelBtn addTarget:self
//                                                    action:@selector(CatfoodBooth_del_netWorking)
//                                          forControlEvents:UIControlEventTouchUpInside];//#22_1
//                    }else if ([self.orderListModel.del_state intValue] == 1){//待审核 0、不影响（驳回）;1、待审核;2、已通过
//                        //计算两个时间的相隔
////                        NSDateFormatter *formatter = NSDateFormatter.new;
////                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////                        NSTimeInterval time = [NSString timeIntervalstartDate:self.orderListModel.updateTime
////                                                                      endDate:[formatter stringFromDate:[NSDate date]]
////                                                                timeFormatter:formatter];
////                        self.time = 3 * 3600 - time;
//                        self.time = 3;
//                        self.titleEndStr = @"联系买家";
//                        [self.contactBuyer addTarget:self
//                                              action:@selector(联系买家)
//                                    forControlEvents:UIControlEventTouchUpInside];
//                    }else{}
//                }
//            }
//        }
    }];
}
//CatfoodBooth_del 喵粮抢摊位取消 22_1
-(void)CatfoodBooth_del_netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dataDic = @{
        @"order_id":self.Order_id
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodBooth_del
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
        NSLog(@"KKKK = %@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSNumber *b = dic[@"code"];
            Toast(dic[@"message"]);
            if (b.intValue == 200) {
                self.sureBtn.alpha = 0;
                self.countDownCancelBtn.alpha = 0;
                [self pullToRefresh];
            }else if (b.intValue == 500){
                
            }else{}
        }
    }];
}
//buyer_CatfoodRecord_checkURL 喵粮订单查看
-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSString *)order_type{//订单类型 —— 1、摊位;2、批发;3、产地
    NSNumber *b;
    if ([order_type isEqualToString:@"直通车"]) {
        b = [NSNumber numberWithInt:1];
    }else if ([order_type isEqualToString:@"批发"]){
        b = [NSNumber numberWithInt:2];
    }else if ([order_type isEqualToString:@"产地"]){
        b = [NSNumber numberWithInt:3];
    }else{
        b = [NSNumber numberWithInt:0];
    }
    
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic = @{
        @"order_id":[NSString ensureNonnullString:self.Order_id ReplaceStr:@"无"],//订单id
        @"order_type":[NSString ensureNonnullString:b ReplaceStr:@"无"]//订单类型 —— 1、摊位;2、批发;3、产地
    };
       
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_checkURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            //1、支付宝;2、微信;3、银行卡
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = (NSDictionary *)response;
                OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
//                OrderManager_panicBuyingModel *model = [OrderManager_panicBuyingModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
                model.del_wait_left_time = dataDic[@"del_wait_left_time"];//外层数据
                [self.titleMutArr addObject:@"订单号:"];
                [self.titleMutArr addObject:@"单价:"];
                [self.titleMutArr addObject:@"数量:"];
                [self.titleMutArr addObject:@"总价:"];
                
                [self.titleMutArr addObject:@"支付方式:"];
                
                [self.dataMutArr addObject:[NSString ensureNonnullString:model.ordercode ReplaceStr:@"暂无"]];//订单号
                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.price ReplaceStr:@"暂无"] stringByAppendingString:@"CNY"]];//单价
                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.quantity ReplaceStr:@"暂无"] stringByAppendingString:@" g"]];//数量
                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.rental ReplaceStr:@"暂无"] stringByAppendingString:@" CNY"]];//总价
//OrderDetailModel 和 OrderManager_panicBuyingModel 是同一个
                if (self.orderDetailModel) {
                    if ([self.orderDetailModel.payment_status intValue] == 3) {//3、银行卡
                        [self.dataMutArr addObject:@"银行卡"];
                        
                    }else if ([self.orderDetailModel.payment_status intValue] == 2){//2、微信
                        [self.dataMutArr addObject:@"微信"];
                    }else if ([self.orderDetailModel.payment_status intValue] == 1){//1、支付宝
                        [self.dataMutArr addObject:@"支付宝"];
                    }else{
                        [self.dataMutArr addObject:@"支付方式数据异常"];//支付方式
                        [self.titleMutArr addObject:@"账户异常:"];
                        [self.dataMutArr addObject:@"支付账号数据异常"];//账号
                    }
                }
                else if (self.orderManager_panicBuyingModel){
                    if ([self.orderManager_panicBuyingModel.payment_status intValue] == 3) {//3、银行卡
                        [self.dataMutArr addObject:@"银行卡"];
                        
                    }else if ([self.orderManager_panicBuyingModel.payment_status intValue] == 2){//2、微信
                        [self.dataMutArr addObject:@"微信"];
                    }else if ([self.orderManager_panicBuyingModel.payment_status intValue] == 1){//1、支付宝
                        [self.dataMutArr addObject:@"支付宝"];
                    }else{
                        [self.dataMutArr addObject:@"支付方式数据异常"];//支付方式
                        [self.titleMutArr addObject:@"账户异常:"];
                        [self.dataMutArr addObject:@"支付账号数据异常"];//账号
                    }
                }
                else if (self.orderManager_producingAreaModel){
                    if ([self.orderManager_producingAreaModel.payment_status intValue] == 3) {//3、银行卡
                        [self.dataMutArr addObject:@"银行卡"];
                        
                    }else if ([self.orderManager_producingAreaModel.payment_status intValue] == 2){//2、微信
                        [self.dataMutArr addObject:@"微信"];
                    }else if ([self.orderManager_producingAreaModel.payment_status intValue] == 1){//1、支付宝
                        [self.dataMutArr addObject:@"支付宝"];
                    }else{
                        [self.dataMutArr addObject:@"银行卡"];//支付方式
                        [self.titleMutArr addObject:@"银行卡号:"];//写死
                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
                    }
                }
                else if (self.catFoodProducingAreaModel){
                    if ([self.catFoodProducingAreaModel.payment_status intValue] == 3) {//3、银行卡
                        [self.dataMutArr addObject:@"银行卡"];
                        
                    }else if ([self.catFoodProducingAreaModel.payment_status intValue] == 2){//2、微信
                        [self.dataMutArr addObject:@"微信"];
                    }else if ([self.catFoodProducingAreaModel.payment_status intValue] == 1){//1、支付宝
                        [self.dataMutArr addObject:@"支付宝"];
                    }else{
                        [self.dataMutArr addObject:@"银行卡"];//支付方式
                        [self.titleMutArr addObject:@"银行卡号:"];//写死
                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
                    }
                }
                else if (self.orderListModel){
                    //order_type 订单类型 1、直通车;2、批发;3、平台
                    if (self.orderListModel.order_type.intValue == 1) {//直通车 极光
                        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.byname ReplaceStr:@"无"];//?????????
                        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
                        self.str = [NSString stringWithFormat:@"您向%@出售%@g喵粮",str1,str2];//trade_no
                    }else if (self.orderListModel.order_type.intValue == 3) {//平台
                        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.seller_name ReplaceStr:@"无"];
                        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
                        self.str = [NSString stringWithFormat:@"您向%@购买%@g喵粮",str1,str2];//trade_no
                    }
                    
                    if ([self.orderListModel.payment_status intValue] == 3) {//3、银行卡
                        [self.dataMutArr addObject:@"银行卡"];
                    }else if ([self.orderListModel.payment_status intValue] == 2){//2、微信
                        [self.dataMutArr addObject:@"微信"];
                    }else if ([self.orderListModel.payment_status intValue] == 1){//1、支付宝
                        [self.dataMutArr addObject:@"支付宝"];
                    }else{
                        [self.dataMutArr addObject:@"银行卡"];//支付方式
                        [self.titleMutArr addObject:@"银行卡号:"];//写死
                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
                    }
                    ///////
                    if (self.orderListModel.order_type.intValue == 1) {//直通车 极光
                        if ([self.orderListModel.order_status intValue] == 0) {
                            //倒计时3s + 发货
                            [self.sureBtn setTitle:@"发货"
                                          forState:UIControlStateNormal];
                            [self.sureBtn addTarget:self
                                        action:@selector(boothDeliver_networking)//喵粮抢摊位发货
                              forControlEvents:UIControlEventTouchUpInside];//#21
                            self.titleEndStr = @"取消";
                            self.titleBeginStr = @"取消";
                            [self.countDownCancelBtn addTarget:self
                                                        action:@selector(CancelDelivery_NetWorking)
                                              forControlEvents:UIControlEventTouchUpInside];
                        }
                        else if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                            if ([self.orderListModel.del_state intValue] == 0) {//0状态 0、不影响;1、待审核;2、已通过 3、驳回
                                [self.dataMutArr addObject:@"已下单"];
                                //去请求 #22-2 获取最新时间
                                [self CatfoodBooth_del_time_netWorking];//#22-2
                                [self.sureBtn setTitle:@"发货"
                                              forState:UIControlStateNormal];
                                [self.sureBtn addTarget:self
                                            action:@selector(boothDeliver_networking)//喵粮抢摊位发货
                                  forControlEvents:UIControlEventTouchUpInside];//#21
                                self.titleEndStr = @"取消";
                                //KKK
                                [self.countDownCancelBtn addTarget:self
                                                            action:@selector(CancelDelivery_NetWorking)//
                                                  forControlEvents:UIControlEventTouchUpInside];
                            }else if ([self.orderListModel.del_state intValue] == 1){//在审核中/买家确认中  0、不影响;1、待审核;2、已通过 3、驳回
                                //买家未确认
            //                    [self.titleMutArr addObject:@"凭证:"];
                                [self.dataMutArr addObject:@"等待买家确认"];//@"待审核 —— 等待买家确认(3小时内)"
                                [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_print ReplaceStr:@""]];
                                NSLog(@"");
                //                        [self.sureBtn setTitle:@"发货"
                //                                      forState:UIControlStateNormal];
                //                        [self.sureBtn addTarget:self
                //                                    action:@selector(boothDeliver_networking)//喵粮抢摊位发货
                //                          forControlEvents:UIControlEventTouchUpInside];//#21
                                NSLog(@"");
                            }else if ([self.orderListModel.del_state intValue] == 2){//确定取消了 //撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
                                [self.dataMutArr addObject:@"已通过"];
                            }else if ([self.orderListModel.del_state intValue] == 3){//撤销被驳回 或者 发货了//撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
                                //订单状态显示为 已驳回
                                [self.dataMutArr addObject:@"已驳回"];
                            }else{
                                [self.dataMutArr addObject:@""];
                            }
                        }
                    }//直通车 极光
                    else if (self.orderListModel.order_type.intValue == 3){//喵粮产地
                        if (self.orderListModel.order_status.intValue == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                            if ([self.orderListModel.del_state intValue] == 0) {
                            [self.dataMutArr addObject:@"已下单"];//333
                            self.time = 3;
                            self.titleEndStr = @"取消";
                            self.titleBeginStr = @"取消";
                //                    [self.countDownCancelBtn addTarget:self
                //                                                action:@selector(cancelOrder_producingArea_netWorking)
                //                                      forControlEvents:UIControlEventTouchUpInside];//#9
                            [self.normalCancelBtn setTitle:@"取消"
                                                    forState:UIControlStateNormal];
                            [self.normalCancelBtn addTarget:self
                                                    action:@selector(cancelOrder_producingArea_netWorking)// 喵粮产地购买取消
                                        forControlEvents:UIControlEventTouchUpInside];//#9
                            //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
                            if ([self.orderListModel.del_state intValue] == 0) {
                                [self.sureBtn setTitle:@"上传支付凭证"//
                                              forState:UIControlStateNormal];
                            }
                            [self.sureBtn addTarget:self
                                             action:@selector(getPrintPic:)
                                   forControlEvents:UIControlEventTouchUpInside];//CatfoodCO_payURL 喵粮产地购买已支付  #8
                            }
                        }else if (self.orderListModel.order_status.intValue == 0){//订单状态|已支付 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成 显示凭证
//                            [self.dataMutArr addObject:@"已支付"];//🏳️
                            if (self.orderManager_producingAreaModel.payment_print) {
                                [self.titleMutArr addObject:@"支付凭证"];
                                [self.dataMutArr addObject:self.orderManager_producingAreaModel.payment_print];
                            }
                            
                        //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
                            if ([self.orderManager_producingAreaModel.del_state intValue] == 0) {
                                [self.reloadPicBtn setTitle:@"重新上传支付凭证"
                                                   forState:UIControlStateNormal];
                                [self.reloadPicBtn sizeToFit];
                                self.reloadPicBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                                [self.reloadPicBtn addTarget:self
                                          action:@selector(getPrintPic:)
                                forControlEvents:UIControlEventTouchUpInside];//CatfoodCO_payURL 喵粮产地购买已支付  #8
                            }
                        }else{}
                    }//平台
                    else{}
                }
                else{}

                [self.titleMutArr addObject:@"下单时间:"];
                [self.titleMutArr addObject:@"订单状态:"];
                
                [self.dataMutArr addObject:[NSString ensureNonnullString:model.updateTime ReplaceStr:@"暂无"]];//下单时间
                //状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                if ([model.order_status intValue] == 0) {//已支付
                     [self.dataMutArr addObject:@"已支付"];
                }else if ([model.order_status intValue] == 1){//已发单
                     [self.dataMutArr addObject:@"已发单"];
                }else if ([model.order_status intValue] == 2){//已下单
                    ////撤销状态 0、不影响（驳回）;1、待审核;2、已通过
                    if (model.del_state.intValue == 0) {
                        [self.dataMutArr addObject:@"已下单"];
                    }else if (model.del_state.intValue == 1){
                        [self.dataMutArr addObject:@"待审核"];
                    }else if (model.del_state.intValue == 2){
                        [self.dataMutArr addObject:@"已通过"];
                    }else{
                        [self.dataMutArr addObject:@"已下单"];
                    }
                }else if ([model.order_status intValue] == 3){//已作废
                     [self.dataMutArr addObject:@"已作废"];
                }else if ([model.order_status intValue] == 4){//已发货
                     [self.dataMutArr addObject:@"已发货"];
                }else if ([model.order_status intValue] == 5){//已完成
                     [self.dataMutArr addObject:@"已完成"];
                }else{
                    [self.dataMutArr addObject:@"状态异常"];
                }

//OrderDetailModel 和 OrderManager_panicBuyingModel 是同一个
                
#warning 倒计时数据源          OrderDetailModel
                if (model.del_state.intValue == 1 &&//撤销状态 0、不影响（驳回）;1、待审核;2、已通过
                    model.order_status.intValue == 2) {//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr removeLastObject];
                    //计算两个时间的相隔
                    NSDateFormatter *formatter = NSDateFormatter.new;
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSNumber *timer = [NSNumber numberWithDouble:model.del_wait_left_time.floatValue / 1000];
                    [self.dataMutArr addObject:[NSString stringWithFormat:@"等待买家确认 %@",timer.stringValue]];
                }
                
                if (![NSString isNullString:model.payment_print]) {
                    [self.titleMutArr addObject:@"凭证:"];
                    [self.dataMutArr addObject:model.payment_print];
                }

            }
            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

-(void)联系买家{
//    Toast(@"开发中...");
    [self chat];
}


@end

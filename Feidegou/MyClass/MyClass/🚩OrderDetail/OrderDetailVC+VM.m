//
//  OrderDetailVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC+VM.h"

@implementation OrderDetailVC (VM)
-(void)makeTitleAndData{
    
    [self.titleMutArr addObject:@"订单号:"];
    [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.ordercode ReplaceStr:@"暂无"]];//订单号
    
    [self.titleMutArr addObject:@"单价:"];
    [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderDetailModel.price ReplaceStr:@"暂无"] stringByAppendingString:@"CNY"]];//单价
    
    [self.titleMutArr addObject:@"数量:"];
    [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderDetailModel.quantity ReplaceStr:@"暂无"] stringByAppendingString:@" g"]];//数量
    
    [self.titleMutArr addObject:@"总价:"];
    [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderDetailModel.rental ReplaceStr:@"暂无"] stringByAppendingString:@" CNY"]];//总价
    if (self.orderManager_producingAreaModel) {//订单管理——喵粮产地

        [self.titleMutArr addObject:@"支付方式:"];
        [self.dataMutArr addObject:@"银行卡"];
        
        [self.titleMutArr addObject:@"银行卡号:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankCard ReplaceStr:@"暂无"]];//账号
        
        [self.titleMutArr addObject:@"姓名:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankUser ReplaceStr:@"暂无信息"]];//姓名
        
        [self.titleMutArr addObject:@"下单时间:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.updateTime ReplaceStr:@"暂无"]];//下单时间

    }//订单管理——喵粮产地
    else if (self.orderManager_panicBuyingModel){//订单管理——直通车
        [self.titleMutArr addObject:@"支付方式:"];
        //支付类型:1、支付宝;2、微信;3、银行卡
        if (self.orderDetailModel.payment_status.intValue == 3) {//3、银行卡
            [self.dataMutArr addObject:@"银行卡"];
        }else if (self.orderDetailModel.payment_status.intValue == 2){//2、微信
            [self.dataMutArr addObject:@"微信"];
        }else if (self.orderDetailModel.payment_status.intValue == 1){//1、支付宝
            [self.dataMutArr addObject:@"支付宝"];
        }else{
            [self.dataMutArr addObject:@"支付方式异常"];
        }
        
        [self.titleMutArr addObject:@"下单时间:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.updateTime ReplaceStr:@"暂无"]];//下单时间
    }//订单管理——直通车
    else if (self.catFoodProducingAreaModel){//喵粮产地 只允许银行卡

        [self.titleMutArr addObject:@"银行卡号:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankCard ReplaceStr:@"暂无"]];//银行卡号:
        
        [self.titleMutArr addObject:@"姓名:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankUser ReplaceStr:@"暂无"]];//姓名:
        
        [self.titleMutArr addObject:@"银行类型:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankName ReplaceStr:@"暂无"]];//银行类型:
        
        [self.titleMutArr addObject:@"支行信息:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.bankaddress ReplaceStr:@"暂无"]];//支行信息:
        
        [self.titleMutArr addObject:@"下单时间:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.updateTime ReplaceStr:@"暂无"]];//下单时间:
    }//喵粮产地 只允许银行卡
    else if (self.jPushOrderDetailModel){//极光推送

        [self.titleMutArr addObject:@"支付方式:"];
        //支付类型:1、支付宝;2、微信;3、银行卡
        if (self.orderDetailModel.payment_status.intValue == 3) {//3、银行卡
            [self.dataMutArr addObject:@"银行卡"];
        }else if (self.orderDetailModel.payment_status.intValue == 2){//2、微信
            [self.dataMutArr addObject:@"微信"];
        }else if (self.orderDetailModel.payment_status.intValue == 1){//1、支付宝
            [self.dataMutArr addObject:@"支付宝"];
        }else{
            [self.dataMutArr addObject:@"支付方式异常"];//银行卡？
        }
        [self.titleMutArr addObject:@"下单时间:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.updateTime ReplaceStr:@"暂无"]];//下单时间
    }//极光推送
    else{}
    //Common
    [self.titleMutArr addObject:@"订单状态"];
//    order_status;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//    del_state;//撤销状态 0、不影响（驳回）;1、待审核;2、已通过
    if (self.orderDetailModel.order_status.intValue == 0) {//已支付
         [self.dataMutArr addObject:@"已支付"];
    }else if (self.orderDetailModel.order_status.intValue == 1){//已发单
         [self.dataMutArr addObject:@"已发单"];
    }else if (self.orderDetailModel.order_status.intValue == 2){//已下单
        ////撤销状态 0、不影响（驳回）;1、待审核;2、已通过
        if (self.orderDetailModel.del_state.intValue == 0) {
            [self.dataMutArr addObject:@"已下单"];
        }else if (self.orderDetailModel.del_state.intValue == 1){
            //计算两个时间的相隔
            NSDateFormatter *formatter = NSDateFormatter.new;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSNumber *timer = [NSNumber numberWithDouble:self.orderDetailModel.del_wait_left_time.floatValue / 1000];
            self.orderDetailModel.countDownStr = [NSString stringWithFormat:@"等待买家确认 %@",timer.stringValue];
            [self.dataMutArr addObject:self.orderDetailModel.countDownStr];
        }else if (self.orderDetailModel.del_state.intValue == 2){
            [self.dataMutArr addObject:@"已通过"];
        }else{
            [self.dataMutArr addObject:@"已下单"];
        }
    }else if (self.orderDetailModel.order_status.intValue == 3){//已作废
         [self.dataMutArr addObject:@"已作废"];
    }else if (self.orderDetailModel.order_status.intValue == 4){//已发货
         [self.dataMutArr addObject:@"已发货"];
    }else if (self.orderDetailModel.order_status.intValue == 5){//已完成
         [self.dataMutArr addObject:@"已完成"];
    }else{
        [self.dataMutArr addObject:@"状态异常"];
    }

//    order_status;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
    if (self.orderDetailModel.order_status.intValue == 0 ||
        self.orderDetailModel.order_status.intValue == 4) {
        [self.titleMutArr addObject:@"凭证:"];
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderDetailModel.payment_print ReplaceStr:@""]];
    }
}
//这个是数据核心
//buyer_CatfoodRecord_checkURL 喵粮订单查看
-(void)buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:(NSNumber *)Order_type{//订单类型 —— 1、摊位;2、批发;3、产地
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic = @{
        @"order_id":self.Order_id,//订单id
        @"order_type":Order_type//订单类型 —— 1、摊位;2、批发;3、产地
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
        @strongify(self)
        NSLog(@"--%@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = (NSDictionary *)response;
            self.orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
            self.orderDetailModel.del_wait_left_time = dataDic[@"del_wait_left_time"];//外层数据
            if (self.dataMutArr.count) {
                [self.dataMutArr removeAllObjects];
            }
            if (self.titleMutArr.count) {
                [self.titleMutArr removeAllObjects];
            }
            [self makeTitleAndData];
//            订单类型 1、直通车;2、批发;3、喵粮产地
            if (self.orderDetailModel.order_type.intValue == 1) {//直通车
                self.gk_navTitle = @"直通车订单详情";
                NSString *str1 = [NSString ensureNonnullString:self.orderDetailModel.byname ReplaceStr:@"无"];//?????????
                NSString *str2 = [NSString ensureNonnullString:self.orderDetailModel.quantity ReplaceStr:@""];
                self.str = [NSString stringWithFormat:@"您向%@出售%@g喵粮",str1,str2];//trade_no
            }//直通车
            else if (self.orderDetailModel.order_type.intValue == 3){//喵粮产地
                self.gk_navTitle = @"产地订单详情";
                NSString *str1 = [NSString ensureNonnullString:self.orderDetailModel.trade_no ReplaceStr:@"无"];//?????????
                NSString *str2 = [NSString ensureNonnullString:self.orderDetailModel.quantity ReplaceStr:@""];
                self.str = [NSString stringWithFormat:@"您向%@购买%@g喵粮",str1,str2];//trade_no
            }//喵粮产地
//            order_type;//订单类型 1、直通车;2、批发;3、平台
//            order_status;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//            del_state;//撤销状态 0、不影响（驳回）;1、待审核;2、已通过
            if (self.orderDetailModel.order_type.intValue == 1) {//直通车
                if (self.orderDetailModel.order_status.intValue == 0) {//已支付
                    //倒计时3s + 发货
                    [self.sureBtn setTitle:@"发货"
                                  forState:UIControlStateNormal];
                    [self.sureBtn addTarget:self
                                     action:@selector(boothDeliver_networking)//喵粮抢摊位发货
                           forControlEvents:UIControlEventTouchUpInside];//#21
                    self.titleEndStr = @"取消";
                    self.titleBeginStr = @"取消";
                    [self.normalCancelBtn setTitle:@"取消"
                                            forState:UIControlStateNormal];
                    [self.normalCancelBtn addTarget:self
                                             action:@selector(CatfoodBooth_del_time_netWorking)//先查看剩余时间，过了倒计时才进行下一步 喵粮抢摊位取消CatfoodBooth_del_netWorking
                                   forControlEvents:UIControlEventTouchUpInside];//#9
                }else if (self.orderDetailModel.order_status.intValue == 2){//已下单
                    if (self.orderDetailModel.del_state.intValue == 0) {//0、不影响（驳回）
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
                                                    action:@selector(CancelDelivery_NetWorking)//喵粮订单撤销
                                          forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }else if (self.orderDetailModel.order_type.intValue == 3){//喵粮产地
                //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
//                order_status;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                order_type;//订单类型 1、直通车;2、批发;3、产地
                if (self.orderDetailModel.del_state.intValue == 0) {
                    if (self.orderDetailModel.order_status.intValue == 2) {
                        self.time = 3;
                        self.titleEndStr = @"取消";
                        self.titleBeginStr = @"取消";
                        [self.countDownCancelBtn addTarget:self
                                                    action:@selector(cancelOrder_producingArea_netWorking)//喵粮产地购买取消
                                          forControlEvents:UIControlEventTouchUpInside];//#9
                        [self.sureBtn setTitle:@"上传支付凭证"//
                                      forState:UIControlStateNormal];
                        [self.sureBtn.titleLabel sizeToFit];
                        self.sureBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                    }else if ([self.orderDetailModel.order_status intValue] == 0){
                        [self.sureBtn setTitle:@"重新上传支付凭证"//
                                      forState:UIControlStateNormal];
                        [self.sureBtn.titleLabel sizeToFit];
                        self.sureBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                        self.sureBtn.mj_x = (SCREEN_WIDTH - self.sureBtn.mj_w) / 2;
                    }else if (self.orderDetailModel.order_status.intValue == 4){
                        self.sureBtn.alpha = 0;
                    }
                    else{}
                }
                [self.sureBtn addTarget:self
                                 action:@selector(getPrintPic:)
                       forControlEvents:UIControlEventTouchUpInside];//#7
            }else{}
            
            NSLog(@"%@",self.dataMutArr);
            NSLog(@"%@",self.titleMutArr);
        }
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
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
//                Toast(@"取消成功");
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
                [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:self.Order_type];//订单类型 —— 1、直通车;2、批发;3、产地
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


@end

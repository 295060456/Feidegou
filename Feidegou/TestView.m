//
//  TestView.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "TestView.h"

@interface TestView (){
    
}

@end

@implementation TestView

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( event.subtype == UIEventSubtypeMotionShake ) {
        NSLog(@"Shake!");
    }

    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    
}

//{
//            @strongify(self)
//            NSLog(@"--%@",response);
//            //1、支付宝;2、微信;3、银行卡
//            if ([response isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dataDic = (NSDictionary *)response;
//                JPushOrderDetailModel *model = [JPushOrderDetailModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
////                OrderManager_panicBuyingModel *model = [OrderManager_panicBuyingModel mj_objectWithKeyValues:dataDic[@"catFoodOrder"]];
//                model.del_wait_left_time = dataDic[@"del_wait_left_time"];//外层数据
//                [self.titleMutArr addObject:@"订单号:"];
//                [self.titleMutArr addObject:@"单价:"];
//                [self.titleMutArr addObject:@"数量:"];
//                [self.titleMutArr addObject:@"总价:"];
//                
//                [self.titleMutArr addObject:@"支付方式:"];
//                
//                [self.dataMutArr addObject:[NSString ensureNonnullString:model.ordercode ReplaceStr:@"暂无"]];//订单号
//                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.price ReplaceStr:@"暂无"] stringByAppendingString:@"CNY"]];//单价
//                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.quantity ReplaceStr:@"暂无"] stringByAppendingString:@" g"]];//数量
//                [self.dataMutArr addObject:[[NSString ensureNonnullString:model.rental ReplaceStr:@"暂无"] stringByAppendingString:@" CNY"]];//总价
////OrderDetailModel 和 OrderManager_panicBuyingModel 是同一个
//                if (self.jPushOrderDetailModel) {//如果 这个页面是从极光推送过来的
//                    if ([self.jPushOrderDetailModel.payment_status intValue] == 3) {//3、银行卡
//                        [self.dataMutArr addObject:@"银行卡"];
//                        
//                    }else if ([self.jPushOrderDetailModel.payment_status intValue] == 2){//2、微信
//                        [self.dataMutArr addObject:@"微信"];
//                    }else if ([self.jPushOrderDetailModel.payment_status intValue] == 1){//1、支付宝
//                        [self.dataMutArr addObject:@"支付宝"];
//                    }else{
//                        [self.dataMutArr addObject:@"支付方式数据异常"];//支付方式
//                        [self.titleMutArr addObject:@"账户异常:"];
//                        [self.dataMutArr addObject:@"支付账号数据异常"];//账号
//                    }
//                }//如果 这个页面是从极光推送过来的
//                else if (self.orderManager_panicBuyingModel){//如果 这个页面是从订单管理 直通车过来的
//                    if ([self.orderManager_panicBuyingModel.payment_status intValue] == 3) {//3、银行卡
//                        [self.dataMutArr addObject:@"银行卡"];
//                        
//                    }else if ([self.orderManager_panicBuyingModel.payment_status intValue] == 2){//2、微信
//                        [self.dataMutArr addObject:@"微信"];
//                    }else if ([self.orderManager_panicBuyingModel.payment_status intValue] == 1){//1、支付宝
//                        [self.dataMutArr addObject:@"支付宝"];
//                    }else{
//                        [self.dataMutArr addObject:@"支付方式数据异常"];//支付方式
//                        [self.titleMutArr addObject:@"账户异常:"];
//                        [self.dataMutArr addObject:@"支付账号数据异常"];//账号
//                    }
//                }//如果 这个页面是从订单管理 直通车过来的
//                else if (self.orderManager_producingAreaModel){//如果 这个页面是从订单管理 喵粮产地过来的
//                    if ([self.orderManager_producingAreaModel.payment_status intValue] == 3) {//3、银行卡
//                        [self.dataMutArr addObject:@"银行卡"];
//                        
//                    }else if ([self.orderManager_producingAreaModel.payment_status intValue] == 2){//2、微信
//                        [self.dataMutArr addObject:@"微信"];
//                    }else if ([self.orderManager_producingAreaModel.payment_status intValue] == 1){//1、支付宝
//                        [self.dataMutArr addObject:@"支付宝"];
//                    }else{
//                        [self.dataMutArr addObject:@"银行卡"];//支付方式
//                        [self.titleMutArr addObject:@"银行卡号:"];//写死
//                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
//                    }
//                }//如果 这个页面是从订单管理 喵粮产地过来的
//                else if (self.catFoodProducingAreaModel){//如果 这个页面是从 喵粮产地过来的
//                    if ([self.catFoodProducingAreaModel.payment_status intValue] == 3) {//3、银行卡
//                        [self.dataMutArr addObject:@"银行卡"];
//                        
//                    }else if ([self.catFoodProducingAreaModel.payment_status intValue] == 2){//2、微信
//                        [self.dataMutArr addObject:@"微信"];
//                    }else if ([self.catFoodProducingAreaModel.payment_status intValue] == 1){//1、支付宝
//                        [self.dataMutArr addObject:@"支付宝"];
//                    }else{
//                        [self.dataMutArr addObject:@"银行卡"];//支付方式
//                        [self.titleMutArr addObject:@"银行卡号:"];//写死
//                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
//                    }
//                }//如果 这个页面是从 喵粮产地过来的
//                else if (self.orderListModel){//如果 这个页面是从 搜索过来的
//                    //order_type 订单类型 1、直通车;2、批发;3、平台
//                    if (self.orderListModel.order_type.intValue == 1) {//直通车 极光
//                        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.byname ReplaceStr:@"无"];//?????????
//                        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
//                        self.str = [NSString stringWithFormat:@"您向%@出售%@g喵粮",str1,str2];//trade_no
//                    }else if (self.orderListModel.order_type.intValue == 3) {//平台
//                        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.seller_name ReplaceStr:@"无"];
//                        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
//                        self.str = [NSString stringWithFormat:@"您向%@购买%@g喵粮",str1,str2];//trade_no
//                    }
//                    
//                    if ([self.orderListModel.payment_status intValue] == 3) {//3、银行卡
//                        [self.dataMutArr addObject:@"银行卡"];
//                    }else if ([self.orderListModel.payment_status intValue] == 2){//2、微信
//                        [self.dataMutArr addObject:@"微信"];
//                    }else if ([self.orderListModel.payment_status intValue] == 1){//1、支付宝
//                        [self.dataMutArr addObject:@"支付宝"];
//                    }else{
//                        [self.dataMutArr addObject:@"银行卡"];//支付方式
//                        [self.titleMutArr addObject:@"银行卡号:"];//写死
//                        [self.dataMutArr addObject:[NSString ensureNonnullString:model.bankCard ReplaceStr:@"暂无"]];//账号
//                    }
//                    ///////
//                    if (self.orderListModel.order_type.intValue == 1) {//
//                        if ([self.orderListModel.order_status intValue] == 0) {
//                            //倒计时3s + 发货
//                            [self.sureBtn setTitle:@"发货"
//                                          forState:UIControlStateNormal];
//                            [self.sureBtn addTarget:self
//                                        action:@selector(boothDeliver_networking)//喵粮抢摊位发货
//                              forControlEvents:UIControlEventTouchUpInside];//#21
//                            self.titleEndStr = @"取消";
//                            self.titleBeginStr = @"取消";
//                            [self.countDownCancelBtn addTarget:self
//                                                        action:@selector(CancelDelivery_NetWorking)
//                                              forControlEvents:UIControlEventTouchUpInside];
//                        }
//                        else if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                            if ([self.orderListModel.del_state intValue] == 0) {//0状态 0、不影响;1、待审核;2、已通过 3、驳回
//                                [self.dataMutArr addObject:@"已下单"];
//                                //去请求 #22-2 获取最新时间
//                                [self CatfoodBooth_del_time_netWorking];//#22-2
//                                [self.sureBtn setTitle:@"发货"
//                                              forState:UIControlStateNormal];
//                                [self.sureBtn addTarget:self
//                                            action:@selector(boothDeliver_networking)//喵粮抢摊位发货
//                                  forControlEvents:UIControlEventTouchUpInside];//#21
//                                self.titleEndStr = @"取消";
//                                //KKK
//                                [self.countDownCancelBtn addTarget:self
//                                                            action:@selector(CancelDelivery_NetWorking)//
//                                                  forControlEvents:UIControlEventTouchUpInside];
//                            }else if ([self.orderListModel.del_state intValue] == 1){//在审核中/买家确认中  0、不影响;1、待审核;2、已通过 3、驳回
//                                //买家未确认
//            //                    [self.titleMutArr addObject:@"凭证:"];
//                                [self.dataMutArr addObject:@"等待买家确认"];//@"待审核 —— 等待买家确认(3小时内)"
//                                [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_print ReplaceStr:@""]];
//                                NSLog(@"");
//                //                        [self.sureBtn setTitle:@"发货"
//                //                                      forState:UIControlStateNormal];
//                //                        [self.sureBtn addTarget:self
//                //                                    action:@selector(boothDeliver_networking)//喵粮抢摊位发货
//                //                          forControlEvents:UIControlEventTouchUpInside];//#21
//                                NSLog(@"");
//                            }else if ([self.orderListModel.del_state intValue] == 2){//确定取消了 //撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
//                                [self.dataMutArr addObject:@"已通过"];
//                            }else if ([self.orderListModel.del_state intValue] == 3){//撤销被驳回 或者 发货了//撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
//                                //订单状态显示为 已驳回
//                                [self.dataMutArr addObject:@"已驳回"];
//                            }else{
//                                [self.dataMutArr addObject:@""];
//                            }
//                        }
//                    }//搜索
//                    else if (self.orderListModel.order_type.intValue == 3){//喵粮产地
//                        if (self.orderListModel.order_status.intValue == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                            if ([self.orderListModel.del_state intValue] == 0) {
//                            [self.dataMutArr addObject:@"已下单"];//333
//                            self.time = 3;
//                            self.titleEndStr = @"取消";
//                            self.titleBeginStr = @"取消";
//                //                    [self.countDownCancelBtn addTarget:self
//                //                                                action:@selector(cancelOrder_producingArea_netWorking)
//                //                                      forControlEvents:UIControlEventTouchUpInside];//#9
//                            [self.normalCancelBtn setTitle:@"取消"
//                                                    forState:UIControlStateNormal];
//                            [self.normalCancelBtn addTarget:self
//                                                    action:@selector(cancelOrder_producingArea_netWorking)// 喵粮产地购买取消
//                                        forControlEvents:UIControlEventTouchUpInside];//#9
//                            //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
//                            if ([self.orderListModel.del_state intValue] == 0) {
//                                [self.sureBtn setTitle:@"上传支付凭证"//
//                                              forState:UIControlStateNormal];
//                            }
//                            [self.sureBtn addTarget:self
//                                             action:@selector(getPrintPic:)
//                                   forControlEvents:UIControlEventTouchUpInside];//CatfoodCO_payURL 喵粮产地购买已支付  #8
//                            }
//                        }else if (self.orderListModel.order_status.intValue == 0){//订单状态|已支付 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成 显示凭证
////                            [self.dataMutArr addObject:@"已支付"];//🏳️
//                            if (self.orderManager_producingAreaModel.payment_print) {
//                                [self.titleMutArr addObject:@"支付凭证"];
//                                [self.dataMutArr addObject:self.orderManager_producingAreaModel.payment_print];
//                            }
//                            
//                        //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
//                            if ([self.orderManager_producingAreaModel.del_state intValue] == 0) {
//                                [self.reloadPicBtn setTitle:@"重新上传支付凭证"
//                                                   forState:UIControlStateNormal];
//                                [self.reloadPicBtn sizeToFit];
//                                self.reloadPicBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//                                [self.reloadPicBtn addTarget:self
//                                          action:@selector(getPrintPic:)
//                                forControlEvents:UIControlEventTouchUpInside];//CatfoodCO_payURL 喵粮产地购买已支付  #8
//                            }
//                        }else{}
//                    }//平台
//                    else{}
//                }//如果 这个页面是从 搜索过来的
//                else{}
//
//                [self.titleMutArr addObject:@"下单时间:"];
//                [self.titleMutArr addObject:@"订单状态:"];
//                
//                [self.dataMutArr addObject:[NSString ensureNonnullString:model.updateTime ReplaceStr:@"暂无"]];//下单时间
//                //状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                if ([model.order_status intValue] == 0) {//已支付
//                     [self.dataMutArr addObject:@"已支付"];
//                }else if ([model.order_status intValue] == 1){//已发单
//                     [self.dataMutArr addObject:@"已发单"];
//                }else if ([model.order_status intValue] == 2){//已下单
//                    ////撤销状态 0、不影响（驳回）;1、待审核;2、已通过
//                    if (model.del_state.intValue == 0) {
//                        [self.dataMutArr addObject:@"已下单"];
//                    }else if (model.del_state.intValue == 1){
//                        [self.dataMutArr addObject:@"待审核"];
//                    }else if (model.del_state.intValue == 2){
//                        [self.dataMutArr addObject:@"已通过"];
//                    }else{
//                        [self.dataMutArr addObject:@"已下单"];
//                    }
//                }else if ([model.order_status intValue] == 3){//已作废
//                     [self.dataMutArr addObject:@"已作废"];
//                }else if ([model.order_status intValue] == 4){//已发货
//                     [self.dataMutArr addObject:@"已发货"];
//                }else if ([model.order_status intValue] == 5){//已完成
//                     [self.dataMutArr addObject:@"已完成"];
//                }else{
//                    [self.dataMutArr addObject:@"状态异常"];
//                }
//
////OrderDetailModel 和 OrderManager_panicBuyingModel 是同一个
//                
//#warning 倒计时数据源 OrderDetailModel
//                if (model.del_state.intValue == 1 &&//撤销状态 0、不影响（驳回）;1、待审核;2、已通过
//                    model.order_status.intValue == 2) {//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
//                    [self.dataMutArr removeLastObject];
//                    self.viewForHeader.tipsBtn.alpha = 1;
//                    
////                    if ([model isKindOfClass:[OrderDetailModel class]]) {
////                        OrderDetailModel *orderDetailModel = (OrderDetailModel *)model;
////                        self.orderDetailModel.del_state = orderDetailModel.del_state;
////                        NSLog(@"");
////                    }
//                    //计算两个时间的相隔
//                    NSDateFormatter *formatter = NSDateFormatter.new;
//                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                    NSNumber *timer = [NSNumber numberWithDouble:model.del_wait_left_time.floatValue / 1000];
//                    [self.dataMutArr addObject:[NSString stringWithFormat:@"等待买家确认 %@",timer.stringValue]];
//                }
//                
//                if (![NSString isNullString:model.payment_print]) {
//                    [self.titleMutArr addObject:@"凭证:"];
//                    [self.dataMutArr addObject:model.payment_print];
//                }
//
//            }
//            self.tableView.mj_footer.hidden = NO;
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//            [self.tableView reloadData];
//        }

@end

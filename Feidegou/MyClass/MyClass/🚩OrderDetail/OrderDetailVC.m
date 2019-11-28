//
//  OrderDetailVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/17.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailVC+VM.h"
#import "UpLoadCancelReasonVC.h"
#import "OrderDetailTBViewForHeader.h"
//凭证
@interface OrderDetailTBVIMGCell ()

@property(nonatomic,strong)UIImageView *imgV;

@end

//订单、单价、总价、账号、支付方式、参考号、下单时间
@interface OrderDetailTBVCell ()

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

#pragma mark —— OrderDetailVC
@interface OrderDetailVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,copy)NSString *titleEndStr;
@property(nonatomic,copy)NSString *titleBeginStr;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,strong)UIViewController *rootVC;

@end

@implementation OrderDetailVC

//上个页面给数据，本页面手动的刷新
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [_contactBuyer.timer invalidate];
    [_countDownCancelBtn.timer invalidate];
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderDetailVC *vc = OrderDetailVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.isFirstComing = YES;
    vc.rootVC = rootVC;
    if ([vc.requestParams isKindOfClass:[OrderListModel class]]) {//订单管理 子页面共用一个model 进
        vc.orderListModel = (OrderListModel *)vc.requestParams;
        vc.Order_id = vc.orderListModel.ID;
    }else if ([vc.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){//喵粮产地页面进
        vc.catFoodProducingAreaModel = (CatFoodProducingAreaModel *)vc.requestParams;
        vc.Order_id = vc.catFoodProducingAreaModel.ID;
    }else if ([vc.requestParams isKindOfClass:[StallListModel class]]){//摊位 喵粮直通车页面进
        vc.stallListModel = (StallListModel *)vc.requestParams;
        vc.Order_id = vc.stallListModel.ID;
    }else{}
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isFirstComing) {
        [self data];
        self.isFirstComing = NO;
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark —— 私有方法
-(void)data{
    if (self.orderListModel) {
        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"stallListModel厂家%@购买%@g喵粮",str1,str2];
            if ([self.orderListModel.order_type intValue] == 1) {//直通车 只有卖家 订单类型 1、直通车;2、批发;3、平台
                self.gk_navTitle = @"直通车订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    if ([self.orderListModel.del_state intValue] == 0) {//0状态 0、不影响;1、待审核;2、已通过 3、驳回
                        [self.dataMutArr addObject:@"已下单"];
                        //去请求 #22-2 获取最新时间
                        [self CatfoodBooth_del_time_netWorking];//#22-2
                        [self.sureBtn setTitle:@"发货"
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                    action:@selector(boothDeliver_networking)//喵粮抢摊位发货
                          forControlEvents:UIControlEventTouchUpInside];//#21
                    }else if ([self.orderListModel.del_state intValue] == 1){//在审核中/买家确认中  0、不影响;1、待审核;2、已通过 3、驳回
                        //3小时内，等待买家确认 倒计时
                        //去请求 #22-2 获取最新时间
                        [self CatfoodBooth_del_time_netWorking];//#22-2 喵粮抢摊位取消剩余时间
                        [self.dataMutArr addObject:@"等待买家确认(3小时内)"];
                    }else if ([self.orderListModel.del_state intValue] == 2){//确定取消了 //撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
                        [self.dataMutArr addObject:@"订单已取消"];
                    }else if ([self.orderListModel.del_state intValue] == 3){//撤销被驳回 或者 发货了//撤销状态 0、不影响;1、待审核;2、已通过 3、驳回
                        //订单状态显示为 已驳回
                        [self.dataMutArr addObject:@"订单已驳回"];
                    }else{
                        [self.dataMutArr addObject:@""];
                    }
                }else if ([self.orderListModel.order_status intValue] == 5){//订单状态|已完成 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已完成"];
                }else if ([self.orderListModel.order_status intValue] == 4){//订单状态|已发货 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已发货"];
                }else{
                    [self.dataMutArr addObject:@"数据异常"];
                }
            }
            else if ([self.orderListModel.order_type intValue] == 2){//批发 订单类型 1、直通车;2、批发;3、平台 允许重新上传图片
                //先判断是买家还是卖家 deal :1、买；2、卖
                if ([self.orderListModel.identity isEqualToString:@"买家"]) {
                    self.gk_navTitle = @"批发（买家）订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单  —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                        [self.dataMutArr addObject:@"已下单"];//
                        [self.normalCancelBtn setTitle:@"取消"
                                        forState:UIControlStateNormal];
                        [self.normalCancelBtn addTarget:self
                                                 action:@selector(normalCancelBtnClickEvent:)//喵粮批发取消
                                       forControlEvents:UIControlEventTouchUpInside];//#18
//                        订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
                        if ([self.orderListModel.del_state intValue] == 0) {
                            if ([self.orderListModel.order_status intValue] == 2) {
                                [self.sureBtn setTitle:@"上传支付凭证"//
                                              forState:UIControlStateNormal];
                            }else if ([self.orderListModel.order_status intValue] == 0){
                                [self.sureBtn setTitle:@"重新上传支付凭证"//
                                              forState:UIControlStateNormal];
                            }
                        }
                        [self.sureBtn addTarget:self
                                         action:@selector(getPrintPic:)//CatfoodSale_payURL 喵粮批发已支付 #17
                               forControlEvents:UIControlEventTouchUpInside];//#17
                    }else if([self.orderListModel.order_status intValue] == 0){//订单状态|已支付  —— 显示凭证 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                        [self.sureBtn setTitle:@"重新上传支付凭证"//🏳️
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                         action:@selector(getPrintPic:)
                               forControlEvents:UIControlEventTouchUpInside];//CatfoodSale_payURL 喵粮批发已支付 #17
                        [self.dataMutArr addObject:@"已支付"];
                    }else{
                        [self.dataMutArr addObject:@"数据异常"];
                    }
                }else if([self.orderListModel.identity isEqualToString:@"卖家"]){
                    self.gk_navTitle = @"批发（卖家）订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                        [self.dataMutArr addObject:@"订单已下单"];//5s 取消 22 1
                        [self.normalCancelBtn setTitle:@"取消"
                                           forState:UIControlStateNormal];
                        [self.normalCancelBtn addTarget:self
                                              action:@selector(normalCancelBtnClickEvent:)//喵粮批发取消
                                            forControlEvents:UIControlEventTouchUpInside];//18
                    }else if ([self.orderListModel.order_status intValue] == 0){//订单状态|已支付 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                        [self.dataMutArr addObject:@"订单已支付"];//21 23_1 1
                        //显示凭证
                        [self.titleMutArr addObject:@"凭证"];
                        [self.dataMutArr addObject:self.orderListModel.payment_print];//凭证图像地址
                        NSTimeInterval time = [NSString timeIntervalstartDate:self.stallListModel.updateTime
                                                                      endDate:nil
                                                                timeFormatter:nil];
                        self.time = 5 * 60 - time;
                        self.titleEndStr = @"撤销";
                        self.titleBeginStr = @"撤销";
                        self.countDownCancelBtn.titleEndStr = @"撤销";//显示凭证
                        [self.countDownCancelBtn addTarget:self
                                                    action:@selector(CancelDelivery_NetWorking)//喵粮订单撤销
                                          forControlEvents:UIControlEventTouchUpInside];//#5
                        [self.sureBtn setTitle:@"立即发货"
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                         action:@selector(deliver_wholesaleMarket_PNetworking)//喵粮批发订单发货
                               forControlEvents:UIControlEventTouchUpInside];//#14
                    }else if ([self.orderListModel.order_status intValue] == 3){//订单状态|已作废 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                        [self.dataMutArr addObject:@"订单已作废"]; //23_6
                    }else{
                        [self.dataMutArr addObject:@"数据异常"];
                    }
                }
            }
            else if ([self.orderListModel.order_type intValue] == 3){//产地 只有买家 订单类型 1、直通车;2、批发;3、平台 允许重新上传图片
                self.gk_navTitle = @"产地订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//订单状态|已下单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已下单"];//333
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
                }else if ([self.orderListModel.order_status intValue] == 0){//订单状态|已支付 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成 显示凭证
                    [self.dataMutArr addObject:@"订单已支付"];//🏳️
                    //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
                    if ([self.orderListModel.del_state intValue] == 0) {
                        [self.sureBtn setTitle:@"重新上传支付凭证"
                                      forState:UIControlStateNormal];
                    }
                    [self.sureBtn addTarget:self
                                     action:@selector(getPrintPic:)
                           forControlEvents:UIControlEventTouchUpInside];//CatfoodCO_payURL 喵粮产地购买已支付  #8
                }else if ([self.orderListModel.order_status intValue] == 1){//订单状态|已发单 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已发单"];//311
                }else if ([self.orderListModel.order_status intValue] == 4){//订单状态|已发货 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已发货"];//1111
                }else if ([self.orderListModel.order_status intValue] == 5){//订单状态|已完成 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                    [self.dataMutArr addObject:@"订单已完成"];
                }else{
                    [self.dataMutArr addObject:@"数据异常"];
                }
            }else{}
        if (![NSString isNullString:self.orderListModel.payment_print]) {
            [self.titleMutArr addObject:@"凭证"];
            [self.dataMutArr addObject:self.orderListModel.payment_print];
        }
    }
    else if (self.catFoodProducingAreaModel){//喵粮产地
        NSString *str1 = [NSString ensureNonnullString:self.catFoodProducingAreaModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.catFoodProducingAreaModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
        self.gk_navTitle = @"产地订单详情";
        //只有3秒取消、发货、状态为已下单
        [self.dataMutArr addObject:@"订单已下单"];//
        self.time = 3;
        self.titleEndStr = @"取消";
        self.titleBeginStr = @"取消";
        [self.countDownCancelBtn addTarget:self
                                    action:@selector(cancelOrder_producingArea_netWorking)//喵粮产地购买取消
                          forControlEvents:UIControlEventTouchUpInside];//#9
        //订单详情上传凭证的订单状态：del_state = 0，order_status = 2;重新上传凭证，del_state = 0,order_status = 0
        if ([self.catFoodProducingAreaModel.del_state intValue] == 0) {
            if ([self.catFoodProducingAreaModel.order_status intValue] == 2) {
                [self.sureBtn setTitle:@"上传支付凭证"//
                              forState:UIControlStateNormal];
            }else if ([self.catFoodProducingAreaModel.order_status intValue] == 0){
                [self.sureBtn setTitle:@"重新上传支付凭证"//
                              forState:UIControlStateNormal];
            }else{}
        }
        [self.sureBtn addTarget:self
                         action:@selector(getPrintPic:)
               forControlEvents:UIControlEventTouchUpInside];//#7
        if (![NSString isNullString:self.catFoodProducingAreaModel.payment_print]) {
            [self.titleMutArr addObject:@"凭证"];
            [self.dataMutArr addObject:self.catFoodProducingAreaModel.payment_print];
        }
    }
    else if (self.stallListModel){//喵粮直通车 倒计时
        NSString *str1 = [NSString ensureNonnullString:self.stallListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.stallListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
        self.gk_navTitle = @"直通车订单详情";
        //只有3小时取消、发货、状态为已下单
        [self.dataMutArr addObject:@"订单已下单"];//333
        NSTimeInterval time = [NSString timeIntervalstartDate:self.stallListModel.updateTime
                                                      endDate:nil
                                                timeFormatter:nil];
        self.time = 3 * 60 - time;
        self.titleEndStr = @"取消";
        self.titleBeginStr = @"取消";
        [self.countDownCancelBtn addTarget:self
                                    action:@selector(CatfoodBooth_del_netWorking)//喵粮抢摊位取消
                          forControlEvents:UIControlEventTouchUpInside];//#21_1
        [self.sureBtn setTitle:@"发货"
                      forState:UIControlStateNormal];
        [self.sureBtn addTarget:self
                         action:@selector(boothDeliver_networking)//喵粮抢摊位发货
               forControlEvents:UIControlEventTouchUpInside];//#21
        if (![NSString isNullString:self.stallListModel.payment_print]) {
            [self.titleMutArr addObject:@"凭证"];
            [self.dataMutArr addObject:self.stallListModel.payment_print];
        }
    }else{
        [self.dataMutArr addObject:@"数据异常"];
    }
    if ([self.rootVC isKindOfClass:[SearchVC class]]) {
        self.gk_navTitle = @"搜索订单";
    }
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    
    if (self.titleMutArr.count) {
        [self.titleMutArr removeAllObjects];
    }
    
    //订单类型 —— 1、摊位;2、批发;3、产地
    if (self.orderListModel) {
            if ([self.orderListModel.order_type intValue] == 1) {
            if ([self.orderListModel.order_status intValue] == 2) {
                if ([self.orderListModel.del_state intValue] == 0) {//0、不影响;1、待审核;2、已通过 3、驳回
                    [self CatfoodBooth_del_time_netWorking];//喵粮抢摊位取消剩余时间
                }
            }
        }
        switch ([self.orderListModel.order_type intValue]) {
            case 1:{//摊位
                [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"摊位"];//喵粮订单查看 3小时
            }break;
            case 2:{//批发
                 [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"批发"];//喵粮订单查看 3小时
            }break;
            case 3:{//产地
                [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"产地"];//喵粮订单查看 3小时
            }break;
            default:
                break;
        }
    }else if (self.catFoodProducingAreaModel){
        [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"产地"];//喵粮订单查看 3小时
    }else if (self.stallListModel){
        [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@"摊位"];//喵粮订单查看 3小时
    }else{
//        [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:@""];//喵粮订单查看 3小时
    }
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
}
#pragma mark —— 点击事件
-(void)normalCancelBtnClickEvent:(UIButton *)sender{// 喵粮批发取消
    [self cancelOrder_wholesaleMarket_netWorking];
}
//上传支付凭证
-(void)getPrintPic:(UIButton *)sender{
    @weakify(self)
    [UpLoadCancelReasonVC ComingFromVC:self_weak_
                             withStyle:ComingStyle_PUSH
                         requestParams:self.requestParams
                               success:^(id data) {}
                              animated:YES];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    OrderDetailTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[OrderDetailTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                          withData:self.str];
        [viewForHeader headerViewWithModel:nil];
        @weakify(self)
        [viewForHeader actionBlock:^(id data) {
            @strongify(self)
            NSLog(@"联系");
            
#warning KKK
//            Toast(@"功能开发中,敬请期待...");
            
//            if ([requestParams isKindOfClass:[RCConversationModel class]]) {
//                RCConversationModel *model = (RCConversationModel *)requestParams;
//                vc.conversationType = model.conversationType;
//                vc.targetId = model.targetId;
//                vc.chatSessionInputBarControl.hidden = NO;
//                vc.title = @"想显示的会话标题";
//            }
            
            RCConversationModel *model = RCConversationModel.new;
            model.conversationType = ConversationType_PRIVATE;
            model.targetId = [NSString stringWithFormat:@"%@",self.orderListModel.seller];
            
            if (self.orderListModel) {
//                ChatListVC;
//                ChatVC;
                [ChatVC ComingFromVC:self_weak_
                           withStyle:ComingStyle_PUSH
                       requestParams:model
                             success:^(id data) {}
                            animated:YES];
            }
//            if (self.catFoodProducingAreaModel) {
//                self.catFoodProducingAreaModel.seller;
//            }
//            if (self.stallListModel) {
//                self.stallListModel.seller;
//            }
        }];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [OrderDetailTBViewForHeader headerViewHeightWithModel:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![NSString isNullString:self.orderListModel.payment_print] ||
    ![NSString isNullString:self.catFoodProducingAreaModel.payment_print] ||
    ![NSString isNullString:self.stallListModel.payment_print]) {
        if (indexPath.row == self.titleMutArr.count - 1) {
            return [OrderDetailTBVIMGCell cellHeightWithModel:nil];//凭证图
        }else return [OrderDetailTBVCell cellHeightWithModel:nil];
    }else return [OrderDetailTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"KKK = %lu",(unsigned long)self.titleMutArr.count);
    if (indexPath.row == self.titleMutArr.count - 1) {//最后一行
        if (![NSString isNullString:self.orderListModel.payment_print] ||
            ![NSString isNullString:self.catFoodProducingAreaModel.payment_print] ||
            ![NSString isNullString:self.stallListModel.payment_print]) {//有凭证数据
            OrderDetailTBVIMGCell *cell = [OrderDetailTBVIMGCell cellWith:tableView];//
            cell.textLabel.text = self.titleMutArr[indexPath.row];
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
            return cell;
        }else{//没有凭证数据，则显示正常的行
            OrderDetailTBVCell *cell = [OrderDetailTBVCell cellWith:tableView];//
            cell.textLabel.text = self.titleMutArr[indexPath.row];
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
            return cell;
        }
    }else{//其他正常的行
        OrderDetailTBVCell *cell = [OrderDetailTBVCell cellWith:tableView];//
        cell.textLabel.text = self.titleMutArr[indexPath.row];
        if (self.dataMutArr.count) {//最新数据
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
        }else{//原始数据
            if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
                
            }else if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){
                
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                
            }else{}
        }return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(VerifyCodeButton *)contactBuyer{
    if (!_contactBuyer) {
        _contactBuyer = VerifyCodeButton.new;
        _contactBuyer.showTimeType = ShowTimeType_HHMMSS;
        _contactBuyer.uxy_acceptEventInterval = 5;
        _contactBuyer.layerCornerRadius = 5.f;
        if (@available(iOS 8.2, *)) {
            _contactBuyer.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            // Fallback on earlier versions
        }
        _contactBuyer.clipsToBounds = YES;
        _contactBuyer.titleEndStr = self.titleEndStr;
        _contactBuyer.titleBeginStr = self.titleBeginStr;
        [_contactBuyer timeFailBeginFrom:self.time == 0 ? 10 : self.time];
        [self.tableView addSubview:_contactBuyer];
        [_contactBuyer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
        }];
    }return _contactBuyer;
}

-(VerifyCodeButton *)countDownCancelBtn{
    if (!_countDownCancelBtn) {
        _countDownCancelBtn = VerifyCodeButton.new;
        _countDownCancelBtn.showTimeType = ShowTimeType_HHMMSS;
        _countDownCancelBtn.layerCornerRadius = 5.f;
        _countDownCancelBtn.uxy_acceptEventInterval = 5;
        if (@available(iOS 8.2, *)) {
            _countDownCancelBtn.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            // Fallback on earlier versions
        }
        _countDownCancelBtn.titleEndStr = self.titleEndStr;
        _countDownCancelBtn.titleBeginStr = self.titleBeginStr;
        _countDownCancelBtn.clipsToBounds = YES;
        [_countDownCancelBtn timeFailBeginFrom:self.time == 0 ? 10 : self.time];
        [self.tableView addSubview:_countDownCancelBtn];
        [_countDownCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
        }];
    }return _countDownCancelBtn;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        _sureBtn.uxy_acceptEventInterval = 5;
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:3.f];
    }return _sureBtn;
}

-(UIButton *)normalCancelBtn{
    if (!_normalCancelBtn) {
        _normalCancelBtn = UIButton.new;
        _normalCancelBtn.uxy_acceptEventInterval = 5;
        [UIView cornerCutToCircleWithView:_normalCancelBtn
                          AndCornerRadius:3.f];
        _normalCancelBtn.backgroundColor = KLightGrayColor;
        [self.tableView addSubview:_normalCancelBtn];
        [_normalCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
        }];
    }return _normalCancelBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.contentInset = UIEdgeInsetsMake(0,
                                                   0,
                                                   100,
                                                   0);
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        if (self.orderListModel) {
            [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.ordercode ReplaceStr:@"无"]];//订单号
            [_dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//单价
            [_dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@"无"] stringByAppendingString:@" g"]];//数量
            [_dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.rental ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//总额
            switch ([self.orderListModel.payment_status intValue]) {//支付方式: 1、支付宝;2、微信;3、银行卡
                case 1:{
                    [_dataMutArr addObject:@"支付宝"];
                }break;
                case 2:{
                    [_dataMutArr addObject:@"微信"];
                }break;
                 case 3:{
                     [_dataMutArr addObject:@"银行卡"];
                 }break;
                default:
                    [_dataMutArr addObject:@"无支付方式"];
                    break;
            }
            //1、支付宝;2、微信;3、银行卡
            if ([self.orderListModel.payment_status intValue] == 3) {//银行卡
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankCard ReplaceStr:@"暂无信息"]];//银行卡号
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankUser ReplaceStr:@"暂无信息"]];//姓名
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankName ReplaceStr:@"暂无信息"]];//银行类型
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankaddress ReplaceStr:@"暂无信息"]];//支行信息
            }else if ([self.orderListModel.payment_status intValue] == 2){//微信
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_weixin ReplaceStr:@"无"]];
            }else if ([self.orderListModel.payment_status intValue] == 1){//支付宝
                [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_alipay ReplaceStr:@"无"]];
            }else{
                [_dataMutArr addObject:@"无支付账户"];
            }
            [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.updateTime ReplaceStr:@"无"]];//时间
        }else if (self.catFoodProducingAreaModel){
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.ordercode ReplaceStr:@"无"]];//订单号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.price ReplaceStr:@"无"]];//单价
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.quantity ReplaceStr:@"无"]];//数量
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.rental ReplaceStr:@"无"]];//总价
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankcard ReplaceStr:@"无"]];//银行卡号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankuser ReplaceStr:@"无"]];//姓名
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankName ReplaceStr:@"无"]];//银行类型
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankaddress ReplaceStr:@"无"]];//支行信息
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.updateTime ReplaceStr:@"无"]];//下单时间
        }else if (self.stallListModel){
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.ordercode ReplaceStr:@"无"]];//订单号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.price ReplaceStr:@"无"]];//单价
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.quantity ReplaceStr:@"无"]];//数量
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.rental ReplaceStr:@"无"]];//总价
            [_dataMutArr addObject:@"微信"];//支付方式
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.payment_weixin ReplaceStr:@"无"]];//微信账号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.updateTime ReplaceStr:@"无"]];//下单时间
        }else{}
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        if (self.orderListModel) {
            [_titleMutArr addObject:@"订单号:"];
            [_titleMutArr addObject:@"单价:"];
            [_titleMutArr addObject:@"数量:"];
            [_titleMutArr addObject:@"总价:"];
            [_titleMutArr addObject:@"支付方式:"];
            //1、支付宝;2、微信;3、银行卡
            if ([self.orderListModel.payment_status intValue] == 3) {//3、银行卡
                [_titleMutArr addObject:@"银行卡号:"];
                [_titleMutArr addObject:@"姓名:"];
                [_titleMutArr addObject:@"银行类型:"];
                [_titleMutArr addObject:@"支行信息:"];
            }else if ([self.orderListModel.payment_status intValue] == 2){//2、微信
                [_titleMutArr addObject:@"微信账号:"];
            }else if ([self.orderListModel.payment_status intValue] == 1){//1、支付宝
                [_titleMutArr addObject:@"支付宝账号:"];
            }else{
                [_titleMutArr addObject:@"异常:"];
            }
            [_titleMutArr addObject:@"下单时间:"];
            [_titleMutArr addObject:@"订单状态"];
        }else if (self.catFoodProducingAreaModel){//只允许银行卡
            [_titleMutArr addObject:@"订单号:"];
            [_titleMutArr addObject:@"单价:"];
            [_titleMutArr addObject:@"数量:"];
            [_titleMutArr addObject:@"总价:"];
            [_titleMutArr addObject:@"银行卡号:"];
            [_titleMutArr addObject:@"姓名:"];
            [_titleMutArr addObject:@"银行类型:"];
            [_titleMutArr addObject:@"支行信息:"];
            [_titleMutArr addObject:@"下单时间:"];
            [_titleMutArr addObject:@"订单状态"];
        }else if (self.stallListModel){//只允许微信
            [_titleMutArr addObject:@"订单号:"];
            [_titleMutArr addObject:@"单价:"];
            [_titleMutArr addObject:@"数量:"];
            [_titleMutArr addObject:@"总价:"];
            [_titleMutArr addObject:@"支付方式:"];
            [_titleMutArr addObject:@"微信账号:"];
            [_titleMutArr addObject:@"下单时间:"];
            [_titleMutArr addObject:@"订单状态"];
        }else{}
    }return _titleMutArr;
}

@end

@implementation OrderDetailTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell *cell = (OrderDetailTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.detailTextLabel.text = model;
}

@end

@implementation OrderDetailTBVIMGCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVIMGCell *cell = (OrderDetailTBVIMGCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVIMGCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = kRedColor;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(200);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)model;
        if (![NSString isNullString:str]) {
            @weakify(self)
            NSString *strw = [NSURL URLWithString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",str]]];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",str]]]
                                     options:SDWebImageDownloaderProgressiveDownload//渐进式下载
                                                                 progress:^(NSInteger receivedSize,
                                                                            NSInteger expectedSize,
                                                                            NSURL * _Nullable targetURL) {}
                                                                completed:^(UIImage * _Nullable image,
                                                                            NSData * _Nullable data,
                                                                            NSError * _Nullable error,
                                                                            BOOL finished) {
                @strongify(self)
                if (image) {
                    self.imgV.image = image;
                }else{
                    self.imgV.image = kIMG(@"picLoadErr");
                }
            }];
        }
    }
}

-(void)drawRect:(CGRect)rect{
    self.imgV.alpha = 1;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = UIImageView.new;
//        _imgV.backgroundColor = kRedColor;
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.mas_equalTo(self.mj_h - SCALING_RATIO(20));
            make.width.mas_equalTo(SCREEN_WIDTH / 2);
        }];
    }return _imgV;
}

@end

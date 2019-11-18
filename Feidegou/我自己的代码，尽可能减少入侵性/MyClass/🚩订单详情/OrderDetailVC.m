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

#pragma mark —— OrderDetailVC
@interface OrderDetailVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *normalCancel;

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)id popGestureDelegate; //用来保存系统手势的代理

@end

@implementation OrderDetailVC

//上个页面给数据，本页面手动的刷新
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [_contactBuyer.timer invalidate];
    [_countDownCancelBtn.timer invalidate];
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    OrderDetailVC *vc = OrderDetailVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;//OrderListModel
    if ([vc.requestParams isKindOfClass:[OrderListModel class]]) {//买家、卖家进
        vc.orderListModel = (OrderListModel *)vc.requestParams;
    }else if ([vc.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){//喵粮产地
        vc.catFoodProducingAreaModel = (CatFoodProducingAreaModel *)vc.requestParams;
    }else if ([vc.requestParams isKindOfClass:[StallListModel class]]){
        vc.stallListModel = (StallListModel *)vc.requestParams;
    }else{}
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
    [self data];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.orderListModel) {
        if ([self.orderListModel.order_type intValue] == 1) {
            if ([self.orderListModel.order_status intValue] == 2) {
                if ([self.orderListModel.del_state intValue] == 0) {
                    [self.tableView.mj_header beginRefreshing];
                }
            }
        }
    }else if (self.catFoodProducingAreaModel){
        
    }else if (self.stallListModel){
        
    }else{}
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark —— 私有方法
-(void)data{
    if (self.orderListModel) {
        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
            if ([self.orderListModel.order_type intValue] == 1) {//摊位 只有卖家
                self.gk_navTitle = @"摊位抢购订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {
                    if ([self.orderListModel.del_state intValue] == 0) {
                        NSLog(@"1311");
                        [self.dataMutArr addObject:@"已下单"];
                        //去请求 #22-2 获取最新时间
                        [self CatfoodBooth_del_time_netWorking];//#22-2
                        [self.sureBtn setTitle:@"发货"
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                    action:@selector(CatfoodBooth_del_netWorking)
                          forControlEvents:UIControlEventTouchUpInside];//#21
                    }else if ([self.orderListModel.del_state intValue] == 1){//在审核中/买家确认中
                        //3小时内，等待买家确认 倒计时
                        //去请求 #22-2 获取最新时间
                        [self CatfoodBooth_del_time_netWorking];//#22-2
                        [self.dataMutArr addObject:@"等待买家确认(3小时内)"];
                        NSLog(@"1312");
                    }else if ([self.orderListModel.del_state intValue] == 2){//确定取消了
                        NSLog(@"");
                        [self.dataMutArr addObject:@""];
                    }else if ([self.orderListModel.del_state intValue] == 3){//撤销被驳回 或者 发货了
                        NSLog(@"1314");
                        //订单状态显示为 已取消
                        [self.dataMutArr addObject:@"订单已取消"];
                    }else{
                        NSLog(@"");
                        [self.dataMutArr addObject:@""];
                    }
                }else if ([self.orderListModel.order_status intValue] == 5){
                    //已完成
                    NSLog(@"1316");
                    [self.dataMutArr addObject:@"订单已完成"];
                }else if ([self.orderListModel.order_status intValue] == 4){
                    NSLog(@"1315");
                    [self.dataMutArr addObject:@"订单已发货"];
                }else{}
            }
            else if ([self.orderListModel.order_type intValue] == 2){//批发 买家 & 卖家
                //先判断是买家还是卖家 deal :1、买；2、卖
                if ([self.orderListModel.identity isEqualToString:@"买家"]) {
                    self.gk_navTitle = @"批发市场（买家）订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {//已下单
                        [self.normalCancel setTitle:@"取消"
                                        forState:UIControlStateNormal];
                        [self.sureBtn setTitle:@"上传支付凭证"//
                                      forState:UIControlStateNormal];
                        [self.normalCancel addTarget:self
                                              action:@selector(cancelOrder_wholesaleMarket_netWorking)
                                    forControlEvents:UIControlEventTouchUpInside];//#18
                        [self.sureBtn addTarget:self
                                         action:@selector(upLoadPic_wholesaleMarket_havePaid_netWorking:)
                               forControlEvents:UIControlEventTouchUpInside];//#17
                    }else if([self.orderListModel.order_status intValue] == 0){//已支付
                        [self.sureBtn setTitle:@"重新上传支付凭证"//
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                         action:@selector(upLoadPic_wholesaleMarket_havePaid_netWorking:)
                               forControlEvents:UIControlEventTouchUpInside];//#17
                    }else{}
                }else if([self.orderListModel.identity isEqualToString:@"卖家"]){
                    self.gk_navTitle = @"批发市场（卖家）订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {
                        [self.dataMutArr addObject:@"订单已下单"];//5s 取消 22 1
                        [self.normalCancel setTitle:@"取消"
                                           forState:UIControlStateNormal];
                        
                        if ([self.orderListModel.order_status intValue] == 0) {
                            [self.normalCancel addTarget:self
                                                  action:@selector(CancelDelivery_NetWorking)
                                        forControlEvents:UIControlEventTouchUpInside];//18
                        }else if ([self.orderListModel.order_status intValue] == 2){
                            [self.normalCancel addTarget:self
                                                  action:@selector(cancelOrder_wholesaleMarket_netWorking)
                                        forControlEvents:UIControlEventTouchUpInside];//18
                        }else{}
                    }else if ([self.orderListModel.order_status intValue] == 0){//已支付
                        [self.dataMutArr addObject:@"订单已支付"];//21 23_1 1
                        //显示凭证
                        [self.titleMutArr addObject:@"凭证"];
                        [self.dataMutArr addObject:self.orderListModel.payment_print];//凭证图像地址
                        self.countDownCancelBtn.titleEndStr = @"撤销";//显示凭证
                        [self.countDownCancelBtn addTarget:self
                                                    action:@selector(CancelDelivery_NetWorking)
                                          forControlEvents:UIControlEventTouchUpInside];//#5
                        [self.sureBtn setTitle:@"立即发货"
                                      forState:UIControlStateNormal];
                        [self.sureBtn addTarget:self
                                         action:@selector(deliver_wholesaleMarket_PNetworking)
                               forControlEvents:UIControlEventTouchUpInside];//#14
                    }else if ([self.orderListModel.order_status intValue] == 3){//已取消
                        [self.dataMutArr addObject:@"订单已取消"]; //23_6
                    }else{}
                }
            }
            else if ([self.orderListModel.order_type intValue] == 3){//产地 只有买家
                self.gk_navTitle = @"喵粮产地订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//已下单
                    [self.dataMutArr addObject:@"订单已下单"];//333
                    self.countDownCancelBtn.titleEndStr = @"取消";
                    [self.countDownCancelBtn addTarget:self
                                                action:@selector(cancelOrder_producingArea_netWorking)
                                      forControlEvents:UIControlEventTouchUpInside];//#9
                    [self.sureBtn setTitle:@"上传支付凭证"
                                  forState:UIControlStateNormal];//上传支付凭证结束 改为 去支付
                    [self.sureBtn addTarget:self
                                     action:@selector(uploadPic_producingArea_havePaid_netWorking:)
                           forControlEvents:UIControlEventTouchUpInside];//#8
                }else if ([self.orderListModel.order_status intValue] == 0){//已支付
                    [self.dataMutArr addObject:@"订单已支付"];//444
                    [self.sureBtn setTitle:@"重新上传支付凭证"
                                  forState:UIControlStateNormal];
                    [self.sureBtn addTarget:self
                                     action:@selector(uploadPic_producingArea_havePaid_netWorking:)
                           forControlEvents:UIControlEventTouchUpInside];//#8
                }else if ([self.orderListModel.order_status intValue] == 1){
                    [self.dataMutArr addObject:@"订单已发单"];//311
                }else if ([self.orderListModel.order_status intValue] == 4){
                    [self.dataMutArr addObject:@"订单已发货"];//1111
                }else{}
            }else{}
    }else if (self.catFoodProducingAreaModel){//喵粮产地
        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
        self.gk_navTitle = @"喵粮产地订单详情";
        //只有10秒取消、发货、状态为已下单
        [self.dataMutArr addObject:@"订单已下单"];//333
        self.countDownCancelBtn.titleEndStr = @"取消";
        [self.countDownCancelBtn addTarget:self
                                    action:@selector(cancelOrder_producingArea_netWorking)
                          forControlEvents:UIControlEventTouchUpInside];//#9
        [self.sureBtn setTitle:@"购买"
                      forState:UIControlStateNormal];
        [self.sureBtn addTarget:self
                         action:@selector(netWorking)
               forControlEvents:UIControlEventTouchUpInside];//#7
    }else if (self.stallListModel){//喵粮抢购
        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
        //只有10秒取消、发货、状态为已下单
        [self.dataMutArr addObject:@"订单已下单"];//333
        self.countDownCancelBtn.titleEndStr = @"取消";
        [self.countDownCancelBtn addTarget:self
                                    action:@selector(CatfoodBooth_del_netWorking)
                          forControlEvents:UIControlEventTouchUpInside];//#21_1
        [self.sureBtn setTitle:@"发货"
                      forState:UIControlStateNormal];
        [self.sureBtn addTarget:self
                         action:@selector(boothDeliver_networking)
               forControlEvents:UIControlEventTouchUpInside];//#21
    }else{}
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    
    if (self.orderListModel) {
            if ([self.orderListModel.order_type intValue] == 1) {
            if ([self.orderListModel.order_status intValue] == 2) {
                if ([self.orderListModel.del_state intValue] == 0) {
                    [self CatfoodBooth_del_time_netWorking];
                }
            }
        }
        [self buyer_CatfoodRecord_checkURL_NetWorking];
    }else if (self.catFoodProducingAreaModel){
        [self buyer_CatfoodRecord_checkURL_NetWorking];
    }else if (self.stallListModel){
        [self buyer_CatfoodRecord_checkURL_NetWorking];
    }else{
        [self buyer_CatfoodRecord_checkURL_NetWorking];
    }
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self buyer_CatfoodRecord_checkURL_NetWorking];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    OrderDetailTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[OrderDetailTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                          withData:self.str];
        @weakify(self)
        [viewForHeader actionBlock:^(id data) {
            @strongify(self)
            NSLog(@"联系");
            Toast(@"功能开发中,敬请期待...");
        }];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(50);
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.orderListModel.order_type intValue] == 2) {
        if ([self.orderListModel.identity isEqualToString:@"卖家"]) {
            if ([self.orderListModel.order_status intValue] == 0) {
                if (indexPath.row == 9) {
                    return [OrderDetailTBVIMGCell cellHeightWithModel:nil];
                }
            }
        }
    }return [OrderDetailTBVCell cellHeightWithModel:nil];
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
    if ([self.orderListModel.order_type intValue] == 2 &&
        [self.orderListModel.identity isEqualToString:@"卖家"] &&
        [self.orderListModel.order_status intValue] == 0 &&
        indexPath.row == 9) {//凭证图片
        OrderDetailTBVIMGCell *cell = [OrderDetailTBVIMGCell cellWith:tableView];//
        cell.textLabel.text = self.titleMutArr[indexPath.row];
        if (self.dataMutArr.count) {//最新数据
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
        }else{//原始数据
            if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
                
            }else if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){
                
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                
            }else{}
        }return cell;
    }else{//其他
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
        _contactBuyer.layerCornerRadius = 5.f;
        if (@available(iOS 8.2, *)) {
            _contactBuyer.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            // Fallback on earlier versions
        }
        _contactBuyer.clipsToBounds = YES;
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
        _countDownCancelBtn.showTimeType = ShowTimeType_SS;;
        _countDownCancelBtn.layerCornerRadius = 5.f;
        if (@available(iOS 8.2, *)) {
            _countDownCancelBtn.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            // Fallback on earlier versions
        }
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
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:3.f];
    }return _sureBtn;
}

-(UIButton *)normalCancel{
    if (!_normalCancel) {
        _normalCancel = UIButton.new;
        [UIView cornerCutToCircleWithView:_normalCancel
                          AndCornerRadius:3.f];
        _normalCancel.backgroundColor = KLightGrayColor;
        [self.tableView addSubview:_normalCancel];
        [_normalCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(50)));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
        }];
    }return _normalCancel;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
            [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"]];//订单号
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
            [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.refer ReplaceStr:@"无"]];//参考号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.updateTime ReplaceStr:@"无"]];//时间
        }else if (self.catFoodProducingAreaModel){
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.ID ReplaceStr:@"无"]];//订单号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.price ReplaceStr:@"无"]];//单价
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.quantity ReplaceStr:@"无"]];//数量
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.rental ReplaceStr:@"无"]];//总价
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankcard ReplaceStr:@"无"]];//银行卡号
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankuser ReplaceStr:@"无"]];//姓名
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankName ReplaceStr:@"无"]];//银行类型
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.bankaddress ReplaceStr:@"无"]];//支行信息
            [_dataMutArr addObject:[NSString ensureNonnullString:self.catFoodProducingAreaModel.updateTime ReplaceStr:@"无"]];//下单时间
        }else if (self.stallListModel){
            [_dataMutArr addObject:[NSString ensureNonnullString:self.stallListModel.ID ReplaceStr:@"无"]];//订单号
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
            [_titleMutArr addObject:@"参考号:"];
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

//订单、单价、总价、账号、支付方式、参考号、下单时间
@interface OrderDetailTBVCell ()

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

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

//凭证
@interface OrderDetailTBVIMGCell ()

@property(nonatomic,strong)UIImageView *imgV;

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
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[BaseUrl2 stringByAppendingString:[NSString stringWithFormat:@"/%@",str]]]
                                     options:SDWebImageDownloaderProgressiveDownload//渐进式下载
                                                                 progress:^(NSInteger receivedSize,
                                                                            NSInteger expectedSize,
                                                                            NSURL * _Nullable targetURL) {}
                                                                completed:^(UIImage * _Nullable image,
                                                                            NSData * _Nullable data,
                                                                            NSError * _Nullable error,
                                                                            BOOL finished) {
                @strongify(self)
                self.imgV.image = image;
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
        _imgV.backgroundColor = KYellowColor;
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.mas_equalTo(self.mj_h - SCALING_RATIO(20));
            make.width.mas_equalTo(SCREEN_WIDTH / 2);
        }];
    }return _imgV;
}

@end

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

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)id popGestureDelegate; //用来保存系统手势的代理
@property(nonatomic,assign)int time;


@end

@implementation OrderDetailVC

//上个页面给数据，本页面手动的刷新
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [_contactBuyer.timer invalidate];
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    OrderDetailVC *vc = OrderDetailVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;//OrderListModel
    if ([vc.requestParams isKindOfClass:[OrderListModel class]]) {
        vc.orderListModel = (OrderListModel *)vc.requestParams;
    }
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
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    
    if (self.orderListModel) {
        
        NSString *str1 = [NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"];
        NSString *str2 = [NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@""];
        self.str = [NSString stringWithFormat:@"您向厂家%@购买%@g喵粮",str1,str2];
        
            if ([self.orderListModel.order_type intValue] == 1) {//摊位 只有卖家
                self.gk_navTitle = @"卖家订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//已抢、已下单
                    if ([self.orderListModel.del_state intValue] == 0) {//
                        //订单状态显示为 已下单
                        NSLog(@"1311");
                        [self.dataMutArr addObject:@"已下单"];
                        [self.cancelBtn setTitle:@"取消"
                                        forState:UIControlStateNormal];
                        [self.sureBtn setTitle:@"发货"//
                                      forState:UIControlStateNormal];
                    }else if ([self.orderListModel.del_state intValue] == 1){//在审核中/买家确认中
                        //3小时内，等待买家确认 倒计时
    //                    self.contactBuyer.alpha = 1;
                        [self.dataMutArr addObject:@"等待买家确认(3小时内)"];
                        NSLog(@"1312");
                        [self buyer_CatfoodRecord_checkURL_NetWorking];
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
            }else if ([self.orderListModel.order_type intValue] == 2){//批发 买家 & 卖家
                //先判断是买家还是卖家 deal :1、买；2、卖
                if ([self.orderListModel.deal intValue] == 1) {//买
                    self.gk_navTitle = @"买家订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {//已下单
                        [self.cancelBtn setTitle:@"取消"
                                        forState:UIControlStateNormal];
                        [self.sureBtn setTitle:@"上传支付凭证"//
                                      forState:UIControlStateNormal];
                    }else if([self.orderListModel.order_status intValue] == 0){//已支付
                        [self.sureBtn setTitle:@"重新上传支付凭证"//
                                      forState:UIControlStateNormal];
                    }else{}
                }else if([self.orderListModel.deal intValue] == 2){//卖
                    self.gk_navTitle = @"卖家订单详情";
                    if ([self.orderListModel.order_status intValue] == 2) {
                        //不管
                    }else if ([self.orderListModel.order_status intValue] == 0){//已支付
                        [self.cancelBtn setTitle:@"撤销"// .. tips
                                        forState:UIControlStateNormal];
                        [self.sureBtn setTitle:@"立即发货"
                                      forState:UIControlStateNormal];
                    }else{}
                }
            }else if ([self.orderListModel.order_type intValue] == 3){//产地 只有买家
                self.gk_navTitle = @"买家订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//已下单
                    [self.cancelBtn setTitle:@"上传撤销凭证"
                                    forState:UIControlStateNormal];
                    [self.sureBtn setTitle:@"上传支付凭证"
                                  forState:UIControlStateNormal];
                }else if ([self.orderListModel.order_status intValue] == 0){//已支付
                    [self.sureBtn setTitle:@"重新上传支付凭证"
                                  forState:UIControlStateNormal];
                }else{}
            }else{}
        }
    self.tableView.alpha = 1;
//    #
//    self.time = 8;
//    self.contactBuyer.alpha = 1;
//    self.cancelBtn.alpha = 0;
//    [self buyer_CatfoodRecord_checkURL_NetWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.orderListModel.order_type intValue] == 1) {
        if ([self.orderListModel.order_status intValue] == 2) {
            if ([self.orderListModel.del_state intValue] == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark —— 私有方法
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    if ([self.orderListModel.order_type intValue] == 1) {
        if ([self.orderListModel.order_status intValue] == 2) {
            if ([self.orderListModel.del_state intValue] == 0) {
                [self CatfoodBooth_del_time_netWorking];
            }
        }
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self netWorking];
}
#pragma mark —— 点击事件
-(void)contactBuyerClickEvent:(VerifyCodeButton *)sender{
    NSLog(@"倒计时结束，联系买家");//22_1
    [self CatfoodBooth_del_netWorking];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tips:(UIButton *)sender{
    if ([sender isEqual:self.cancelBtn]) {//取消按钮
        if ([sender.titleLabel.text isEqualToString:@"撤销"]) {
            //选择撤销理由
            self.BRStringPickerViewDataMutArr = @[@"请选择取消原因",
                                                  @"未收到款项",
                                                  @"收到了,但是款项不符"];
            @weakify(self)
            [self BRStringPickerViewBlock:^(id data) {
                @strongify(self)
                if ([data isKindOfClass:[BRResultModel class]]) {
                    BRResultModel *resultModel = (BRResultModel *)data;
                    self.resultStr = resultModel.selectValue;
                    [UpLoadCancelReasonVC pushFromVC:self_weak_
                                       requestParams:@{
                                           @"OrderListModel":self.requestParams,
                                           @"Result":self.resultStr,//撤销理由
                                       }
                                             success:^(id data) {}
                                            animated:YES];
                }
            }];
            [self.stringPickerView show];
        }else{
            [self showAlertViewTitle:sender.titleLabel.text
                   message:@""
               btnTitleArr:@[@"取消",
                             @"手滑，点错了"]
            alertBtnAction:@[@"cancelBtnClickEvent",//取消
                             @"Cancel"]];//取消
        }
    }else if ([sender isEqual:self.sureBtn]){//GOon
        if ([sender.titleLabel.text containsString:@"凭证"]) {//上传撤销凭证 上传支付凭证 重新上传支付凭证
            [self choosePic];
            @weakify(self)
            [self GettingPicBlock:^(id data) {
                @strongify(self)
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *arrData = (NSArray *)data;
                    if (arrData.count == 1) {
                        self.pic = arrData.lastObject;
                    }else{
                        [self showAlertViewTitle:@"选择一张相片就够啦"
                               message:@"不要画蛇添足"
                           btnTitleArr:@[@"好的"]
                        alertBtnAction:@[@"OK"]];
                    }
                }
            }];
        }else{
            [self showAlertViewTitle:sender.titleLabel.text
                             message:@""
                         btnTitleArr:@[@"我已确认",
                                       @"手滑，点错了"]
                      alertBtnAction:@[@"sureBtnClickEvent",//继续
                                       @"Cancel"]];//取消
        }
    }else{}
}

-(void)cancelBtnClickEvent{
    if(self.orderListModel){
        if ([self.orderListModel.order_type intValue] == 1) {//摊位
            if ([self.orderListModel.order_status intValue] == 2) {
                if ([self.orderListModel.del_state intValue] == 0) {
                    //5分钟以后才可以进行取消 22-2
                }
            }
        }else if ([self.orderListModel.order_type intValue] == 2) {//批发
            if ([self.orderListModel.deal intValue] == 1) {//买
                if ([self.orderListModel.order_status intValue] == 2) {//#18
                    [self cancelOrder_wholesaleMarket_netWorking];
                }
            }else if ([self.orderListModel.deal intValue] == 2){//卖
                if ([self.orderListModel.order_status intValue] == 0) {//#5
                    [self CancelDelivery_NetWorking];
                }
            }else{}
        }else if ([self.orderListModel.order_type intValue] == 3){//产地
            if ([self.orderListModel.order_status intValue] == 2) {//#9
                [self cancelOrder_producingArea_netWorking];
            }
        }else{}
    }
}

-(void)sureBtnClickEvent{
    if (self.orderListModel) {
        if ([self.orderListModel.order_type intValue] == 1) {//摊位
            if ([self.orderListModel.order_status intValue] == 2) {
                if ([self.orderListModel.del_state intValue] == 0) {
                    //#21 发货
                }
            }
        }else if ([self.orderListModel.order_type intValue] == 2) {//批发
            if ([self.orderListModel.deal intValue] == 1) {//买
                if ([self.orderListModel.order_status intValue] == 2) {//#17
                    [self upLoadPic_wholesaleMarket_havePaid_netWorking:self.pic];
                }else if ([self.orderListModel.order_status intValue] == 0){//#17
                    [self upLoadPic_wholesaleMarket_havePaid_netWorking:self.pic];
                }else{}
            }else if([self.orderListModel.deal intValue] == 2){//卖
                if ([self.orderListModel.order_status intValue] == 0) {//#14
                    [self deliver_wholesaleMarket_PNetworking];
                }
            }else{}
        }else if ([self.orderListModel.order_type intValue] == 3){//产地
            if ([self.orderListModel.order_status intValue] == 2) {//#8
                [self uploadPic_producingArea_havePaid_netWorking:self.pic];
            }else if ([self.orderListModel.order_status intValue] == 0){//#8
                [self uploadPic_producingArea_havePaid_netWorking:self.pic];
            }
        }else{}
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    OrderDetailTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[OrderDetailTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                          withData:self.str];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(50);
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderDetailTBVCell cellHeightWithModel:nil];
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
    OrderDetailTBVCell *cell = [OrderDetailTBVCell cellWith:tableView];//
    cell.textLabel.text = self.titleMutArr[indexPath.row];
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    }else{
        if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
        }
    }return cell;
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
        [_contactBuyer timeFailBeginFrom:self.time];
        [_contactBuyer addTarget:self
                       action:@selector(contactBuyerClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_contactBuyer];
        [_contactBuyer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
        }];
    }return _contactBuyer;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        _sureBtn.backgroundColor = kOrangeColor;
        [_sureBtn addTarget:self
                     action:@selector(tips:)
           forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:3.f];
    }return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn addTarget:self
                       action:@selector(tips:)
             forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:3.f];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(80)));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
        }];
    }return _cancelBtn;
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
//        [_tableView registerClass:[OrderDetailTBViewForHeader class] forHeaderFooterViewReuseIdentifier:@"KJHG"];
        
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
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"订单号:"];
        [_titleMutArr addObject:@"单价:"];
        [_titleMutArr addObject:@"数量:"];
        [_titleMutArr addObject:@"总价:"];
        [_titleMutArr addObject:@"支付方式:"];
        if ([self.orderListModel.payment_status intValue] == 3) {//1、支付宝;2、微信;3、银行卡
            [_titleMutArr addObject:@"银行卡号:"];
            [_titleMutArr addObject:@"姓名:"];
            [_titleMutArr addObject:@"银行类型:"];
            [_titleMutArr addObject:@"支行信息:"];
        }else{
            [_titleMutArr addObject:@"账号:"];
        }
        [_titleMutArr addObject:@"参考号:"];
        [_titleMutArr addObject:@"下单时间:"];
        [_titleMutArr addObject:@"订单状态"];
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

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
#import "AdvertiseStartController.h"

#import"SDImageCache.h"

//凭证
@interface OrderDetailTBVIMGCell ()

@property(nonatomic,strong)UIImageView *imgV;

@end

//订单、单价、总价、账号、支付方式、参考号、下单时间
@interface OrderDetailTBVCell ()

@property(nonatomic,assign)int time;

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
@property(nonatomic,strong)UIViewController *rootVC;

@end

@implementation OrderDetailVC

//上个页面给数据，本页面手动的刷新
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
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
    vc.rootVC = rootVC;
    if ([vc.requestParams isKindOfClass:[SearchOrderListModel class]]) {//搜索页面进
        vc.orderListModel = (SearchOrderListModel *)vc.requestParams;
        vc.Order_id = vc.orderListModel.ID;
        vc.Order_type = vc.orderListModel.order_type;
        NSLog(@"我从搜索页面来，order_id = %d,order_type = %d",vc.Order_id.intValue,vc.Order_type.intValue);
    }else if ([vc.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){//喵粮产地页面进
        vc.catFoodProducingAreaModel = (CatFoodProducingAreaModel *)vc.requestParams;
        vc.Order_id = vc.catFoodProducingAreaModel.ID;
        vc.Order_type = vc.catFoodProducingAreaModel.order_type;
        vc.catFoodProducingAreaModel.isSelect = YES;
        NSLog(@"我从喵粮产地页面来，order_id = %d,order_type = %d",vc.Order_id.intValue,vc.Order_type.intValue);
    }else if ([vc.requestParams isKindOfClass:[JPushOrderDetailModel class]]){//极光推送——直通车 进
        vc.jPushOrderDetailModel = (JPushOrderDetailModel *)vc.requestParams;
        vc.Order_id = vc.jPushOrderDetailModel.ID;
        vc.Order_type = vc.jPushOrderDetailModel.order_type;
        NSLog(@"我从极光推送——直通车来，order_id = %d,order_type = %d",vc.Order_id.intValue,vc.Order_type.intValue);
    }else if ([vc.requestParams isKindOfClass:[OrderManager_producingAreaModel class]]){//订单管理——产地
        vc.orderManager_producingAreaModel = (OrderManager_producingAreaModel *)vc.requestParams;
        vc.Order_id = vc.orderManager_producingAreaModel.ID;
        vc.Order_type = vc.orderManager_producingAreaModel.order_type;
        NSLog(@"我从订单管理——产地来，order_id = %d,order_type = %d",vc.Order_id.intValue,vc.Order_type.intValue);
    }else if ([vc.requestParams isKindOfClass:[OrderManager_panicBuyingModel class]]){//订单管理——直通车
        vc.orderManager_panicBuyingModel = (OrderManager_panicBuyingModel *)vc.requestParams;
        vc.Order_id = vc.orderManager_panicBuyingModel.ID;
        vc.Order_type = vc.orderManager_panicBuyingModel.order_type;
        NSLog(@"我从订单管理——直通车来，order_id = %d,order_type = %d",vc.Order_id.intValue,vc.Order_type.intValue);
    }
    else{}
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    self.catFoodProducingAreaModel.isSelect = NO;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self buyer_CatfoodRecord_checkURL_NetWorkingWithOrder_type:self.Order_type];//订单类型 —— 1、直通车;2、批发;3、产地
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
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

-(void)chat{
    @weakify(self)
    NSLog(@"联系");
    ConversationModel *model = ConversationModel.new;
    model.conversationType = ConversationType_PRIVATE;
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        model.nick = modelLogin.userName;
        model.userID = modelLogin.userId;
        model.portrait = modelLogin.head;
        model.targetId = @"";
        if (self.orderListModel) {
            model.targetId = [NSString stringWithFormat:@"%@",self.orderListModel.platform_id];//0
            model.myOrderCode = self.orderListModel.ordercode;
            model.conversationTitle = [NSString stringWithFormat:@"买家:%@",self.orderListModel.byname];
        }else if (self.catFoodProducingAreaModel){
//            model.targetId = [NSString stringWithFormat:@"%@",self.catFoodProducingAreaModel.platform_id];//0
        }else if (self.jPushOrderDetailModel){
            model.targetId = [NSString stringWithFormat:@"%@",self.jPushOrderDetailModel.platform_id];//0
            model.myOrderCode = self.jPushOrderDetailModel.ordercode;
            model.conversationTitle = [NSString stringWithFormat:@"买家:%@",self.jPushOrderDetailModel.byname];
        }
        else if (self.orderManager_producingAreaModel){
//            model.targetId = [NSString stringWithFormat:@"%@",self.orderManager_producingAreaModel.platform_id];//0
        }
        else if (self.orderManager_panicBuyingModel){
            model.targetId = [NSString stringWithFormat:@"%@",self.orderManager_panicBuyingModel.platform_id];//0
//            model.myOrderCode = self.orderManager_panicBuyingModel.ordercode;
            model.conversationTitle = [NSString stringWithFormat:@"买家:%@",self.orderManager_panicBuyingModel.byname];
            model.order_code = self.orderManager_panicBuyingModel.ordercode;
        }
    }
    
//    [CatFoodsManagementVC ComingFromVC:self_weak_
//                             withStyle:ComingStyle_PUSH
//                         requestParams:model
//                               success:^(id data) {}
//                              animated:YES];
    
    if (self.navigationController) {
        [ChatVC ComingFromVC:self_weak_
                   withStyle:ComingStyle_PUSH
               requestParams:model
                     success:^(id data) {}
                    animated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)cancdel{
    [self showAlertViewTitle:@"如果恶意取消订单，可能会面临处罚，如被封号等。"
                     message:@""
                 btnTitleArr:@[@"我再想想",@"取消订单"]
              alertBtnAction:@[@"Later",@"sureCancel"]];
}

-(void)Later{}

-(void)sureCancel{//真正开始取消
    [self CatfoodBooth_del_netWorking];
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    OrderDetailTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    viewForHeader.str = self.str;
    if (!viewForHeader) {
        viewForHeader = [[OrderDetailTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                          withData:self.str];
        [viewForHeader headerViewWithModel:self.orderDetailModel];
        //只有已发单下面的取消状态才可以聊天
        @weakify(self)
        [viewForHeader actionBlock:^(id data) {
            @strongify(self)
            if (self.orderDetailModel.order_status.intValue == 2 &&
                (self.orderDetailModel.del_state.intValue == 1 ||
                 self.orderDetailModel.del_state.intValue == 0)) {
                [self chat];
            }
        }];
    }
    
    if (self.orderDetailModel.order_type.intValue == 1 &&
        self.orderDetailModel.del_state.intValue == 1 &&
        self.orderDetailModel.order_status.intValue == 2) {//直通车取消中...
        viewForHeader.tipsBtn.alpha = 1;
    }else{
        viewForHeader.tipsBtn.alpha = 0;
    }
    
    return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [OrderDetailTBViewForHeader headerViewHeightWithModel:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4) &&
        indexPath.row == self.titleMutArr.count - 1) {
        return [OrderDetailTBVIMGCell cellHeightWithModel:nil];//凭证图 payment_print
    }return [OrderDetailTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    OrderDetailTBVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"订单号:"]) {
        [YKToastView showToastText:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = cell.textLabel.text;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"KKK = %lu",(unsigned long)self.titleMutArr.count);
    if (indexPath.row == self.titleMutArr.count - 1) {//最后一行
        if (self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4) {//有凭证数据 payment_print
            OrderDetailTBVIMGCell *cell = [OrderDetailTBVIMGCell cellWith:tableView];//
            if (self.titleMutArr.count) {
                cell.textLabel.text = self.titleMutArr[indexPath.row];
                [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
            }return cell;
        }else{//没有凭证数据，则显示正常的行
            OrderDetailTBVCell *cell = [OrderDetailTBVCell cellWith:tableView];//
            if (self.titleMutArr.count) {
                cell.textLabel.text = self.titleMutArr[indexPath.row];
                [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
            }return cell;
        }
    }else{//其他正常的行
        OrderDetailTBVCell *cell = [OrderDetailTBVCell cellWith:tableView];//
        if (self.titleMutArr.count) {
            cell.textLabel.text = self.titleMutArr[indexPath.row];
        }
        if (self.dataMutArr.count) {//最新数据
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
        }else{//原始数据
            if ([self.requestParams isKindOfClass:[SearchOrderListModel class]]) {
                
            }else if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]){
                
            }else if ([self.requestParams isKindOfClass:[JPushOrderDetailModel class]]){
                
            }
            else{}
        }return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UIButton *)reloadPicBtn{
    if (!_reloadPicBtn) {
        _reloadPicBtn = UIButton.new;
        [UIView cornerCutToCircleWithView:_reloadPicBtn
                          AndCornerRadius:5.f];
        _reloadPicBtn.uxy_acceptEventInterval = btnActionTime;
        _reloadPicBtn.backgroundColor = kOrangeColor;

        [_reloadPicBtn setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:5.f];
        [self.tableView addSubview:_reloadPicBtn];
        
        if (self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4) {//有凭证图 payment_print
            _reloadPicBtn.frame = CGRectMake((SCREEN_WIDTH - SCALING_RATIO(100)) / 2,
                                             [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count - 1) * [OrderDetailTBVCell cellHeightWithModel:nil] + [OrderDetailTBVIMGCell cellHeightWithModel:nil] + SCALING_RATIO(0),
                                             SCALING_RATIO(120),
                                             SCALING_RATIO(50));
        }else{
            _reloadPicBtn.frame = CGRectMake((SCREEN_WIDTH - SCALING_RATIO(120)) / 2,
                                             [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count) * [OrderDetailTBVCell cellHeightWithModel:nil] + SCALING_RATIO(120),
                                             SCALING_RATIO(120),
                                             SCALING_RATIO(50));
        }
    }return _reloadPicBtn;
}

-(VerifyCodeButton *)countDownCancelBtn{///
    if (!_countDownCancelBtn) {
        _countDownCancelBtn = VerifyCodeButton.new;
        _countDownCancelBtn.showTimeType = ShowTimeType_HHMMSS;
        _countDownCancelBtn.layerCornerRadius = 5.f;
//        _countDownCancelBtn.uxy_acceptEventInterval = btnActionTime;
        if (@available(iOS 8.2, *)) {
            _countDownCancelBtn.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            _countDownCancelBtn.titleLabelFont = [UIFont systemFontOfSize:20.f];
        }
        _countDownCancelBtn.titleEndStr = self.titleEndStr;
        _countDownCancelBtn.titleBeginStr = self.titleBeginStr;
        _countDownCancelBtn.clipsToBounds = YES;
        [_countDownCancelBtn timeFailBeginFrom:self.time == 0 ? 3 : self.time];
        [self.tableView addSubview:_countDownCancelBtn];

        if(self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4){//有凭证图 payment_print
            _countDownCancelBtn.frame = CGRectMake(SCALING_RATIO(30),
                                                   [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count - 1) * [OrderDetailTBVCell cellHeightWithModel:nil] + [OrderDetailTBVIMGCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                                   SCALING_RATIO(120),
                                                   SCALING_RATIO(50));
        }else{
            _countDownCancelBtn.frame = CGRectMake(SCALING_RATIO(30),
                                           [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count) * [OrderDetailTBVCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                           SCALING_RATIO(120),
                                           SCALING_RATIO(50));
        }
    }return _countDownCancelBtn;
}

-(UIButton *)sureBtn{///
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        _sureBtn.uxy_acceptEventInterval = btnActionTime;
        _sureBtn.backgroundColor = kOrangeColor;
        [_sureBtn setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:5.f];
        [self.tableView addSubview:_sureBtn];
        
        if(self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4){//有凭证图 payment_print
            _sureBtn.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(150),
                                        [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count - 1) * [OrderDetailTBVCell cellHeightWithModel:nil] + [OrderDetailTBVIMGCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                        SCALING_RATIO(120),
                                        SCALING_RATIO(50));
        }else{
            _sureBtn.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(150),
                                        [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count) * [OrderDetailTBVCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                        SCALING_RATIO(120),
                                        SCALING_RATIO(50));
        }
    }return _sureBtn;
}

-(UIButton *)normalCancelBtn{
    if (!_normalCancelBtn) {
        _normalCancelBtn = UIButton.new;
//        _normalCancelBtn.uxy_acceptEventInterval = btnActionTime;
        [UIView cornerCutToCircleWithView:_normalCancelBtn
                          AndCornerRadius:3.f];
        _normalCancelBtn.backgroundColor = KLightGrayColor;
        [self.tableView addSubview:_normalCancelBtn];
        if(self.orderDetailModel.order_status.intValue == 0 || self.orderDetailModel.order_status.intValue == 4){//有凭证图 payment_print
            self.normalCancelBtn.frame = CGRectMake(SCALING_RATIO(30),
                                                    [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count - 1) * [OrderDetailTBVCell cellHeightWithModel:nil] + [OrderDetailTBVIMGCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                                    SCALING_RATIO(120),
                                                    SCALING_RATIO(50));
        }else{
            self.normalCancelBtn.frame = CGRectMake(SCALING_RATIO(30),
                                                    [OrderDetailTBViewForHeader headerViewHeightWithModel:nil] + (self.titleMutArr.count) * [OrderDetailTBVCell cellHeightWithModel:nil] + SCALING_RATIO(20),
                                                    SCALING_RATIO(120),
                                                    SCALING_RATIO(50));
        }
    }return _normalCancelBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"picLoadErr"
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
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
    }return _titleMutArr;
}

@end
#pragma mark —— 普通的cell
@implementation OrderDetailTBVCell

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self.timeBtn.timer invalidate];
}

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

- (void)richElementsInCellWithModel:(id _Nullable)model{//
    NSLog(@"model = %@",model);
    if ([model isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)model;
        if ([str containsString:@"等待买家确认"]) {
            self.time = (int)[NSString getDigitsFromStr:str];
            if (self.time) {
                [self.timeBtn timeFailBeginFrom:self.time == 0 ? 10 : self.time];
            }
        }else{
            self.detailTextLabel.text = str;
        }
    }
}

-(VerifyCodeButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = VerifyCodeButton.new;
        _timeBtn.showTimeType = ShowTimeType_HHMMSS;
        _timeBtn.layerCornerRadius = 5.f;
        if (@available(iOS 8.2, *)) {
            _timeBtn.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            _timeBtn.titleLabelFont = [UIFont systemFontOfSize:20.f];
        }
        _timeBtn.clipsToBounds = YES;
        _timeBtn.titleEndStr = @"等待买家确认";
        _timeBtn.titleBeginStr = @"等待买家确认";
        _timeBtn.titleColor = kRedColor;
        _timeBtn.bgBeginColor = kWhiteColor;
        _timeBtn.bgEndColor = kWhiteColor;
        _timeBtn.titleRuningStr = @"等待买家确认";
        if (@available(iOS 8.2, *)) {
            _timeBtn.titleLabelFont = [UIFont systemFontOfSize:12 weight:1];
        } else {
            _timeBtn.titleLabelFont = [UIFont systemFontOfSize:12];
        }
        
        [self.contentView addSubview:_timeBtn];
        [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(SCREEN_WIDTH * 2 / 3);
        }];
    }return _timeBtn;
}

@end
#pragma mark —— 承载凭证图片的cell
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
        [SDImageCache sharedImageCache].config.shouldCacheImagesInMemory = NO;
        if (![NSString isNullString:str]) {
            @weakify(self)
            NSString *urlStr = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/%@",str]];
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlStr]
                                                        options:SDWebImageProgressiveDownload//渐进式下载
                                                       progress:^(NSInteger receivedSize,
                                                                  NSInteger expectedSize,
                                                                  NSURL * _Nullable targetURL) {}
                                                      completed:^(UIImage * _Nullable image,
                                                                  NSData * _Nullable data,
                                                                  NSError * _Nullable error,
                                                                  SDImageCacheType cacheType,
                                                                  BOOL finished,
                                                                  NSURL * _Nullable imageURL) {
                @strongify(self)
                if (image) {
                    self.imgV.image = image;
//                    self.imgV.image = kIMG(@"picLoadErr");
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
//        _imgV.image = kIMG(@"picLoadErr");
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.mas_equalTo(self.mj_h - SCALING_RATIO(20));
            make.width.mas_equalTo(SCREEN_WIDTH / 2);
        }];
    }return _imgV;
}

@end

//
//  CatFoodsManagementVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC.h"
#import "OrderListVC.h"//订单
#import "ShopReceiptQRcodeVC.h"//店铺收款码
#import "GiftVC.h"//赠送
#import "CatFoodProducingAreaVC.h"//喵粮产地
#import "SettingPaymentWayVC.h"//设置支付方式
#import "ChatListVC.h"//喵粮会话
#import "LookUpContactWayVC.h"//进货市场
#import "PersonalDataChangedListVC.h"//个人喵粮变动清单
#import "CatFoodsManagementVC+VM.h"
#import "CreateTeamVC.h"//创建团队

#import "DetailsVC.h"//临时
#import "GoodsVC.h"//临时

@interface CatFoodsManagementVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *contactCustomerServiceBtn;
@property(nonatomic,strong)ModelLogin *loginModel;
@property(nonatomic,strong)NSMutableArray <NSArray *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSArray *>*imgMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*VCMutArr;

@property(nonatomic,strong)TimeManager *timeManager;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation CatFoodsManagementVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    CatFoodsManagementVC *vc = CatFoodsManagementVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                vc.isFirstComing = YES;
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

#pragma mark - Lifecycle
-(instancetype)init{
    if (self = [super init]) {
        [self catfoodboothType];//
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navTitle = @"喵粮管理";
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.contactCustomerServiceBtn];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden = YES;
    [self.timeManager startGCDTimer];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timeManager endGCDTimer];
    self.timeManager = nil;
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

-(void)contactCustomerServiceBtnClickEvent:(UIButton *)sender{
    NSLog(@"联系客服");
    @weakify(self)
    if ([[PersonalInfo sharedInstance] isLogined]) {
        ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
        RCConversationModel *conversationModel = RCConversationModel.new;
        conversationModel.conversationType = ConversationType_PRIVATE;
        conversationModel.targetId = [model.platform_id stringValue];
        [ChatVC ComingFromVC:self_weak_
                   withStyle:ComingStyle_PUSH
               requestParams:conversationModel
                     success:^(id data) {}
                    animated:YES];
    }else{
        
    }
}
#pragma mark —— 私有方法
-(void)GCDtimerMaker{
    //轮询
    NSLog(@"轮询_CatFoodsManagementVC");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self networking];
}
// 下拉刷新
-(void)pullToRefresh{//轮询
    NSLog(@"下拉刷新");
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.tableView.mj_footer endRefreshing];
}

-(void)Later{//稍后去上传
    NSLog(@"稍后去上传");
}

-(void)OK{
    @weakify(self)
    [ShopReceiptQRcodeVC ComingFromVC:self_weak_
                            withStyle:ComingStyle_PUSH
                        requestParams:nil
                              success:^(id data) {}
                             animated:YES];
}

-(void)launch:(NSString *)vcName{
    @weakify(self)
    if ([vcName isEqualToString:@"喵粮订单管理"]) {
        [OrderListVC ComingFromVC:self_weak_
                         withStyle:ComingStyle_PUSH
                     requestParams:Nil
                           success:^(id data) {}
                          animated:YES];
    }else if ([vcName isEqualToString:@"店铺收款码"]){
        [ShopReceiptQRcodeVC ComingFromVC:self_weak_
                                withStyle:ComingStyle_PUSH
                            requestParams:nil
                                  success:^(id data) {}
                                 animated:YES];
    }else if ([vcName isEqualToString:@"赠送"]){
        [GiftVC ComingFromVC:self_weak_
                   withStyle:ComingStyle_PUSH
               requestParams:nil
                     success:^(id data) {}
                    animated:YES];
    }else if ([vcName isEqualToString:@"喵粮产地"]){
        [CatFoodProducingAreaVC ComingFromVC:self_weak_
                                   withStyle:ComingStyle_PUSH
                               requestParams:nil
                                     success:^(id data) {}
                                    animated:YES];
    }else if ([vcName isEqualToString:@"直通车"]){
#warning KKK
//        [GoodsVC ComingFromVC:self_weak_
//                    withStyle:ComingStyle_PUSH
//                requestParams:nil
//                      success:^(id data) {}
//                     animated:YES];
//        return;
        if (self.dataMutArr.count) {
            NSString *str = (NSString *)self.dataMutArr[1];
            if ([str isEqualToString:@"无"]) {
                [self showAlertViewTitle:@"未上传店铺收款二维码"
                                 message:@"现在去上传？"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }else if ([str isEqualToString:@"-1"]){
                [self showAlertViewTitle:@"店铺收款二维码被禁"
                                 message:@"现在去上传？"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }else{
                [ThroughTrainToPromoteVC ComingFromVC:self_weak_
                                            withStyle:ComingStyle_PUSH
                                        requestParams:nil
                                              success:^(id data) {}
                                             animated:YES];
            }
        }
    }else if ([vcName isEqualToString:@"进货市场"]){//Vip不显示
        [LookUpContactWayVC ComingFromVC:self_weak_
                               withStyle:ComingStyle_PUSH
                           requestParams:nil
                                 success:^(id data) {}
                                animated:YES];
    }else if ([vcName isEqualToString:@"设置收款方式"]){
        [SettingPaymentWayVC ComingFromVC:self_weak_
                                withStyle:ComingStyle_PUSH
                            requestParams:nil
                                  success:^(id data) {}
                                 animated:YES];
    }else if ([vcName isEqualToString:@"喵粮会话"]){
        [ChatListVC ComingFromVC:self_weak_
                       withStyle:ComingStyle_PUSH
                   requestParams:nil
                         success:^(id data) {}
                        animated:YES];
    }else if ([vcName isEqualToString:@"喵粮记录"]){
        [PersonalDataChangedListVC ComingFromVC:self_weak_
                                       withStyle:ComingStyle_PUSH
                                   requestParams:nil
                                         success:^(id data) {}
                                        animated:YES];
    }else if ([vcName isEqualToString:@"创建团队"]){
        [CreateTeamVC ComingFromVC:self_weak_
                         withStyle:ComingStyle_PUSH
                     requestParams:nil
                           success:^(id data) {}
                          animated:YES];
    }else{}
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    ViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KJHG"];
    viewForHeader.backgroundColor = kClearColor;
    return viewForHeader;
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCALING_RATIO(10);
    }
    return SCALING_RATIO(30);
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self launch:cell.textLabel.text];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleMutArr[indexPath.section][indexPath.row];
        cell.imageView.image = kIMG(self.imgMutArr[indexPath.section][indexPath.row]);
        cell.detailTextLabel.textColor = kBlueColor;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.dataMutArr.count != 0 ? self.dataMutArr[2] : @"";
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text = self.dataMutArr.count != 0 ? self.dataMutArr[5] : @"";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }else if (indexPath.section == 1){
        if ([cell.textLabel.text isEqualToString:@"喵粮订单管理"]) {
            extern NSString *wait_goods;//待处理订单的数量
            if (![NSString isNullString:wait_goods] ) {
                            UIButton *btn = UIButton.new;
                [btn setTitle:wait_goods
                     forState:UIControlStateNormal];
                [btn setBackgroundImage:kIMG(@"RedDot")
                               forState:UIControlStateNormal];
                [cell addSubview:btn];
                btn.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(60),
                                       SCALING_RATIO(15),
                                       SCALING_RATIO(20),
                                       SCALING_RATIO(20));
                [UIView cornerCutToCircleWithView:btn
                                  AndCornerRadius:10];
            }
        }
    }else{}
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleMutArr.count;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirstComing) {
            //设置Cell的动画效果为3D效果
        //设置x和y的初始值为0.1；
        cell.layer.transform = CATransform3DMakeScale(0.1,
                                                      0.1,
                                                      1);
        //x和y的最终值为1
        [UIView animateWithDuration:1
                         animations:^{
            cell.layer.transform = CATransform3DMakeScale(1,
                                                          1,
                                                          1);
        }];
    }self.isFirstComing = NO;
}
#pragma mark —— lazyLoad
-(UIButton *)contactCustomerServiceBtn{
    if (!_contactCustomerServiceBtn) {
        _contactCustomerServiceBtn = UIButton.new;
        [_contactCustomerServiceBtn setTitleColor:kWhiteColor
                                         forState:UIControlStateNormal];
        [_contactCustomerServiceBtn setBackgroundImage:kIMG(@"contactCustomerService")
                                              forState:UIControlStateNormal];
        [_contactCustomerServiceBtn addTarget:self
                                       action:@selector(contactCustomerServiceBtnClickEvent:)
                             forControlEvents:UIControlEventTouchUpInside];
    }return _contactCustomerServiceBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = UIView.new;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"picLoadErr"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(NSMutableArray<NSArray *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@[@"可用的喵粮数量",
                                  @"出售中的数量"]];
        NSMutableArray *tempMutArr = NSMutableArray.array;
        [tempMutArr addObject:@"喵粮订单管理"];
        [tempMutArr addObject:@"店铺收款码"];
        [tempMutArr addObject:@"赠送"];
        if ([self.loginModel.grade_id intValue] == 3) {//只有Vip商家可见
            [tempMutArr addObject:@"喵粮产地"];//喵粮产地
        }
        [tempMutArr addObject:@"直通车"];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {
                [tempMutArr addObject:@"进货市场"];
            }
        }
        [tempMutArr addObject:@"喵粮会话"];
        [tempMutArr addObject:@"喵粮记录"];
        [tempMutArr addObject:@"创建团队"];
        [_titleMutArr addObject:tempMutArr];
    }return _titleMutArr;
}

-(NSMutableArray<NSArray *> *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = NSMutableArray.array;
        [_imgMutArr addObject:@[@"balance",
                                @"selling"]];
        NSMutableArray *tempMutArr = NSMutableArray.array;
        [tempMutArr addObject:@"listManager"];
        [tempMutArr addObject:@"StoreReceiptCode"];
        [tempMutArr addObject:@"send"];
        if ([self.loginModel.grade_id intValue] == 3) {//只有Vip商家可见
            [tempMutArr addObject:@"producingArea"];//喵粮产地
        }
        [tempMutArr addObject:@"panicPurchase"];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {
                [tempMutArr addObject:@"wholesaleMarket"];
            }
        }
        [tempMutArr addObject:@"telephone"];
        [tempMutArr addObject:@"recordTable"];
        [tempMutArr addObject:@"CreateTeam"];
        [_imgMutArr addObject:tempMutArr];
    }return _imgMutArr;
}

-(NSMutableArray<NSString *> *)VCMutArr{
    if (!_VCMutArr) {
        _VCMutArr = NSMutableArray.array;
    }return _VCMutArr;
}

-(NSMutableArray *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(TimeManager *)timeManager{
    if (!_timeManager) {
        _timeManager = TimeManager.new;
        @weakify(self)
        [_timeManager GCDTimer:@selector(GCDtimerMaker)
                        caller:self_weak_
                      interval:3];
    }return _timeManager;
}


@end

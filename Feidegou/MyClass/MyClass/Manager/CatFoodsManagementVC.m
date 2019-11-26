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
#import "PersonalDataChangedListVC.h"//个人喵粮变动清单
#import "CatFoodsManagementVC+VM.h"

@interface CatFoodsManagementVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)ModelLogin *loginModel;
@property(nonatomic,strong)NSMutableArray <NSArray *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSArray *>*imgMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*VCMutArr;

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

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    CatFoodsManagementVC *vc = CatFoodsManagementVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.loginModel = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
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
    }return vc;
}

#pragma mark - Lifecycle
-(instancetype)init{
    if (self = [super init]) {
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navTitle = @"喵粮管理";
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self networking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
//    [self networking];
}

-(void)Later{//稍后去上传
    NSLog(@"稍后去上传");
}

-(void)OK{
    @weakify(self)
    [ShopReceiptQRcodeVC pushFromVC:self_weak_
                      requestParams:Nil
                            success:^(id data) {}
                           animated:YES];
}

-(void)launch:(NSString *)vcName{
    @weakify(self)
    if ([vcName isEqualToString:@"喵粮订单管理"]) {
//        [OrderListVC pushFromVC:self_weak_
//                  requestParams:Nil
//                        success:^(id data) {}
//                       animated:YES];
        [OrderListVC ComingFromVC:self_weak_
                         withStyle:ComingStyle_PUSH
                     requestParams:Nil
                           success:^(id data) {}
                          animated:YES];
    }else if ([vcName isEqualToString:@"店铺收款码"]){
        [ShopReceiptQRcodeVC pushFromVC:self_weak_
                          requestParams:Nil
                                success:^(id data) {}
                               animated:YES];
    }else if ([vcName isEqualToString:@"赠送"]){
        [GiftVC pushFromVC:self_weak_
             requestParams:nil
                   success:^(id data) {}
                  animated:YES];
    }else if ([vcName isEqualToString:@"喵粮产地"]){
        [CatFoodProducingAreaVC pushFromVC:self_weak_
                             requestParams:nil
                                   success:^(id data) {}
                                  animated:YES];
    }else if ([vcName isEqualToString:@"直通车"]){
        if (self.dataMutArr.count) {
            NSString *str = (NSString *)self.dataMutArr[1];
            if (![str isEqualToString:@"无"]) {
                [self check];
            }else{
                [self showAlertViewTitle:@"未上传店铺收款二维码"
                                 message:@"现在去上传？"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }
        }
    }
//    else if ([vcName isEqualToString:@"喵粮转转"]){
////        if ([self.dataMutArr[0] isKindOfClass:[NSString class]]) {
////            NSString *str = self.dataMutArr[0];
////            if ([str isEqualToString:@"0"]) {
////                Toast(@"余额为0无法开启转转");
////            }else{
////                //被取消了
////                [ThroughTrainToPromoteVC pushFromVC:self_weak_
////                requestParams:nil
////                      success:^(id data) {}
////                     animated:YES];
////            }
////        }
//        if (self.dataMutArr.count) {
//            NSString *str = (NSString *)self.dataMutArr[1];
//            if (![str isEqualToString:@"无"]) {
//                [self check];
//            }else{
//                [self showAlertViewTitle:@"未上传店铺收款二维码"
//                                 message:@"现在去上传？"
//                             btnTitleArr:@[@"好的"]
//                          alertBtnAction:@[@"OK"]];
//            }
//        }
//    }
    else if ([vcName isEqualToString:@"喵粮批发市场"]){//self.loginModel.grade_id

    }else if ([vcName isEqualToString:@"设置收款方式"]){
        [SettingPaymentWayVC pushFromVC:self_weak_
                          requestParams:nil
                                success:^(id data) {}
                               animated:YES];
    }else if ([vcName isEqualToString:@"喵粮会话"]){        
        [ChatListVC pushFromVC:self_weak_
             requestParams:nil
                   success:^(id data) {}
                  animated:YES];
    }else if ([vcName isEqualToString:@"喵粮记录"]){
        [PersonalDataChangedListVC ComingFromVC:self_weak_
                                       withStyle:ComingStyle_PUSH
                                   requestParams:nil
                                         success:^(id data) {}
                                        animated:YES];
    }else{}
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
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
    }return cell;
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
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
                                  @"出售中的数量",
                                  @"喵粮记录"]];
        NSMutableArray *tempMutArr = NSMutableArray.array;
        [tempMutArr addObject:@"喵粮订单管理"];
        [tempMutArr addObject:@"店铺收款码"];
        [tempMutArr addObject:@"赠送"];
        if ([self.loginModel.grade_id intValue] == 3) {//只有Vip商家可见
            [tempMutArr addObject:@"喵粮产地"];//喵粮产地
        }
        [tempMutArr addObject:@"直通车"];
        [tempMutArr addObject:@"喵粮批发市场"];
        [tempMutArr addObject:@"喵粮会话"];
        if ([self.loginModel.grade_id intValue] == 3) {
//            [tempMutArr addObject:@"设置收款方式"];
        }
        [_titleMutArr addObject:tempMutArr];
    }return _titleMutArr;
}

-(NSMutableArray<NSArray *> *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = NSMutableArray.array;
        [_imgMutArr addObject:@[@"balance",
                                @"selling",
                                @"PersonalListOfChanges"]];
        NSMutableArray *tempMutArr = NSMutableArray.array;
        [tempMutArr addObject:@"listManager"];
        [tempMutArr addObject:@"StoreReceiptCode"];
        [tempMutArr addObject:@"send"];
        if ([self.loginModel.grade_id intValue] == 3) {//只有Vip商家可见
            [tempMutArr addObject:@"producingArea"];//喵粮产地
        }
        [tempMutArr addObject:@"panicPurchase"];
        [tempMutArr addObject:@"wholesaleMarket"];
        [tempMutArr addObject:@"telephone"];
        if ([self.loginModel.grade_id intValue] == 3) {
            [tempMutArr addObject:@"pay"];
        }
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

@end

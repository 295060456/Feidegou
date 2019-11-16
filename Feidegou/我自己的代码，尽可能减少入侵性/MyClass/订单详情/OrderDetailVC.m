//
//  OrderDetailVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/16.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailVC+VM.h"
#import "UpLoadCancelReasonVC.h"

#pragma mark —— OrderDetailVC
@interface OrderDetailVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    CGFloat OrderDetailTBVCell_04_Height;
    CGFloat OrderDetailTBVCell_02_Height;
}

@property(nonatomic,strong)BRStringPickerView *stringPickerView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)id popGestureDelegate; //用来保存系统手势的代理

@end

@implementation OrderDetailVC
//上个页面给数据，本页面手动的刷新
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
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
    if (self.orderListModel) {
        if ([self.orderListModel.order_type intValue] == 1) {//摊位 只有卖家
            self.gk_navTitle = @"卖家订单详情";
        }else if ([self.orderListModel.order_type intValue] == 2){//批发 买家 & 卖家
            //先判断是买家还是卖家 deal :1、买；2、卖
            if ([self.orderListModel.deal intValue] == 1) {//买
                self.gk_navTitle = @"买家订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {//已下单
                    [self.cancelBtn setTitle:@"取消"
                                    forState:UIControlStateNormal];
                    [self.sureBtn setTitle:@"上传支付凭证"
                                  forState:UIControlStateNormal];
                }else if([self.orderListModel.order_status intValue] == 0){//已支付
                    [self.sureBtn setTitle:@"重新上传支付凭证"
                                  forState:UIControlStateNormal];
                }
            }else if([self.orderListModel.deal intValue] == 2){//卖
                self.gk_navTitle = @"卖家订单详情";
                if ([self.orderListModel.order_status intValue] == 2) {
                    //不管
                }else if ([self.orderListModel.order_status intValue] == 0){//已支付
                    [self.cancelBtn setTitle:@"上传撤销凭证"
                                    forState:UIControlStateNormal];
                    [self.sureBtn setTitle:@"立即发货"
                                  forState:UIControlStateNormal];
                }
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
            }
        }else{}
    }
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark —— 私有方法
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self netWorking];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tips:(UIButton *)sender{
    if ([sender isEqual:self.cancelBtn]) {
        [self showAlertViewTitle:sender.titleLabel.text
                         message:@""
                     btnTitleArr:@[@"取消",
                                   @"手滑，点错了"]
                  alertBtnAction:@[@"sureBtnClickEvent",//取消
                                   @"Cancel"]];//取消
    }else if ([sender isEqual:self.sureBtn]){
        [self showAlertViewTitle:sender.titleLabel.text
                         message:@""
                     btnTitleArr:@[@"我已确认",
                                   @"手滑，点错了"]
                  alertBtnAction:@[@"cancelBtnClickEvent",//继续
                                   @"Cancel"]];//取消
    }
}

-(void)cancelBtnClickEvent{
    if(self.orderListModel){
        if ([self.orderListModel.order_type intValue] == 2) {//批发
            if ([self.orderListModel.deal intValue] == 1) {//买
                if ([self.orderListModel.order_status intValue] == 2) {//#18
                    
                }
            }else if ([self.orderListModel.deal intValue] == 2){//卖
                if ([self.orderListModel.order_status intValue] == 0) {//#5
                    
                }
            }else{}
        }else if ([self.orderListModel.order_type intValue] == 3){//产地
            if ([self.orderListModel.order_status intValue] == 2) {//#9
                
            }
        }else{}
    }
}

-(void)sureBtnClickEvent{
    if (self.orderListModel) {
        if ([self.orderListModel.order_type intValue] == 2) {//批发
            if ([self.orderListModel.deal intValue] == 1) {//买
                if ([self.orderListModel.order_status intValue] == 2) {//#17
                    
                }else if ([self.orderListModel.order_status intValue] == 0){//#17
                    
                }else{}
            }else if([self.orderListModel.deal intValue] == 2){//卖
                if ([self.orderListModel.order_status intValue] == 0) {//#14
                    
                }
            }else{}
        }else if ([self.orderListModel.order_type intValue] == 3){//产地
            if ([self.orderListModel.order_status intValue] == 2) {//#8
                
            }else if ([self.orderListModel.order_status intValue] == 0){//#8
                
            }
        }else{}
    }
}

//-(void)ConfirmDelivery{//确认发货
//    NSLog(@"确认发货");
////    [self ConfirmDelivery_NetWorking];
//}
//
//-(void)CancelDelivery{//取消发货
//
//    //#5 CatfoodRecord_delURL 喵粮订单撤销 order_id reason del_print(pic) order_type
//    //#9 CatfoodCO_pay_delURL 喵粮产地购买取消 order_id
//    //#18 CatfoodSale_pay_delURL 喵粮批发取消 order_id
//    //#22 CatfoodBooth_delURL 喵粮抢摊位取消 order_id
//
//    //要求上传取消凭证
//    [self choosePic];
//    @weakify(self)
//    [self GettingPicBlock:^(id data) {
//        @strongify(self)
//        if ([data isKindOfClass:[NSArray class]]) {
//            NSArray *arrData = (NSArray *)data;
//            if (arrData.count == 1) {
//                self.pic = arrData.lastObject;
//            }else{
//                [self showAlertViewTitle:@"选择一张相片就够啦"
//                                 message:@"不要画蛇添足"
//                             btnTitleArr:@[@"好的"]
//                          alertBtnAction:@[@"OK"]];
//            }
//        }
//    }];
//    OrderListModel *orderListModel;
//    if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
//        orderListModel = (OrderListModel *)self.requestParams;
//    }
//    if ([orderListModel.order_status intValue] == 0) {//#5
//        //选择取消发货的原因
//        [self.stringPickerView show];
//    }else if ([orderListModel.order_status intValue] == 2){
////        if ([orderListModel.order_type intValue] == 1) {//#22
////            [self netWorkingWithArgumentURL:CatfoodBooth_delURL
////                                    ORDERID:[orderListModel.ID intValue]];
////        }else if ([orderListModel.order_type intValue] == 2){//#18
////            [self netWorkingWithArgumentURL:CatfoodSale_pay_delURL
////                                    ORDERID:[orderListModel.ID intValue]];
////        }else if ([orderListModel.order_type intValue] == 3){//#9
////            [self netWorkingWithArgumentURL:CatfoodCO_pay_delURL
////                                    ORDERID:[orderListModel.ID intValue]];
//    }

//#pragma mark —— UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated{
////    if ([viewController isKindOfClass:[StallListVC class]] && self.isShowViewFinished) {
////        [navigationController popToViewController:navigationController.viewControllers[navigationController.viewControllers.count - 2]
////                                         animated:NO];
////
////    }else if([viewController isKindOfClass:[OrderListVC class]]){
////
////    }
//}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return OrderDetailTBVCell_04_Height;
    }else if(indexPath.section == 1 &&
             indexPath.row == 0){
        return OrderDetailTBVCell_02_Height;
    }else if (indexPath.section == 1 &&
              indexPath.row == 1){
        return [OrderDetailTBVCell_05 cellHeightWithModel:self.requestParams];//order_status
    }else{}
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {

        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        } break;
        case 1:{
            return 3;
        } break;
        default:{
            return 0;
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{//OrderListModel
    if (indexPath.section == 0) {//待考究
        if (indexPath.row == 0) {
            OrderDetailTBVCell_04 *cell = [OrderDetailTBVCell_04 cellWith:tableView];
            if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
                [cell richElementsInCellWithModel:self.requestParams];
            }
            OrderDetailTBVCell_04_Height = [cell cellHeightWithModel:NULL];
            return cell;
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            OrderDetailTBVCell_02 *cell = [OrderDetailTBVCell_02 cellWith:tableView];
            OrderDetailTBVCell_02_Height = [cell cellHeightWithModel:NULL];
            if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
                [cell richElementsInCellWithModel:self.requestParams];
            }return cell;
        }else if(indexPath.row == 1){//状态栏
            OrderDetailTBVCell_05 *cell = [OrderDetailTBVCell_05 cellWith:tableView];
            cell.backgroundColor = KGreenColor;
            if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
                [cell richElementsInCellWithModel:self.requestParams];
            }return cell;
        }
        else{}
    }else{}
    return UITableViewCell.new;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark —— lazyLoad
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(BRStringPickerView *)stringPickerView{
    if (!_stringPickerView) {
        _stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
        _stringPickerView.title = @"请选择取消原因";
        _stringPickerView.dataSourceArr = @[@"未收到款项",
                                           @"收到了,但是款项不符"];
//        _stringPickerView.selectValue = textField.text;
        @weakify(self)
        _stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            NSLog(@"选择的值：%@", resultModel.selectValue);
            @strongify(self)
            self.resultStr = resultModel.selectValue;
            [UpLoadCancelReasonVC pushFromVC:self_weak_
                               requestParams:@{
                                   @"OrderListModel":self.requestParams,
                                   @"Result":self.resultStr,//撤销理由
                               }
                                     success:^(id data) {}
                                    animated:YES];
        };
    }return _stringPickerView;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

#pragma mark —— InfoView
@interface OrderDetailTBVCell_02 ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*tempMutArr;
@property(nonatomic,strong)OrderListModel *orderListModel;

@end

@implementation OrderDetailTBVCell_02
+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_02 *cell = (OrderDetailTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{//大
    return self.titleMutArr.count * [OrderDetailTBVCell_03 cellHeightWithModel:NULL] + SCALING_RATIO(20);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{//OrderListModel
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderListModel class]]) {
        self.orderListModel = (OrderListModel *)model;
        
        [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"]];//订单号
        [self.tempMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//单价
        [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@"无"]];//数量
        [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.rental ReplaceStr:@"无"]];//总额
        switch ([self.orderListModel.payment_status intValue]) {//支付方式: 1、支付宝;2、微信;3、银行卡
            case 1:{
                [self.tempMutArr addObject:@"支付宝"];
            }break;
            case 2:{
                [self.tempMutArr addObject:@"微信"];
            }break;
             case 3:{
                 [self.tempMutArr addObject:@"银行卡"];
             }break;
            default:
                [self.tempMutArr addObject:@"无支付方式"];
                break;
        }
        //1、支付宝;2、微信;3、银行卡
        if ([self.orderListModel.payment_status intValue] == 3) {//银行卡
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankCard ReplaceStr:@"暂无信息"]];//银行卡号
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankUser ReplaceStr:@"暂无信息"]];//姓名
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankName ReplaceStr:@"暂无信息"]];//银行类型
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankaddress ReplaceStr:@"暂无信息"]];//支行信息
        }else if ([self.orderListModel.payment_status intValue] == 2){//微信
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_weixin ReplaceStr:@"无"]];
        }else if ([self.orderListModel.payment_status intValue] == 1){//支付宝
            [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payment_alipay ReplaceStr:@"无"]];
        }else{
            [self.tempMutArr addObject:@"无支付账户"];
        }
        [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.refer ReplaceStr:@"无"]];//参考号
        [self.tempMutArr addObject:[NSString ensureNonnullString:self.orderListModel.updateTime ReplaceStr:@"无"]];//时间
        
        [self.tableView reloadData];
    }
    self.tableView.alpha = 1;
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderDetailTBVCell_03 cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailTBVCell_03 *cell = [OrderDetailTBVCell_03 cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row];
    if (self.tempMutArr.count) {
        cell.detailTextLabel.text = self.tempMutArr[indexPath.row];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _tableView;
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
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)tempMutArr{
    if (!_tempMutArr) {
        _tempMutArr = NSMutableArray.array;
    }return _tempMutArr;
}

@end

@interface OrderDetailTBVCell_03 ()
@end

@implementation OrderDetailTBVCell_03

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_03 *cell = (OrderDetailTBVCell_03 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_03 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{//小
    return SCALING_RATIO(40);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

@end

@interface OrderDetailTBVCell_04 ()

@property(nonatomic,strong)YYLabel *titleLab;
@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;

@end

@implementation OrderDetailTBVCell_04

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_04 *cell = (OrderDetailTBVCell_04 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_04 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return _titleLab.mj_h + SCALING_RATIO(50);//SCALING_RATIO(50) 为补充值
}

- (void)richElementsInCellWithModel:(id _Nullable)model{//OrderListModel
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderListModel class]]) {
        OrderListModel *orderListModel = (OrderListModel *)model;
        self.str = [NSString stringWithFormat:@"您向%@购买%d",orderListModel.seller_name,[orderListModel.quantity intValue]];
        self.titleLab.attributedText = self.attributedString;
    }
}
#pragma mark —— lazyLoad
-(NSMutableAttributedString *)attributedString{
    if (!_attributedString) {
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineSpacing = 1;//行间距
        paragraphStyle.firstLineHeadIndent = 40;//首行缩进
        
        NSDictionary *attributeDic = @{
            NSFontAttributeName : [UIFont systemFontOfSize:24],
            NSParagraphStyleAttributeName : paragraphStyle,
            NSForegroundColorAttributeName : kRedColor
        };
            
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];

        NSRange selRange_01 = [self.str rangeOfString:@"您向"];
        NSRange selRange_02 = [self.str rangeOfString:@"购买"];

        //设定可点击文字的的大小
        UIFont *selFont = [UIFont systemFontOfSize:18];
        CTFontRef selFontRef = CTFontCreateWithName((__bridge CFStringRef)selFont.fontName,
                                                    selFont.pointSize,
                                                    NULL);
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_01];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_01];
#warning 打开注释部分会崩，之前都不会崩溃，怀疑是升级Xcode所致
                 //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_01];
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_02];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_02];
        //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_02];
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }return _attributedString;
}

-(YYLabel *)titleLab{
    if (!_titleLab) {
        _titleLab = YYLabel.new;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        _titleLab.attributedText = self.attributedString;
//        _titleLab.lineBreakMode = NSLineBreakByCharWrapping;//？？
        [_titleLab sizeToFit];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(20));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-20));
            make.left.right.equalTo(self.contentView);
        }];
    }return _titleLab;
}

@end

@interface OrderDetailTBVCell_05 ()

@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation OrderDetailTBVCell_05

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_05 *cell = (OrderDetailTBVCell_05 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_05 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{//OrderListModel
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderListModel class]]) {
        OrderListModel *orderListModel = (OrderListModel *)model;
        switch ([orderListModel.order_status intValue]) {//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
            case 0:{
                self.titleLab.text = @"订单已支付";
            }break;
            case 1:{
                self.titleLab.text = @"订单已发单";
            }break;
            case 2:{
                self.titleLab.text = @"订单已下单";
            }break;
            case 3:{
                self.titleLab.text = @"订单已支付";
            }break;
            case 4:{
                self.titleLab.text = @"订单已作废";
            }break;
            case 5:{
                self.titleLab.text = @"订单已完成";
            }break;
            default:
                break;
        }
    }
}

#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _titleLab;
}

@end

//-(VerifyCodeButton *)cancelCountDownBtn{
//    if (!_cancelCountDownBtn) {
//        _cancelCountDownBtn = VerifyCodeButton.new;
//        _cancelCountDownBtn.titleBeginStr = @"取消";
//        _cancelCountDownBtn.titleEndStr = @"取消";
//        _cancelCountDownBtn.titleColor = kWhiteColor;
//        _cancelCountDownBtn.bgBeginColor = KLightGrayColor;
//        _cancelCountDownBtn.bgEndColor = kOrangeColor;
//        _cancelCountDownBtn.layerBorderColor = kWhiteColor;
//        _cancelCountDownBtn.layerCornerRadius = 5;
//        _cancelCountDownBtn.isClipsToBounds = YES;
////        [_cancelBtn.titleLabel sizeToFit];
//        _cancelCountDownBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_cancelCountDownBtn timeFailBeginFrom:3];
//        [_cancelCountDownBtn addTarget:self
//                       action:@selector(cancelBtnClickEvent:)
//             forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_cancelCountDownBtn];
//        [_cancelCountDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
//            make.centerY.equalTo(self.contentView);
//            make.size.mas_equalTo(self.sureBtn);
//        }];
//    }return _cancelCountDownBtn;
//}
//

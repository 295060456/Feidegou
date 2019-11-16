//
//  OrderDetail_BuyerVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_BuyerVC.h"
#import "UpLoadHavePaidVC.h"
#import "OrderDetail_BuyerVC+VM.h"

@interface OrderDetail_BuyerTBVCell_01 ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableViewCell *cell;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)OrderDetail_BuyerModel *model;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,copy)NSString *str;
@property(nonatomic,strong)OrderListModel *orderListModel;

@end

@implementation OrderDetail_BuyerTBVCell_01

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetail_BuyerTBVCell_01 *cell = (OrderDetail_BuyerTBVCell_01 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetail_BuyerTBVCell_01 alloc] initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:ReuseIdentifier
                                                           margin:SCALING_RATIO(5)];
        cell.backgroundColor = kRedColor;//kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return (self.titleMutArr.count + 1.5) * SCALING_RATIO(30);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSMutableArray class]]) {
        self.dataMutArr = (NSMutableArray *)model;
        if (self.dataMutArr.count) {
            [self.tableView reloadData];
        }else{}
    }else if ([model isKindOfClass:[OrderListModel class]]){
        self.orderListModel = (OrderListModel *)model;
        [self.dataMutArr addObject:[NSString stringWithFormat:@"%@向您购买%@g喵粮",[NSString ensureNonnullString:self.orderListModel.buyer ReplaceStr:@"a暂无信息"],[NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@"无"]]];//
        [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"] ];//单价
        [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.quantity ReplaceStr:@"无"] stringByAppendingString:@" g"]];//数量
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.ID ReplaceStr:@"无"]];//订单号
        [self.dataMutArr addObject:[[NSString ensureNonnullString:self.orderListModel.rental ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];//总额
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.payTime ReplaceStr:@"无"]];//时间
        
        if ([[NSString ensureNonnullString:self.orderListModel.payment_status ReplaceStr:@"无"] isEqualToString:@"无"]) {
            [self.dataMutArr addObject:@"支付方式数据异常"];
        }else{
            switch ([self.orderListModel.payment_status intValue]) {//支付方式 1、支付宝;2、微信;3、银行卡
                case 1:{
                    [self.dataMutArr addObject:@"支付宝"];
                } break;
                case 2:{
                    [self.dataMutArr addObject:@"微信"];
                } break;
                case 3:{
                    [self.dataMutArr addObject:@"银行卡"];
                } break;
                default:
                    [self.dataMutArr addObject:@"支付方式数据异常"];
                    break;
            }
        }
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankCard ReplaceStr:@"无"]];//银行卡号
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankName ReplaceStr:@"无"]];//银行类型
        [self.dataMutArr addObject:[NSString ensureNonnullString:self.orderListModel.bankUser ReplaceStr:@"无"]];//姓名
        if ([[NSString ensureNonnullString:self.orderListModel.order_status ReplaceStr:@"无"] isEqualToString:@"无"]) {
            [self.dataMutArr addObject:@"订单状态数据异常"];
        }else{
            switch ([self.orderListModel.order_status intValue]) {//订单状态 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                case 0:{
                    [self.dataMutArr addObject:@"已支付"];
                }break;
                case 1:{
                    [self.dataMutArr addObject:@"已发单"];
                }break;
                case 2:{
                    [self.dataMutArr addObject:@"已下单"];
                }break;
                case 3:{
                    [self.dataMutArr addObject:@"已作废"];
                }break;
                case 4:{
                    [self.dataMutArr addObject:@"已发货"];
                }break;
                case 5:{
                    [self.dataMutArr addObject:@"已完成"];
                }break;
                default:
                    [self.dataMutArr addObject:@"订单状态数据异常"];
                    break;
            }
        }
        [self.tableView reloadData];
    }else{}
    self.tableView.alpha = 1;
}
//复制
-(void)copyAction:(UITableViewCell *)cell{
    //复制到剪贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.lab.text;
    NSLog(@"AAA %@",self.lab.text);
    NSLog(@"BBB %@",pasteboard.string);
    if (pasteboard.string) {
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"复制%@成功",cell.textLabel.text]];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(30);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.detailTextLabel.text) {
        [self copyAction:cell];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:ReuseIdentifier];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titleMutArr[indexPath.row];
        if (indexPath.row == 7 ||
            indexPath.row == 8 ||
            indexPath.row == 9) {
            cell.detailTextLabel.text = @"复制";
            cell.detailTextLabel.textColor = kBlueColor;
            if (self.dataMutArr.count) {
                self.str = self.dataMutArr[indexPath.row];
                self.lab = UILabel.new;
                self.lab.textAlignment = NSTextAlignmentCenter;
//                self.lab.backgroundColor = KLightGrayColor;
                self.lab.text = self.str;
                [self.lab sizeToFit];
                [cell.contentView addSubview:self.lab];
                [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.textLabel.mj_w +
                                          cell.textLabel.mj_x +
                                          SCALING_RATIO(100));
                    make.top.equalTo(cell.contentView).offset(SCALING_RATIO(5));
                    make.bottom.equalTo(cell.contentView).offset(SCALING_RATIO(-5));
                }];
            }else{}
        }else{
            if (self.dataMutArr.count) {
                cell.detailTextLabel.text = self.dataMutArr[indexPath.row];
            }
        }
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
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
}
#pragma mark —— lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
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
        [_titleMutArr addObject:@""];
        [_titleMutArr addObject:@"单价:"];
        [_titleMutArr addObject:@"数量:"];
        [_titleMutArr addObject:@"订单号:"];
        [_titleMutArr addObject:@"总额:"];
        [_titleMutArr addObject:@"时间:"];
        [_titleMutArr addObject:@"支付方式:"];
        [_titleMutArr addObject:@"银行卡号:"];
        [_titleMutArr addObject:@"银行类型:"];
        [_titleMutArr addObject:@"姓名:"];
        [_titleMutArr addObject:@"订单状态:"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

@interface OrderDetail_BuyerVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    CGFloat OrderDetail_BuyerTBVCell_01_Hight;
}

@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *sureBtn;//上传凭证 & 完成支付

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation OrderDetail_BuyerVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderDetail_BuyerVC *vc = OrderDetail_BuyerVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;//orderListModel
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
    self.gk_navTitle = @"（买家）订单详情";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);

    if ([self.requestParams isKindOfClass:[OrderListModel class]]) {
        OrderListModel *orderListModel = (OrderListModel *)self.requestParams;
        if (![[NSString ensureNonnullString:orderListModel.order_status ReplaceStr:@"无"] isEqualToString:@"无"]) {
            switch ([orderListModel.order_status intValue]) {
                case 0:{//已发货
                    [self.sureBtn setTitle:self.titleMutArr[1]
                                  forState:UIControlStateNormal];//完成支付
                    [self.sureBtn addTarget:self
                                     action:@selector(paymentFinish:)
                           forControlEvents:UIControlEventTouchUpInside];
                }break;
                case 2:{//待发货
                    [self.sureBtn setTitle:self.titleMutArr[0]
                                  forState:UIControlStateNormal];//上传凭证
                    [self.sureBtn addTarget:self
                                     action:@selector(uploadPrintPic:)
                           forControlEvents:UIControlEventTouchUpInside];
                }break;
                default:
//                    [self.sureBtn setTitle:@"订单状态异常"
//                                  forState:UIControlStateNormal];
//                    [self.sureBtn addTarget:self
//                              action:@selector(err:)
//                    forControlEvents:UIControlEventTouchUpInside];
#warning 上面要，下面的是临时测试使用
                    [self.sureBtn setTitle:self.titleMutArr[0]
                                  forState:UIControlStateNormal];//上传凭证
                    [self.sureBtn addTarget:self
                                     action:@selector(uploadPrintPic:)
                           forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
            }
            self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sureBtn];
            self.gk_navItemRightSpace = SCALING_RATIO(30);
        }
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.isFirstComing = YES;
    self.tableView.alpha = 1;
    self.cancelBtn.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView removeFromSuperview];
    
}
#pragma mark —— 截取 UIViewController 手势返回事件
//只有 出 才调用
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        [self cancelOrder_netWorking];
        NSLog(@"页面pop成功了");
    }
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self cancelOrder];
}
//上传支付凭证
-(void)uploadPrintPic:(UIButton *)sender{
    @weakify(self)
    [UpLoadHavePaidVC pushFromVC:self_weak_
                   requestParams:self.model
                         success:^(id data) {}
                        animated:YES];
}
//完成支付
-(void)paymentFinish:(UIButton *)sender{
    
}

-(void)err:(UIButton *)sender{
    OrderListModel *orderListModel = (OrderListModel *)self.requestParams;
    Toast([NSString ensureNonnullString:orderListModel.order_status ReplaceStr:@"无"]);
}
//取消订单
-(void)cancelOrder{
    NSLog(@"取消订单");
    [self showAlertViewTitle:@"是否需要取消订单？"
                     message:@"若是已付款请不要继续进行此操作，否则可能人财两空"
                 btnTitleArr:@[@"继续取消",
                               @"手滑，点错了"]
              alertBtnAction:@[@"continueToCancelOrder",
                               @"sorry"]];
}
#pragma mark —— 私有方法
-(void)continueToCancelOrder{
    NSLog(@"继续取消");
    [self cancelOrder_netWorking];
}

-(void)sorry{
    NSLog(@"手滑，点错了");
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
//    if (self.dataMutArr.count) {
//        [self.dataMutArr removeAllObjects];
//    }
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self netWorking];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return OrderDetail_BuyerTBVCell_01_Hight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        OrderDetail_BuyerTBVCell_01 *cell = [OrderDetail_BuyerTBVCell_01 cellWith:tableView];
        if (self.dataMutArr.count) {
            [cell richElementsInCellWithModel:self.dataMutArr];
        }else{
            [cell richElementsInCellWithModel:self.requestParams];
        }
        OrderDetail_BuyerTBVCell_01_Hight = [cell cellHeightWithModel:nil];
        return cell;
    }else return UITableViewCell.new;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (!self.isFirstComing) {
//            //设置Cell的动画效果为3D效果
//        //设置x和y的初始值为0.1；
//        cell.layer.transform = CATransform3DMakeScale(0.1,
//                                                      0.1,
//                                                      1);
//        //x和y的最终值为1
//        [UIView animateWithDuration:1
//                         animations:^{
//            cell.layer.transform = CATransform3DMakeScale(1,
//                                                          1,
//                                                          1);
//        }];
//    }
//    self.isFirstComing = !self.isFirstComing;
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
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);//(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"点击上传凭证"];
        [_titleMutArr addObject:@"完成支付"];
        [_titleMutArr addObject:@"取消订单"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:3];
    }return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn addTarget:self
                       action:@selector(backBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:3.f];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [_cancelBtn setTitle:self.titleMutArr.lastObject
                    forState:UIControlStateNormal];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(80)));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
        }];
    }return _cancelBtn;
}


@end

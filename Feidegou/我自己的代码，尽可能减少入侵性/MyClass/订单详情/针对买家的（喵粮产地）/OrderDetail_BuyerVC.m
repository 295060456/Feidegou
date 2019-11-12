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
        }else{
            self.tableView.alpha = 1;
        }
    }else{
        self.tableView.alpha = 1;
    }
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
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
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
            }
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

@end

@interface OrderDetail_BuyerTBVCell_02 ()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)ActionBlock block;

@end

@implementation OrderDetail_BuyerTBVCell_02

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetail_BuyerTBVCell_02 *cell = (OrderDetail_BuyerTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetail_BuyerTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:kWhiteColor
                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
     return SCALING_RATIO(80);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSDictionary class]]) {
        self.titleLab.text = model[@"titleMutArr"][[model[@"index"] intValue]];
        if ([model[@"index"] boolValue]) {
            self.contentView.backgroundColor = KLightGrayColor;
        }else{
            self.contentView.backgroundColor = kOrangeColor;
        }
    }
}
#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _titleLab;
}

@end

@interface OrderDetail_BuyerVC ()
<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>{
    CGFloat OrderDetail_BuyerTBVCell_01_Hight;
}

@property(nonatomic,copy)DataBlock successBlock;
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
    vc.requestParams = requestParams;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.isFirstComing = YES;
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
//已付款
-(void)havePaid{
    NSLog(@"已付款");
    //上传成功，等待后台进行审核 tips
    @weakify(self)
    [UpLoadHavePaidVC pushFromVC:self_weak_
                   requestParams:self.model
                         success:^(id data) {}
                        animated:YES];
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
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return OrderDetail_BuyerTBVCell_01_Hight;
    }else if (indexPath.section == 1){
        return [OrderDetail_BuyerTBVCell_02 cellHeightWithModel:Nil];
    }else return 0.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self havePaid];
        }else if (indexPath.row == 1){
            [self cancelOrder];
        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }break;
        case 1:{
            return 2;
        }break;
        default:
            return 0.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        OrderDetail_BuyerTBVCell_01 *cell = [OrderDetail_BuyerTBVCell_01 cellWith:tableView];
        [cell richElementsInCellWithModel:self.dataMutArr];
        OrderDetail_BuyerTBVCell_01_Hight = [cell cellHeightWithModel:nil];
        return cell;
    }else if (indexPath.section == 1){
        OrderDetail_BuyerTBVCell_02 *cell = [OrderDetail_BuyerTBVCell_02 cellWith:tableView];
        cell.backgroundColor = KGreenColor;
        [cell richElementsInCellWithModel:@{
            @"index":@(indexPath.row),
            @"titleMutArr":self.titleMutArr
        }];
        return cell;
    }else return UITableViewCell.new;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
        [_titleMutArr addObject:@"取消订单"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

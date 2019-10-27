//
//  OrderDetail_BuyerVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_BuyerVC.h"
#import "UpLoadHavePaidVC.h"

@interface OrderDetail_BuyerTBVCell_01 ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

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
    self.tableView.alpha = 1;
}
//复制
-(void)copyAction:(UITableViewCell *)cell{
    //复制到剪贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.detailTextLabel.text;
    if (pasteboard.string.length > 0) {
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
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:ReuseIdentifier];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.textLabel.text = self.titleMutArr[indexPath.row];
            if (indexPath.row == 7 ||
                indexPath.row == 8 ||
                indexPath.row == 9) {
                cell.detailTextLabel.text = @"复制";
                cell.detailTextLabel.textColor = kBlueColor;
            }
        }
        
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
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
        [_titleMutArr addObject:@"您向厂家1001购买了1000g喵粮"];
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

@end

@implementation OrderDetail_BuyerTBVCell_02

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetail_BuyerTBVCell_02 *cell = (OrderDetail_BuyerTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetail_BuyerTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = KGreenColor;//kClearColor;
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
UITableViewDataSource
>{
    CGFloat OrderDetail_BuyerTBVCell_01_Hight;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

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
    self.gk_navTitle = @"订单详情";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.tableView.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}
#pragma mark —— 点击事件
//已付款
-(void)havePaid{
    NSLog(@"已付款");
    //上传成功，等待后台进行审核 tips
    @weakify(self)
    [UpLoadHavePaidVC pushFromVC:self_weak_
                   requestParams:nil
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sorry{
    NSLog(@"手滑，点错了");
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self.tableView.mj_header endRefreshing];
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
        [cell richElementsInCellWithModel:nil];
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
        [_titleMutArr addObject:@"已付款"];
        [_titleMutArr addObject:@"取消订单"];
    }return _titleMutArr;
}

@end

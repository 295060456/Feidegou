//
//  OrderManager_panicBuying.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "OrderManager_panicBuyingVC.h"
#import "SearchView.h"
#import "OrderListTBVCell.h"
#import "OrderManager_panicBuyingVC+VM.h"
#import "OrderListVC.h"
#import "OrderManagerTBViewForHeader.h"

@interface OrderManager_panicBuyingVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)TimeManager *timeManager;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;
@property(nonatomic,assign)BusinessType businessType;

@end

@implementation OrderManager_panicBuyingVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    @weakify(self)
//    [_timeManager endGCDTimer];
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderManager_panicBuyingVC *vc = OrderManager_panicBuyingVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.page = 1;
    vc.businessType = BusinessType_ALL;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {

    }
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

+(instancetype)initWithrequestParams:(nullable id)requestParams
                             success:(DataBlock)block{
    OrderManager_panicBuyingVC *vc = OrderManager_panicBuyingVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.businessType = BusinessType_ALL;
    vc.page = 1;
    return vc;
}

-(instancetype)init{
    if (self = [super init]) {

    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navigationBar.hidden = YES;
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.gk_interactivePopDisabled = YES;//禁止手势侧滑
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"KKK_viewWillAppear");
#warning KKK
//    [self networking_platformType:PlatformType_Stall];
}

-(void)viewWillDisappear:(BOOL)animated{//在这种框架下几乎等同于dealloc
    [super viewWillDisappear:animated];
    NSLog(@"KKK_viewWillDisappear");
//    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— JXCategoryListContentViewDelegate
/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear{
     NSLog(@"KKK_listDidAppear");
    [self.timeManager startGCDTimer];
    [self.tableView.mj_header beginRefreshing];
}
/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear{
    NSLog(@"KKK_listDidDisappear");
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
    [self.timeManager endGCDTimer];
    self.timeManager = nil;
}
#pragma mark —— 私有方法
-(void)GCDtimer{
    //轮询
    NSLog(@"轮询_OrderManager_panicBuyingVC");
    //KKK
    [self networking_type:self.businessType];//默认查当前页
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
//    if (self.dataMutArr) {
//        [self.dataMutArr removeAllObjects];
//    }
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.page++;
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    OrderManagerTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[OrderManagerTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                           withData:self.btnTitleMutArr];
        @weakify(self)
        [viewForHeader clickBlock:^(id data) {
            @strongify(self)
            NSLog(@"");
            if ([data isKindOfClass:[MMButton class]]) {
                MMButton *btn = (MMButton *)data;
                if (btn.selected) {

                }else{}
                if ([btn.titleLabel.text isEqualToString:@"已下单"]) {//2
                    if (btn.selected) {
                        self.businessType = BusinessType_HadOrdered;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else if ([btn.titleLabel.text isEqualToString:@"已发货"]){//4
                    if (btn.selected) {
                        self.businessType = BusinessType_HadConsigned;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else if ([btn.titleLabel.text isEqualToString:@"已取消"]){//3
                    if (btn.selected) {
                        self.businessType = BusinessType_HadCompleted;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else{}
            }
        }];
        [viewForHeader headerViewWithModel:nil];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [OrderManagerTBViewForHeader headerViewHeightWithModel:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderListTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    //
    //先移除数据源
    //
    self.isDelCell = YES;
    
//    [self.dataMutArr removeObjectAtIndex:indexPath.row];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                    withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.dataMutArr.count) {
        @weakify(self)
        OrderManager_panicBuyingModel *orderListModel = self.dataMutArr[indexPath.row];
        [OrderDetailVC ComingFromVC:self_weak_
                          withStyle:ComingStyle_PUSH
                      requestParams:orderListModel
                            success:^(id data) {}
                           animated:YES];
    }else{
        NSLog(@"等待数据");
    }
    
//    if ([orderListModel.identity isEqualToString:@"买家"]) {
//        [OrderDetail_BuyerVC pushFromVC:self_weak_
//                          requestParams:orderListModel
//                                success:^(id data) {}
//                               animated:YES];
//    }else if ([orderListModel.identity isEqualToString:@"卖家"]){
//        [OrderDetail_SellerVC pushFromVC:self_weak_
//                           requestParams:orderListModel
//                                 success:^(id data) {}
//                                animated:YES];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListTBVCell *cell = [OrderListTBVCell cellWith:tableView];
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isDelCell) {
        //设置Cell的动画效果为3D效果
        //设置x和y的初始值为0.1；
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
    }
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"picLoadErr"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.tableFooterView = UIView.new;
        _tableView.mj_footer.hidden = YES;
//        _tableView.contentOffset = CGPointMake(0, SCALING_RATIO(20));
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(SCALING_RATIO(50));
        }];
    }return _tableView;
}

-(NSMutableArray<OrderManager_panicBuyingModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)btnTitleMutArr{
    if (!_btnTitleMutArr) {
        _btnTitleMutArr = NSMutableArray.array;
        [_btnTitleMutArr addObject:@"已下单"];
        [_btnTitleMutArr addObject:@"已发货"];
        [_btnTitleMutArr addObject:@"已取消"];
    }return _btnTitleMutArr;
}

-(TimeManager *)timeManager{
    if (!_timeManager) {
        _timeManager = TimeManager.new;
        @weakify(self)
        [_timeManager GCDTimer:@selector(GCDtimer)
                        caller:self_weak_
                      interval:3];
    }return _timeManager;
}

@end

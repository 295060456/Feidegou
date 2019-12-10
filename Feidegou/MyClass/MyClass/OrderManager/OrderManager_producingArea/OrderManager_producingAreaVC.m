//
//  OrderManager_producingAreaVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderManager_producingAreaVC.h"
#import "SearchView.h"
#import "OrderListTBVCell.h"
#import "OrderManager_producingAreaVC+VM.h"
#import "OrderListVC.h"
#import "OrderManagerTBViewForHeader.h"

@interface OrderManager_producingAreaVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)SearchView *searchView;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;
@property(nonatomic,assign)BusinessType businessType;

@end

@implementation OrderManager_producingAreaVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderManager_producingAreaVC *vc = OrderManager_producingAreaVC.new;
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
    OrderManager_producingAreaVC *vc = OrderManager_producingAreaVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.page = 1;
    vc.businessType = BusinessType_ALL;
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
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{//在这种框架下几乎等同于dealloc
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— JXCategoryListContentViewDelegate
/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear{
    [self.tableView.mj_header beginRefreshing];
}
/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear{
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    self.page = 1;
    [self networking_type:self.businessType];
//    [self.tableView.mj_header endRefreshing];
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
            if ([data isKindOfClass:[MMButton class]]){
                MMButton *btn = (MMButton *)data;//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成;默认查全部
                if ([btn.titleLabel.text isEqualToString:@"已下单"]) {//2
                    if (btn.selected) {
                        self.businessType = BusinessType_HadOrdered;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else if ([btn.titleLabel.text isEqualToString:@"已支付"]){//0
                    if (btn.selected) {
                        self.businessType = BusinessType_HadPaid;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else if ([btn.titleLabel.text isEqualToString:@"已发货"]){//4
                    if (btn.selected) {
                        self.businessType = BusinessType_HadConsigned;
                    }else{
                        self.businessType = BusinessType_ALL;
                    }
                }else{}
                if (self.dataMutArr.count) {
                    [self.dataMutArr removeAllObjects];
                }
                [self networking_type:self.businessType];//默认查当前页
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
    if (self.dataMutArr.count) {
        @weakify(self)
        OrderManager_producingAreaModel *orderListModel = self.dataMutArr[indexPath.row];
        [OrderDetailVC ComingFromVC:self_weak_
                          withStyle:ComingStyle_PUSH
                      requestParams:orderListModel
                            success:^(id data) {}
                           animated:YES];
    }
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
    }
    return cell;
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
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"picLoadErr"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.tableFooterView = UIView.new;
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-60));
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(SCALING_RATIO(50));
        }];
    }return _tableView;
}

-(NSMutableArray<OrderManager_producingAreaModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)btnTitleMutArr{
    if (!_btnTitleMutArr) {
        _btnTitleMutArr = NSMutableArray.array;
        [_btnTitleMutArr addObject:@"已下单"];
        [_btnTitleMutArr addObject:@"已支付"];
        [_btnTitleMutArr addObject:@"已发货"];
    }return _btnTitleMutArr;
}

@end

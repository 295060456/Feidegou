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
@property(nonatomic,assign)BOOL selected;

@end

@implementation OrderManager_producingAreaVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)CominngFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderManager_producingAreaVC *vc = OrderManager_producingAreaVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
//    vc.page = 1;
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
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navigationBar.hidden = YES;
    self.tableView.alpha = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CategoryViewActionNotification:)
                                                 name:@"CategoryViewAction"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)CategoryViewActionNotification:(NSNotification *)notification{
    NSNumber *b = notification.object;
    if ([b intValue] == 1) {
        NSLog(@"2");
        if (self.dataMutArr.count) {
            @weakify(self)
            UIEdgeInsets inset = [self.tableView contentInset];
            if (!self.selected) {
                inset.top = SCALING_RATIO(50);
                [UIView animateWithDuration:1.f
                                      delay:0.f
                                    options:UIViewAnimationOptionTransitionCurlDown
                                 animations:^{
                    @strongify(self)
                    self.searchView.alpha = 1;
                }
                                 completion:^(BOOL finished) {
                    
                }];
            }else{
                inset.top = SCALING_RATIO(0);
                [UIView animateWithDuration:1.f
                                      delay:0.f
                                    options:UIViewAnimationOptionTransitionCurlUp
                                 animations:^{
                    @strongify(self)
                    self.searchView.alpha = 0;
                }
                                 completion:^(BOOL finished) {
                    
                }];
            }
            [self.tableView setContentInset:inset];
            //获取到需要跳转位置的行数
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0
                                                              inSection:0];
            //滚动到其相应的位置
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:YES];
            self.selected = !self.selected;
        }
    }
}

//-(void)filterBtnClickEvent:(UIButton *)sender{
//    if (self.dataMutArr.count) {//不加这个判断会崩
//            @weakify(self)
//        UIEdgeInsets inset = [self.tableView contentInset];
//        if (!sender.selected) {
//            inset.top = SCALING_RATIO(50);
//            [UIView animateWithDuration:1.f
//                                  delay:0.f
//                                options:UIViewAnimationOptionTransitionCurlDown
//                             animations:^{
//                @strongify(self)
//                self.viewer.alpha = 1;
//            }
//                             completion:^(BOOL finished) {
//                
//            }];
//        }else{
//            inset.top = SCALING_RATIO(0);
//            [UIView animateWithDuration:1.f
//                                  delay:0.f
//                                options:UIViewAnimationOptionTransitionCurlUp
//                             animations:^{
//                @strongify(self)
//                self.viewer.alpha = 0;
//            }
//                             completion:^(BOOL finished) {
//                
//            }];
//        }
//        [self.tableView setContentInset:inset];
//        //获取到需要跳转位置的行数
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0
//                                                          inSection:0];
//        //滚动到其相应的位置
//        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
//                atScrollPosition:UITableViewScrollPositionBottom
//                                        animated:YES];
//        sender.selected = !sender.selected;
//    }
//}

#pragma mark —— JXCategoryListContentViewDelegate
/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear{
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self networking_platformType:PlatformType_ProducingArea];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.page++;
    [self pullToRefresh];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
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
    
    @weakify(self)
    OrderListModel *orderListModel = self.dataMutArr[indexPath.row];
    [OrderDetailVC pushFromVC:self_weak_
                requestParams:orderListModel
                      success:^(id data) {}
                     animated:YES];
    
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
    }
    return cell;
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
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(SCALING_RATIO(-30));
        }];
    }return _tableView;
}

-(SearchView *)searchView{
    if (!_searchView) {
        _searchView = SearchView.new;
        [self.view addSubview:_searchView];
        
    }return _searchView;
}

-(NSMutableArray<OrderListModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}


@end

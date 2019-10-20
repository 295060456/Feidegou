//
//  CatFoodsManagementVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC.h"
#import "OrderListVC.h"//订单
#import "ShopReceiptQRcodeVC.h"//店铺收款码"

@interface CatFoodsManagementVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;

@property(nonatomic,strong)NSMutableArray <NSArray *>*titleMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

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

#pragma mark - Lifecycle
-(instancetype)init{
    
    if (self = [super init]) {
        
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.navigationItem.title = @"喵粮管理";
    self.gk_navTitle = @"喵粮管理";
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.tableView.mj_header endRefreshing];
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }else{
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [OrderListVC pushFromVC:self
                      requestParams:Nil
                            success:^(id data) {
                
            }
                           animated:YES];
        }else if (indexPath.row == 1){
            [ShopReceiptQRcodeVC pushFromVC:self
                              requestParams:Nil
                                    success:^(id data) {
            }
                                   animated:YES];
        }else if (indexPath.row == 2){
            
        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            return self.titleMutArr[0].count;
        }
            break;
        case 1:{
            return self.titleMutArr[1].count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleMutArr[indexPath.section][indexPath.row];
        cell.detailTextLabel.textColor = kBlueColor;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = @"0.1";
            }else{
                cell.detailTextLabel.text = @"2.1";
            }
        }
    } return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleMutArr.count;
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(MJRefreshGifHeader *)tableViewHeader{
    if (!_tableViewHeader) {
        _tableViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                          refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"猫粮")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewHeader setImages:@[kIMG(@"猫咪")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"猫爪")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewHeader setTitle:@"Click or drag down to refresh" forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"猫粮")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewFooter setImages:@[kIMG(@"猫咪")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"猫爪")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewFooter setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
        _tableViewFooter.hidden = YES;
    }return _tableViewFooter;
}

-(NSMutableArray<NSArray *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@[@"余额",@"出售中"]];
        [_titleMutArr addObject:@[@"喵粮订单管理",@"店铺收款码",@"赠送"]];
    }return _titleMutArr;
}


@end

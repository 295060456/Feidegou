//
//  VendorGoosListController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/31.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorGoosListController.h"
#import "CellVendorGoodList.h"
#import "VendorDetailGoodController.h"
#import "JJHttpClient+ShopGood.h"

@interface VendorGoosListController ()
<RefreshControlDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tabGood;
@property (strong, nonatomic) NSMutableArray *arrGood;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量

@end

@implementation VendorGoosListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGoodList"
                                             bundle:nil]
       forCellReuseIdentifier:@"CellVendorGoodList"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGood
                                                                        delegate:self];
    [self.refreshControl beginRefreshingMethod];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    __weak VendorGoosListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodVendorOtherGoodGoods_store_id:[NSString stringStandard:self.strStoreID]
                                                                                 andLimit:@"10"
                                                                                  andPage:@"1"
                                                                     andrealstore_approve:@"1"]
                         subscribeNext:^(NSArray* array) {
        if (myself.intPageIndex == 1) {
            myself.arrGood = [NSMutableArray array];
        }
        [myself.arrGood addObjectsFromArray:array];
        [myself.tabGood reloadData];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.tabGood checkNoData:myself.arrGood.count];
        [myself.refreshControl endRefreshing];
    }completed:^{
        myself.disposable = nil;
        myself.intPageIndex++;
        [myself.tabGood checkNoData:myself.arrGood.count];
        [myself.refreshControl endRefreshing];
    }];
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    self.intPageIndex = 1;
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}

-(void)refreshControlForLoadMoreData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}
//在此代理方法中判断数据是否加载完成,
-(BOOL)refreshControlForDataLoadingFinished{
    //从服务器返回的每页数据数量,可以判断出服务器是否没有数据了
    if (self.curCount < 10) {
        return YES;
    }return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.arrGood.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellVendorGoodList *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodList"];
    [cell populataData:self.arrGood[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ModelGood *model = self.arrGood[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
    VendorDetailGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailGoodController"];
    controller.strGoodId = model.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

//
//  GoodOtherListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodOtherListController.h"
#import "JJHttpClient+ShopGood.h"
#import "GoodDetialAllController.h"
#import "CellGoodList.h"

@interface GoodOtherListController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabGoodOtherList;
@property (strong, nonatomic) NSMutableArray *arrGoodOhterList;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;

@end

@implementation GoodOtherListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    
    [self.tabGoodOtherList registerNib:[UINib nibWithNibName:@"CellGoodList" bundle:nil] forCellReuseIdentifier:@"CellGoodList"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGoodOtherList delegate:self];
    [self.refreshControl beginRefreshingMethod];
}

- (void)requestExchangeList{
    
    __weak GoodOtherListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodVendorOtherGoodGoods_store_id:[NSString stringStandard:self.strGoods_store_id] andLimit:@"10" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray *array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrGoodOhterList = [NSMutableArray array];
        }
        [myself.arrGoodOhterList addObjectsFromArray:array];
        [myself.tabGoodOtherList reloadData];
        [myself.tabGoodOtherList checkNoData:self.arrGoodOhterList.count];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        
        [myself.tabGoodOtherList checkNoData:self.arrGoodOhterList.count];
    }completed:^{
        myself.intPageIndex++;
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
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
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrGoodOhterList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellGoodList *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodList"];
    [cell populateData:self.arrGoodOhterList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self pushToGoodDetial:indexPath];
}
- (void)pushToGoodDetial:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
    ModelGood *model = self.arrGoodOhterList[indexPath.row];
    controller.strGood_id = model.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  BillHistoryController.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/1/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "BillHistoryController.h"
#import "CellVendorBill.h"
#import "JJHttpClient+ShopGood.h"

@interface BillHistoryController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabHistory;

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrHistory;

@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;
@end

@implementation BillHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabHistory setBackgroundColor:[UIColor clearColor]];
    [self.tabHistory registerNib:[UINib nibWithNibName:@"CellVendorBill" bundle:nil] forCellReuseIdentifier:@"CellVendorBill"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabHistory delegate:self];
    [self.refreshControl beginRefreshingMethod];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    __weak BillHistoryController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodVendorBillHistoryuser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId andLimit:@"10" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray* array) {
        if (myself.intPageIndex == 1) {
            myself.arrHistory = [NSMutableArray array];
        }
        [myself.arrHistory addObjectsFromArray:array];
        [myself.tabHistory reloadData];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
        [myself.tabHistory checkNoData:myself.arrHistory.count];
    }completed:^{
        myself.intPageIndex++;
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
        [myself.tabHistory checkNoData:myself.arrHistory.count];
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

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrHistory.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellVendorBill *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorBill"];
    [cell populateData:self.arrHistory[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

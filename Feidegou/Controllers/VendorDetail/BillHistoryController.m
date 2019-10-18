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

@interface BillHistoryController ()
<
RefreshControlDelegate
>

@property (weak, nonatomic) IBOutlet BaseTableView *tabHistory;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrHistory;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量

@end

@implementation BillHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabHistory setBackgroundColor:[UIColor clearColor]];
    [self.tabHistory registerNib:[UINib nibWithNibName:@"CellVendorBill" bundle:nil]
          forCellReuseIdentifier:@"CellVendorBill"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabHistory
                                                                        delegate:self];
    [self.refreshControl beginRefreshingMethod];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodVendorBillHistoryuser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId
                                                                            andLimit:@"10"
                                                                             andPage:TransformNSInteger(self.intPageIndex)]
                         subscribeNext:^(NSArray* array) {
        @strongify(self)
        if (self.intPageIndex == 1) {
            self.arrHistory = [NSMutableArray array];
        }
        [self.arrHistory addObjectsFromArray:array];
        [self.tabHistory reloadData];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            self.curCount = 0;
        }
        [self.tabHistory checkNoData:self.arrHistory.count];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
        [self.tabHistory checkNoData:self.arrHistory.count];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrHistory.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellVendorBill *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorBill"];
    [cell populateData:self.arrHistory[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end

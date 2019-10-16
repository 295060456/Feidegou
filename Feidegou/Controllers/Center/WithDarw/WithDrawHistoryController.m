//
//  WithDrawHistoryController.m
//  guanggaobao
//
//  Created by 谭自强 on 2016/10/24.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "WithDrawHistoryController.h"
#import "CellWithDraw.h"
#import "JJHttpClient+ShopGood.h"

@interface WithDrawHistoryController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabHistory;
@property (strong, nonatomic) NSMutableArray *arrHistory;

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;
@end

@implementation WithDrawHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    
    [self.tabHistory registerNib:[UINib nibWithNibName:@"CellWithDraw" bundle:nil] forCellReuseIdentifier:@"CellWithDraw"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabHistory delegate:self];
    [self.refreshControl beginRefreshingMethod];
    
    
}
- (void)requestData{
    __weak WithDrawHistoryController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodWithdrawHistoryLimit:@"20" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray* array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrHistory = [NSMutableArray array];
        }
        [myself.arrHistory addObjectsFromArray:array];
        [myself.tabHistory reloadData];
        [myself.tabHistory checkNoData:myself.arrHistory.count];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.tabHistory checkNoData:myself.arrHistory.count];
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
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
    if ([self respondsToSelector:@selector(requestData)]) {
        [self requestData];
    }
}
-(void)refreshControlForLoadMoreData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestData)]) {
        [self requestData];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellWithDraw *cell=[tableView dequeueReusableCellWithIdentifier:@"CellWithDraw"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.fWidthPre = 10;
    [cell.lblMoney setTextNull:[NSString stringStandardFloatTwo:self.arrHistory[indexPath.row][@"cash_amount"]]];
    [cell.lblTime setTextNull:[PublicFunction translateTimeHMS:self.arrHistory[indexPath.row][@"addTime"]]];
    NSString *strState = self.arrHistory[indexPath.row][@"cash_status"];
//    有 cash_status 0未处理 1提现成功， -1未通过审核
    if ([strState intValue]==1) {
        [cell.lblState setTextNull:@"提现成功"];
        [cell.lblState setTextColor:ColorHeader];
    }else if ([strState intValue]==-1) {
        [cell.lblState setTextNull:@"未通过审核"];
        [cell.lblState setTextColor:ColorRed];
    }else{
        [cell.lblState setTextNull:@"待处理"];
        [cell.lblState setTextColor:ColorBlack];
    }
    return cell;
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

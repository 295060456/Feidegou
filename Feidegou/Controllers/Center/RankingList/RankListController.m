//
//  RankListController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "RankListController.h"
#import "CellPHBTopThree.h"
#import "JJHttpClient+ShopGood.h"

@interface RankListController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabRank;
@property (strong, nonatomic) NSMutableArray *arrRankingList;

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;

@end

@implementation RankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.tabRank registerNib:[UINib nibWithNibName:@"CellPHBTopThree" bundle:nil] forCellReuseIdentifier:@"CellPHBTopThree"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabRank delegate:self];
    [self.refreshControl beginRefreshingMethod];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestExchangeList{
    //RANKING_1-RANKING_7
    //分别表示： 广告商数量，粉丝数量，累计收入
    //累计消费榜，广告数量，投放金额，产品销量
    //传入参数2： USAGE(3种状态：1表示按总数排名，2表示按周总数量排名，3表示按月总数量排名，默认第一个页面进入后按周总数量排名
    //             传入参数3：page（起始页），limit（每页显示数）)
    __weak RankListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodRankListLimit:@"20" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray* array) {
        if (myself.intPageIndex == 1) {
            myself.arrRankingList = [NSMutableArray array];
        }
        myself.curCount = array.count;
        [myself.arrRankingList addObjectsFromArray:array];
        [myself.tabRank reloadData];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        [myself.tabRank checkNoData:myself.arrRankingList.count];
    }completed:^{
        myself.intPageIndex++;
        [myself.refreshControl endRefreshing];
        [myself.tabRank checkNoData:myself.arrRankingList.count];
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
}//在此代理方法中判断数据是否加载完成,
-(BOOL)refreshControlForDataLoadingFinished{
    //从服务器返回的每页数据数量,可以判断出服务器是否没有数据了
    if (self.curCount < 20) {
        return YES;
    }
    return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arrRankingList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CellPHBTopThree *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPHBTopThree"];
    cell.fWidthPre = 10;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populateDataRanModel:self.arrRankingList[indexPath.row] andRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

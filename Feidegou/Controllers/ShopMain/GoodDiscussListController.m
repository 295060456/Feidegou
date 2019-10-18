//
//  GoodDiscussListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDiscussListController.h"
#import "CellDiscuss.h"
#import "JJHttpClient+ShopGood.h"

@interface GoodDiscussListController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabDiscussList;
@property (strong, nonatomic) NSMutableArray *arrDiscussList;

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;
@end

@implementation GoodDiscussListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.tabDiscussList setBackgroundColor:ColorBackground];
    [self.tabDiscussList registerNib:[UINib nibWithNibName:@"CellDiscuss" bundle:nil] forCellReuseIdentifier:@"CellDiscuss"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabDiscussList delegate:self];
    [self.refreshControl beginRefreshingMethod];
}

- (void)requestExchangeList{
    NSString *strState = @"";
    if (self.enumState == enum_discuss_good) {
        strState = @"1";
    }else if (self.enumState == enum_discuss_middle) {
        strState = @"0";
    }else if (self.enumState == enum_discuss_bad) {
        strState = @"-1";
    }
    __weak GoodDiscussListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodDiscussListGoods_id:[NSString stringStandard:self.strGood_id] andLimit:@"10" andPage:TransformNSInteger(self.intPageIndex) andState:strState andstore_id:[NSString stringStandard:self.store_id]] subscribeNext:^(NSDictionary *dictionary) {
        NSArray *array;
        if ([dictionary[@"evaluate"] isKindOfClass:[NSArray class]]) {
            array = [NSArray arrayWithArray:dictionary[@"evaluate"]];
        }else{
            array = [NSArray array];
        }
        if (myself.intPageIndex == 1) {
            myself.arrDiscussList = [NSMutableArray array];
        }
        [myself.arrDiscussList addObjectsFromArray:array];
        [myself.tabDiscussList reloadData];
        if (self.enumState == enum_discuss_all) {
            if ([self.delegete respondsToSelector:@selector(discussListNumDictonary:)]) {
                [self.delegete discussListNumDictonary:dictionary];
            }
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
        [myself.tabDiscussList checkNoData:myself.arrDiscussList.count];
    }completed:^{
        myself.intPageIndex++;
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
        [myself.tabDiscussList checkNoData:myself.arrDiscussList.count];
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
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDiscussList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strContent = self.arrDiscussList[indexPath.section][@"evaluate_info"];
    float fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-20 andFont:15.0].height+60;
    return fHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDiscuss *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDiscuss"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populataData:self.arrDiscussList[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
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

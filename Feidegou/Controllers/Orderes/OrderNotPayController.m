//
//  OrderNotPayController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderNotPayController.h"
#import "CellOrderVendorTitle.h"
#import "CellOrderGood.h"
#import "CellOrderOneLbl.h"
#import "CellOrderButtones.h"
#import "OrderDetailController.h"
#import "JJHttpClient+ShopGood.h"

@interface OrderNotPayController ()
<
RefreshControlDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tabNotPay;
@property (strong, nonatomic) NSMutableArray *arrGoods;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量

@end

@implementation OrderNotPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabNotPay setBackgroundColor:ColorBackground];
    [self.tabNotPay registerNib:[UINib nibWithNibName:@"CellOrderVendorTitle" bundle:nil] forCellReuseIdentifier:@"CellOrderVendorTitle"];
    [self.tabNotPay registerNib:[UINib nibWithNibName:@"CellOrderGood" bundle:nil] forCellReuseIdentifier:@"CellOrderGood"];
    [self.tabNotPay registerNib:[UINib nibWithNibName:@"CellOrderOneLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderOneLbl"];
    [self.tabNotPay registerNib:[UINib nibWithNibName:@"CellOrderButtones" bundle:nil] forCellReuseIdentifier:@"CellOrderButtones"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabNotPay delegate:self];
    [self.refreshControl beginRefreshingMethod];
}

- (void)requestExchangeList{
    __weak OrderNotPayController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderListLimit:@"10"
                                                                   andPage:TransformNSInteger(self.intPageIndex)
                                                           andOrder_status:@"10"
                                                                andUser_id:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]]
                         subscribeNext:^(NSArray* array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrGoods = [NSMutableArray array];
        }
        [myself.arrGoods addObjectsFromArray:array];
        [myself.tabNotPay reloadData];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrGoods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40.0f;
    }else if (indexPath.row == 1){
        return 90.0f;
    }else if (indexPath.row == 2){
        return 40.0f;
    }else if (indexPath.row == 3){
        return 40.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrGoods[indexPath.section]];
        return cell;
    }
    if (indexPath.row == 1) {
        CellOrderGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGood"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *viBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [viBack setBackgroundColor:ColorFromRGB(246, 247, 248)];
        [cell setBackgroundView:viBack];
        [cell populateData:self.arrGoods[indexPath.section]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        CellOrderOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderOneLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrGoods[indexPath.section]];
        return cell;
    }
    CellOrderButtones *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderButtones"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell populateData:self.arrGoods[indexPath.section]];
    [cell populateDataOrderList:self.arrGoods[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    OrderDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end

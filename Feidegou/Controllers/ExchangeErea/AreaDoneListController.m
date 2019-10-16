//
//  AreaDoneListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaDoneListController.h"
#import "CellOrderVendorTitle.h"
#import "CellOrderGood.h"
#import "CellOrderOneLbl.h"
#import "CellOrderButtones.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "UIButton+Joker.h"
#import "GoodOtherListController.h"
#import "AreaExchangeListController.h"
#import "OrderLogisticsDetailController.h"
#import "AreaDoneDetailController.h"

@interface AreaDoneListController ()
<
RefreshControlDelegate
>
@property (weak, nonatomic) IBOutlet BaseTableView *tabAreaOrder;
@property (strong, nonatomic) NSMutableArray *arrGoods;
@property (nonatomic,strong) RACDisposable *disposableDelete;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;

@end

@implementation AreaDoneListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabAreaOrder setBackgroundColor:ColorBackground];
    [self.tabAreaOrder registerNib:[UINib nibWithNibName:@"CellOrderVendorTitle" bundle:nil] forCellReuseIdentifier:@"CellOrderVendorTitle"];
    [self.tabAreaOrder registerNib:[UINib nibWithNibName:@"CellOrderGood" bundle:nil] forCellReuseIdentifier:@"CellOrderGood"];
    [self.tabAreaOrder registerNib:[UINib nibWithNibName:@"CellOrderOneLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderOneLbl"];
    [self.tabAreaOrder registerNib:[UINib nibWithNibName:@"CellOrderButtones" bundle:nil] forCellReuseIdentifier:@"CellOrderButtones"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabAreaOrder delegate:self];
    [self.refreshControl beginRefreshingMethod];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationPaySucceedChangeData:) name:NotificationNamePaySucceedChangeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationDiscussSucceed:) name:NotificationNameDiscussSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationOrderDelete:) name:NotificationNameOrderDelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationOrderGetSucceed:) name:NotificationNameOrderGetSucceed object:nil];
}
- (void)NotificationPaySucceedChangeData:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelAreaList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.orderId);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.igo_status = @"20";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self.tabAreaOrder reloadData];
            [self.tabAreaOrder checkNoData:self.arrGoods.count];
        }
    }
}
- (void)NotificationDiscussSucceed:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelAreaList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.orderId);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.igo_status = @"50";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self.tabAreaOrder reloadData];
            [self.tabAreaOrder checkNoData:self.arrGoods.count];
        }
    }
}

- (void)NotificationOrderDelete:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelAreaList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.orderId);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            [self.arrGoods removeObject:modelList];
            [self.tabAreaOrder reloadData];
            [self.tabAreaOrder checkNoData:self.arrGoods.count];
        }
    }
}

- (void)NotificationOrderGetSucceed:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelAreaList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.orderId);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.igo_status = @"40";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self.tabAreaOrder reloadData];
            [self.tabAreaOrder checkNoData:self.arrGoods.count];
        }
    }
}
- (void)requestExchangeList{
    NSString *strOrderState = @"";
    if (self.orderState != enumOrder_quanbu) {
        strOrderState = TransformNSInteger(self.orderState);
    }
    __weak AreaDoneListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderListAreaExchangeLimit:@"10" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray* array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrGoods = [NSMutableArray array];
        }
        [myself.arrGoods addObjectsFromArray:array];
        [myself.tabAreaOrder reloadData];
        [myself.tabAreaOrder checkNoData:myself.arrGoods.count];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.tabAreaOrder checkNoData:myself.arrGoods.count];
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
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrGoods.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataArea:self.arrGoods[indexPath.section]];
        return cell;
    }
    if (indexPath.row == 1) {
        CellOrderGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGood"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *viBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [viBack setBackgroundColor:ColorFromRGB(246, 247, 248)];
        [cell setBackgroundView:viBack];
        [cell populateDataArea:self.arrGoods[indexPath.section]];
        return cell;
    }
    
    if (indexPath.row == 2) {
        CellOrderOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderOneLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataArea:self.arrGoods[indexPath.section]];
        return cell;
    }
    CellOrderButtones *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderButtones"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell populateDataArea:self.arrGoods[indexPath.section]];
    
    [cell populateDataOrderList:self.arrGoods[indexPath.section]];
    [cell.btnOne handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self clickButtonForListName:cell.btnOne.titleLabel.text andIndexPath:self.arrGoods[indexPath.section]];
    }];
    [cell.btnTwo handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self clickButtonForListName:cell.btnTwo.titleLabel.text andIndexPath:self.arrGoods[indexPath.section]];
    }];
    return cell;
}
- (void)clickButtonForListName:(NSString *)strTitle andIndexPath:(ModelAreaList *)model{
    if ([TransformString(strTitle) isEqualToString:@"查看订单"]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaDoneDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaDoneDetailController"];
        controller.modelList = model;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"查看物流"]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
        controller.strPath = model.path;
        controller.strCount = model.count;
        controller.strGoodCode = model.igo_ship_code;
        controller.strCompanyCode = model.ship_code;
        controller.strCompanyName = model.ship_name;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ModelAreaList *modelList = self.arrGoods[indexPath.section];
    if (indexPath.row == 0) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaExchangeListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaExchangeListController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaDoneDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaDoneDetailController"];
        controller.modelList = modelList;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end

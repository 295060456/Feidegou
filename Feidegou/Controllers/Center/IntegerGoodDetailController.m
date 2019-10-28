//
//  IntegerGoodDetailController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/15.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "IntegerGoodDetailController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellOrderTwoLbl.h"
#import "CellOrderMoney.h"
#import "CellOneLabel.h"
#import "CellOrderButtones.h"
#import "CellOrderGiftNo.h"
#import "PayMonyForGoodController.h"
#import "UIButton+Joker.h"
#import "OrderLogisticsDetailController.h"

@interface IntegerGoodDetailController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabInteger;

@property (nonatomic,strong) NSMutableArray *arrInteger;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;
@end

@implementation IntegerGoodDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabInteger setBackgroundColor:[UIColor clearColor]];
    [self.tabInteger registerNib:[UINib nibWithNibName:@"CellOrderTwoLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderTwoLbl"];
    [self.tabInteger registerNib:[UINib nibWithNibName:@"CellOrderMoney" bundle:nil] forCellReuseIdentifier:@"CellOrderMoney"];
    [self.tabInteger registerNib:[UINib nibWithNibName:@"CellOneLabel" bundle:nil] forCellReuseIdentifier:@"CellOneLabel"];
    [self.tabInteger registerNib:[UINib nibWithNibName:@"CellOrderGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftNo"];
    [self.tabInteger registerNib:[UINib nibWithNibName:@"CellOrderButtones" bundle:nil] forCellReuseIdentifier:@"CellOrderButtones"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabInteger delegate:self];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshingMethod];
}
- (void)requestExchangeList{
    __weak IntegerGoodDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderListAreaExchangeLimit:@"20" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSArray* array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrInteger = [NSMutableArray array];
        }
        [myself.arrInteger addObjectsFromArray:array];
        [myself.tabInteger reloadData];
        [myself.tabInteger checkNoData:myself.arrInteger.count];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            //                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
        [myself.tabInteger checkNoData:myself.arrInteger.count];
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
    if (self.curCount < 20) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int intState = [self.arrInteger[section][@"igo_status"] intValue];
    if (intState == 20) {
        return 4;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrInteger.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    }
    if (indexPath.row == 1) {
        return 80.0f;
    }
    if (indexPath.row == 2) {
        return 60.0f;
    }
    if (indexPath.row == 3) {
        return 40.0f;
    }
    if (indexPath.row == 4) {
        return 40.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblLeft setText:StringFormat(@"订单号:%@",self.arrInteger[indexPath.section][@"ig_goods_sn"])];
        
        
        NSString *strType = @"交易成功";
        int intState = [self.arrInteger[indexPath.section][@"igo_status"] intValue];
        if (intState == 10) {
            strType = @"待付款";
        }else if (intState == 20) {
            strType = @"待发货";
        }else{
            strType = @"交易成功";
        }
        [cell.lblRight setText:strType];
        [cell.lblLeft setTextColor:ColorBlack];
        [cell.lblRight setTextColor:ColorHeader];
        return cell;
    }
    if (indexPath.row == 1) {
        CellOrderGiftNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGiftNo"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.imgHead setImagePathListSquare:self.arrInteger[indexPath.section][@"icon"]];
        [cell.lblName setTextNull:self.arrInteger[indexPath.section][@"ig_goods_name"]];
        [cell.lblPrice setTextNull:StringFormat(@"%@积分",self.arrInteger[indexPath.section][@"ig_goods_integral"])];
        [cell.lblPrice setTextColor:ColorHeader];
        [cell.lblAttributeName setText:@""];
        [cell.lblNum setTextNull:@"x1"];
        
        return cell;
    }
    if (indexPath.row == 2) {
        
        CellOrderMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderMoney"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblUp setTextAlignment:NSTextAlignmentLeft];
        [cell.lblDown setTextAlignment:NSTextAlignmentLeft];
        [cell.lblUp setFont:[UIFont systemFontOfSize:14.0]];
        [cell.lblDown setFont:[UIFont systemFontOfSize:14.0]];
        [cell.lblUp setTextColor:ColorGaryDark];
        [cell.lblDown setTextColor:ColorGaryDark];
        [cell.lblUp setTextNull:StringFormat(@"下单时间:%@",self.arrInteger[indexPath.section][@"addTime"])];
        [cell.lblDown setTextNull:StringFormat(@"支付时间:%@",[NSString stringStandard:self.arrInteger[indexPath.section][@"igo_pay_time"]])];
        return cell;
    }
    if (indexPath.row == 3) {
        
        CellOneLabel *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneLabel"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblContent setTextAlignment:NSTextAlignmentRight];
        [cell.lblContent setTextNull:StringFormat(@"共1件商品 实付款(含运费):%@积分+￥%@",self.arrInteger[indexPath.section][@"igo_total_integral"],self.arrInteger[indexPath.section][@"ig_transfee"])];
        return cell;
    }
    if (indexPath.row == 4) {
        CellOrderButtones *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderButtones"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.btnThree setHidden:YES];
        [cell.btnTwo setHidden:YES];
        int intState = [self.arrInteger[indexPath.section][@"igo_status"] intValue];
        if (intState == 10) {
            [cell.btnOne setHidden:NO];
            [cell.btnOne setTitle:@"去付款" forState:UIControlStateNormal];
        }else if (intState == 20) {
            [cell.btnOne setHidden:YES];
        }else{
            [cell.btnOne setHidden:NO];
            [cell.btnOne setTitle:@"查看物流" forState:UIControlStateNormal];
        }
        [cell.btnOne handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (intState == 10) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
                PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
                controller.strOrderId = self.arrInteger[indexPath.section][@"igo_order_sn"];
                controller.isJifen = YES;
                controller.strTotalPrice = StringFormat(@"%.2f",([self.arrInteger[indexPath.section][@"igo_total_integral"] floatValue]+[self.arrInteger[indexPath.section][@"ig_transfee"] floatValue]-[self.arrInteger[indexPath.section][@"payIntegral"] floatValue]));
                controller.not_cash_total = StringFormat(@"%.2f",([self.arrInteger[indexPath.section][@"igo_total_integral"] floatValue]+[self.arrInteger[indexPath.section][@"ig_transfee"] floatValue]));
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
                OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
                controller.strPath = self.arrInteger[indexPath.section][@"icon"];
                controller.strCount = @"1";
                controller.strGoodCode = self.arrInteger[indexPath.section][@"igo_ship_code"];
                controller.strCompanyCode = self.arrInteger[indexPath.section][@"company_mark"];
                controller.strCompanyName = self.arrInteger[indexPath.section][@"company_name"];
                controller.strCompanyName = self.arrInteger[indexPath.section][@"company_name"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
        return cell;
    }
    CellOrderMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderMoney"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblUp setTextNull:@""];
    [cell.lblDown setTextNull:@""];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||section == 4) {
        return 0;
    }else{
        return 10;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
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

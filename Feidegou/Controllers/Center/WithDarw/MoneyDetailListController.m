//
//  MoneyDetailListController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/12.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "MoneyDetailListController.h"
#import "WithDrawDepositController.h"
#import "CellIncome.h"
#import "JJHttpClient+ShopGood.h"
#import "CellBlance.h"
#import "JJDBHelper+Center.h"
#import "RedPacketTransportController.h"

@interface MoneyDetailListController ()
<
RefreshControlDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet BaseTableView *tabMoney;
@property (weak, nonatomic) IBOutlet UIView *viButton;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
@property (strong, nonatomic) NSMutableArray *arrIncome;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量
@property (nonatomic,strong) NSString *strMode;
@property (nonatomic,strong) NSString *strImage;

@end

@implementation MoneyDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viButton setBackgroundColor:ColorLine];
    [self.tabMoney registerNib:[UINib nibWithNibName:@"CellIncome" bundle:nil] forCellReuseIdentifier:@"CellIncome"];
    [self.tabMoney registerNib:[UINib nibWithNibName:@"CellBlance" bundle:nil] forCellReuseIdentifier:@"CellBlance"];
    self.layoutConstraintHeight.constant = 0;
    [self.viButton setHidden:YES];
    [self.btnNext setHidden:YES];
    [self.viButton setHidden:NO];
    if (self.numDetail == enum_numDetail_ljsy) {
        [self setTitle:@"累计收益"];
        self.strMode = @"balance";
        self.strImage = @"img_center_ljsy";
    }else if (self.numDetail == enum_numDetail_qdsye) {
        [self setTitle:@"签到送余额"];
        self.strMode = @"redbags";
        self.strImage = @"img_center_qdsye";
    }else if (self.numDetail == enum_numDetail_wdjf) {
        [self setTitle:@"我的积分"];
        self.strMode = @"integral";
        self.strImage = @"img_center_wdjf";
    }else{
        [self setTitle:@"我的团队"];
        self.strMode = @"";
        self.strImage = @"img_center_wdtd";
    }
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabMoney delegate:self];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshingMethod];
}
- (void)requestExchangeList{
    @weakify(self)
    if (self.numDetail == enum_numDetail_wdtd) {
        self.disposable = [[[JJHttpClient new] requestShopGoodIntegralDetialLimit:@"20"
                                                                            andPage:TransformNSInteger(self.intPageIndex)
                                                                          andGrouId:[NSString stringStandard:self.strGrouId]]
                             subscribeNext:^(NSArray* array) {
            @strongify(self)
            self.curCount = array.count;
            if (self.intPageIndex == 1) {
                self.arrIncome = [NSMutableArray array];
            }
            [self.arrIncome addObjectsFromArray:array];
            [self.tabMoney reloadData];
            [self.tabMoney checkNoData:self.arrIncome.count];
        }error:^(NSError *error) {
            @strongify(self)
            self.disposable = nil;
            [self.refreshControl endRefreshing];
            if (error.code!=2) {
                //                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }else{
                self.curCount = 0;
            }
            [self.tabMoney checkNoData:self.arrIncome.count];
        }completed:^{
            @strongify(self)
            self.intPageIndex++;
            [self.refreshControl endRefreshing];
            self.disposable = nil;
        }];
        
    }
    self.disposable = [[[JJHttpClient new] requestShopGoodRedpacketDetialLimit:@"20"
                                                                         andPage:TransformNSInteger(self.intPageIndex)
                                                                         andmode:self.strMode]
                         subscribeNext:^(NSArray* array) {
        @strongify(self)
        self.curCount = array.count;
        if (self.intPageIndex == 1) {
            self.arrIncome = [NSMutableArray array];
        }
        [self.arrIncome addObjectsFromArray:array];
        [self.tabMoney reloadData];
        [self.tabMoney checkNoData:self.arrIncome.count];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            //                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            self.curCount = 0;
        }
        [self.tabMoney checkNoData:self.arrIncome.count];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
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
    }return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }return self.arrIncome.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120.0f;
    }return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CellBlance *cell=[tableView dequeueReusableCellWithIdentifier:@"CellBlance"];
        if (self.numDetail == enum_numDetail_ljsy) {
            [cell.lblTip setText:@"累计收益"];
        }else if (self.numDetail == enum_numDetail_qdsye) {
            [cell.lblTip setText:@"签到送余额"];
        }else if (self.numDetail == enum_numDetail_wdjf) {
            [cell.lblTip setText:@"我的积分"];
        }else{
            [cell.lblTip setText:@"我的团队"];
        }
        NSString *strMoney;
        if(self.numDetail == enum_numDetail_wdtd){
            strMoney = [NSString stringStandardZero:self.strMoneyAll];
        }else{
            strMoney = [NSString stringStandardFloatTwo:self.strMoneyAll];
        }
        NSMutableAttributedString * atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@",strMoney)];
                                                                                                               [atrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:35]}
                                                                                                                                  range:NSMakeRange(0, atrString.length)];
        [cell.lblMoney setAttributedText:atrString];
        return cell;
    }
    CellIncome *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIncome"];
    if(self.numDetail == enum_numDetail_wdtd){
        [cell.imgType setImagePathListSquare:self.arrIncome[indexPath.row][@"photoUrl"]];                                                      [cell.lblName setTextNull:self.arrIncome[indexPath.row][@"userName"]];                                                           [cell.lblTime setTextNull:@""];                                                         [cell.lblMoney setTextNull:self.arrIncome[indexPath.row][@"addTime"]];
    } else{
        [cell.imgType setImage:ImageNamed(self.strImage)];                                                          [cell.lblName setTextNull:StringFormat(@"%@%@",self.arrIncome[indexPath.row][@"op_type"],self.arrIncome[indexPath.row][@"money"])];                                                        [cell.lblTime setTextNull:self.arrIncome[indexPath.row][@"content"]];                                                        [cell.lblMoney setTextNull:self.arrIncome[indexPath.row][@"addTime"]];
    }
    cell.fWidthPre = 10;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section ==1 && self.numDetail == enum_numDetail_wdtd&&[NSString isNullString:self.strGrouId]) {
        MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
        controller.numDetail = enum_numDetail_wdtd;
        controller.strMoneyAll = self.strMoneyAll;
        controller.strGrouId = self.arrIncome[indexPath.row][@"id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)clickButtonWithdraw:(UIButton *)sender {
    
    
}


@end

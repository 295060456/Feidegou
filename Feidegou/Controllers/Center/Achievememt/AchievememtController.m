//
//  AchievememtController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/5.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "AchievememtController.h"
#import "CellIncomeAll.h"
#import "CellIncomeDay.h"
#import "CellIncomeHeader.h"
#import "JJHttpClient+ShopGood.h"
#import "CellTwoLblArrow.h"
#import "CellMyService.h"
#import "UIButton+Joker.h"
#import "MoneyDetailListController.h"
#import "WithDrawDepositController.h"
#import "WithDrawHistoryController.h"

@interface AchievememtController ()
@property (weak, nonatomic) IBOutlet UITableView *tabIncome;
@property (strong, nonatomic)  NSDictionary *dicOnline;
@property (strong, nonatomic)  NSDictionary *dicOutline;
@property (nonatomic,strong) RACDisposable *disposableOutline;
@property (nonatomic,assign) BOOL isOutline;//如果isOutLine为YES，显示线下，为NO显示线上。
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation AchievememtController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.btnNext setBackgroundColor:ColorHeader];
    [self.tabIncome setBackgroundColor:[UIColor clearColor]];
    [self.tabIncome registerNib:[UINib nibWithNibName:@"CellIncomeAll" bundle:nil] forCellReuseIdentifier:@"CellIncomeAll"];
    [self.tabIncome registerNib:[UINib nibWithNibName:@"CellIncomeDay" bundle:nil] forCellReuseIdentifier:@"CellIncomeDay"];
    [self.tabIncome registerNib:[UINib nibWithNibName:@"CellIncomeHeader" bundle:nil] forCellReuseIdentifier:@"CellIncomeHeader"];
    [self.tabIncome registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    [self.tabIncome registerNib:[UINib nibWithNibName:@"CellMyService" bundle:nil] forCellReuseIdentifier:@"CellMyService"];
    if (@available(iOS 11.0, *)) {
        self.tabIncome.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self showException];
    [self requestOnline];
    [self requestOutline];
}
- (void)requestOnline{
    if (self.disposable||self.dicOnline) {
        [self.tabIncome reloadData];
        return;
    }
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodChivement:@"online"] subscribeNext:^(NSDictionary *dictionary) {
        @strongify(self)
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.dicOnline = [NSDictionary dictionaryWithDictionary:dictionary];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.tabIncome reloadData];
        [self failedRequestException:enum_exception_timeout];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
        [self.tabIncome reloadData];
        [self hideException];
    }];
}

- (void)requestOutline{
    if (self.disposableOutline ||
        self.dicOutline) {
        [self.tabIncome reloadData];
        return;
    }
    @weakify(self)
    self.disposableOutline = [[[JJHttpClient new] requestShopGoodChivement:@"outline"] subscribeNext:^(NSDictionary *dictionary) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            @strongify(self)
            self.dicOutline = [NSDictionary dictionaryWithDictionary:dictionary];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableOutline = nil;
        [self.tabIncome reloadData];
    }completed:^{
        @strongify(self)
        self.disposableOutline = nil;
        [self.tabIncome reloadData];
    }];
    
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (section == 0||section == 1) {
        return 1;
    }
    if (section == 2||section == 3||section == 4) {
        return 2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }
    if (indexPath.section == 1) {
        return 100;
    }
    if (indexPath.section == 2||indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 40;
        }
        return 60;
    }
    if (indexPath.section == 4) {
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary;
    @weakify(self)
    if (self.isOutline) {
        dictionary = [NSDictionary dictionaryWithDictionary:self.dicOutline];
    }else{
        dictionary = [NSDictionary dictionaryWithDictionary:self.dicOnline];
    }
    if (indexPath.section == 0) {
        CellIncomeHeader *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIncomeHeader"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.btnOnline setSelected:!self.isOutline];
        [cell.btnOutLine setSelected:self.isOutline];
        NSString *strMoney = [NSString stringStandardFloatTwo:dictionary[@"monthCensus"][@"totalCommon"]];
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@\n累计结算收益",strMoney)];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, strMoney.length)];
        [cell.lblMoney setAttributedText:atrStringPrice];
        [cell.btnOnline handleControlEvent:UIControlEventTouchUpInside
                                 withBlock:^{
            @strongify(self)
            self.isOutline = NO;
            [self.tabIncome reloadData];
        }];
        [cell.btnOutLine handleControlEvent:UIControlEventTouchUpInside
                                  withBlock:^{
            @strongify(self)
            self.isOutline = YES;
            [self.tabIncome reloadData];
        }];return cell;
    }
    if (indexPath.section == 1) {
        CellIncomeAll *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIncomeAll"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblLeft setText:[NSString stringStandardZero:dictionary[@"monthCensus"][@"lastMonth"]]];
        [cell.lblMiddle setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"monthCensus"][@"thisMonth"]])];
        [cell.lblRight setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"monthCensus"][@"lastMonthMent"]])];
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row==0) {
            CellMyService *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMyService"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.imgHead setImage:ImageNamed(@"img_center_jr")];
            [cell.lblName setText:@"今日分享收益"];
            [cell.lblNum setText:@""];
            [cell.imgArrow setHidden:YES];
            return cell;
        }
        
        CellIncomeDay *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIncomeDay"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblLeft setText:[NSString stringStandardZero:dictionary[@"today"][@"count"]]];
        [cell.lblMiddle setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"today"][@"total"]])];
        [cell.lblRight setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"today"][@"share_money"]])];
        return cell;
    }
    if (indexPath.section == 3) {
        if (indexPath.row==0) {
            CellMyService *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMyService"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.imgHead setImage:ImageNamed(@"img_center_zr")];
            [cell.lblName setText:@"昨日分享收益"];
            [cell.lblNum setText:@""];
            [cell.imgArrow setHidden:YES];
            return cell;
        }
        
        CellIncomeDay *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIncomeDay"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblLeft setText:[NSString stringStandardZero:dictionary[@"yestDay"][@"count"]]];
        [cell.lblMiddle setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"yestDay"][@"total"]])];
        [cell.lblRight setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dictionary[@"yestDay"][@"share_money"]])];
        return cell;
    }
    CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
    if (indexPath.row == 0) {
        [cell.lblName setText:@"消费佣金明细"];
        [cell.lblContent setText:@""];
    }else if (indexPath.row == 1) {
        [cell.lblName setText:@"提现记录"];
        [cell.lblContent setText:@""];
    }else{
        [cell.lblName setText:@""];
        [cell.lblContent setText:@""];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
            controller.numDetail = enum_numDetail_ljsy;
            controller.strMoneyAll = self.dicOnline[@"monthCensus"][@"totalCommon"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row == 1) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil];
            WithDrawHistoryController *controller=[storyboard instantiateViewControllerWithIdentifier:@"WithDrawHistoryController"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}

- (IBAction)clickButtonDetail:(UIButton *)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil];
    WithDrawDepositController *controller=[storyboard instantiateViewControllerWithIdentifier:@"WithDrawDepositController"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end

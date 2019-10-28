//
//  PayMonyForGoodController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "PayMonyForGoodController.h"
#import "CellTwoImgOneLbl.h"
#import "CellOnlyOneLbl.h"
#import "JJHttpClient+ShopGood.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ConstantAlipay.h"
#import "JJHttpClient+ShopGood.h"
#import "JJDBHelper+Center.h"
@interface PayMonyForGoodController ()<RefreshControlDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabPayType;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (strong, nonatomic) NSMutableArray *arrPayType;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (assign,nonatomic) NSInteger intRow;
@property (strong, nonatomic) NSString *strMoney;
@property (assign, nonatomic) BOOL isShowWeixin;
@end

@implementation PayMonyForGoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    self.isShowWeixin = NO;
    [self.btnPay setBackgroundColor:ColorHeader];
    [self.tabPayType setBackgroundColor:[UIColor clearColor]];
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"支付:￥%@",[NSString stringStandardFloatTwo:self.strTotalPrice])];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} range:NSMakeRange(0, 4)];
    [self.tabPayType registerNib:[UINib nibWithNibName:@"CellOnlyOneLbl" bundle:nil] forCellReuseIdentifier:@"CellOnlyOneLbl"];
    [self.tabPayType registerNib:[UINib nibWithNibName:@"CellTwoImgOneLbl" bundle:nil] forCellReuseIdentifier:@"CellTwoImgOneLbl"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationPaySucceed:) name:NotificationNamePaySucceed object:nil];
    self.intRow = 0;
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabPayType delegate:self];
    [self.refreshControl beginRefreshingMethod];
}

- (void)NotificationPaySucceed:(NSNotification *)notification{
    JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
    [alertView showAlertView:self andTitle:nil andMessage:@"支付成功"  andCancel:@"确定" andCanelIsRed:YES andBack:^{
        D_NSLog(@"点击了确定");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceedChangeData object:self.strOrderId];
}

- (void)requestExchangeList{
    
    __weak PayMonyForGoodController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderPayWay] subscribeNext:^(NSDictionary* dictionry) {
        myself.strMoney = dictionry[@"money"];
        if ([dictionry[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithArray:dictionry[@"data"]];
            RACSequence *sequence=[array rac_sequence];
            NSArray *arrayMiddle = [[sequence map:^id(NSDictionary *item){
                ModelPayWay *model = [MTLJSONAdapter modelOfClass:[ModelPayWay class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
            
            myself.arrPayType = [NSMutableArray arrayWithArray:arrayMiddle];
            for (int i = 0; i<myself.arrPayType.count; i++) {
                ModelPayWay *model = myself.arrPayType[i];
                if ([model.recommend boolValue]) {
                    myself.intRow = i;
                }
            }
            [myself.tabPayType reloadData];
        }
        
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
    }completed:^{
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
    }];
    
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}

-(BOOL)refreshControlEnableLoadMore{
    return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.arrPayType.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        CellOnlyOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOnlyOneLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        ModelPayWay *model = self.arrPayType[self.intRow];
        NSString *strMoney = [NSString stringStandardFloatTwo:self.strTotalPrice];
        if (self.isJifen&&[TransformString(model.mark) isEqualToString:@"not_cash_balance"]) {
            strMoney = [NSString stringStandardFloatTwo:self.not_cash_total];
        }
        
        NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"订单金额:%@元",strMoney)];
        [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(5, strMoney.length+1)];
        [cell.lblContent setAttributedText:atrString];
        return cell;
    }
    ModelPayWay *model = self.arrPayType[indexPath.row];
    CellTwoImgOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoImgOneLbl"];
    if (self.intRow == indexPath.row) {
        [cell.imgSelect setImage:ImageNamed(@"img_order_select_y")];
    }else{
        [cell.imgSelect setImage:ImageNamed(@"img_order_select_n")];
    }
    [cell.lblTitle setTextNull:model.name];
    [cell.imgRecommend setHidden:![model.recommend boolValue]];
    [cell.lblTip setTextNull:@""];
    if ([TransformString(model.mark) isEqualToString:@"wxpay"]) {
        [cell.imgHead setImage:ImageNamed(@"img_orderw_wx")];
    }else if ([TransformString(model.mark) isEqualToString:@"alipay"]) {
        [cell.imgHead setImage:ImageNamed(@"img_orderw_zfb")];
    }else if ([TransformString(model.mark) isEqualToString:@"balance"]) {
        NSString *strMoney = [[JJDBHelper sharedInstance] fetchCenterMsg].availableBalance;
        if ([strMoney floatValue]==0) {
            [cell.imgHead setImage:ImageNamed(@"img_orderw_yck")];
        }else{
            [cell.imgHead setImage:ImageNamed(@"img_orderw_ycky")];
        }
//        [cell.lblTip setTextNull:StringFormat(@"可用余额%@元",[NSString stringStandardFloatTwo:strMoney])];
    }else{
        [cell.imgHead setImage:ImageNamed(@"img_orderw_hdfk")];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [viHead setBackgroundColor:ColorBackground];
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, CGRectGetHeight(viHead.frame))];
    [lblTip setText:@"请选择支付方式"];
    [lblTip setTextColor:ColorBlack];
    [lblTip setFont:[UIFont systemFontOfSize:13.0]];
    [viHead addSubview:lblTip];
    return viHead;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        self.intRow = indexPath.row;
        [self.tabPayType reloadData];
    }
}
- (void)requestDataForPayType:(NSString *)strType{
    __weak PayMonyForGoodController *myself = self;
    [SVProgressHUD showWithStatus:@"正在请求数据..."];
    self.disposable = [[[JJHttpClient new] requestShopGoodPayByType:strType andOrder_id:[NSString stringStandard:self.strOrderId]] subscribeNext:^(NSDictionary*dictinary) {
        D_NSLog(@"msg is %@",dictinary[@"msg"]);
        //        支付宝支付
        if ([dictinary[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            if ([TransformString(strType) isEqualToString:TransformString(@"alipay")]) {
                [[AlipaySDK defaultService] payOrder:dictinary[@"data"] fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
                    D_NSLog(@"alipay balance reslut = %@，memo is %@",resultDic,resultDic[@"memo"]);
                    int intStatus = [resultDic[@"resultStatus"] intValue];
                    if (intStatus==9000) {
                        //                        [SVProgressHUD showErrorWithStatus:@"订单支付成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
                    }else if (intStatus == 8000){
                        [SVProgressHUD showErrorWithStatus:@"订单正在处理中"];
                    }else if (intStatus == 4000){
                        [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
                    }else if (intStatus == 6001){
                        [SVProgressHUD showErrorWithStatus:@"取消支付"];
                    }else if (intStatus == 6002){
                        [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
                    }
                }];
            }
            //            微信支付
            if ([TransformString(strType) isEqualToString:TransformString(@"wxpay")]) {
                if ([dictinary[@"data"] isKindOfClass:[NSDictionary class]]) {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate sendPay:dictinary[@"data"]];
                }
            }
            //            预存款支付
            if ([TransformString(strType) isEqualToString:TransformString(@"balance")]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }
            //            线下支付
            if ([TransformString(strType) isEqualToString:TransformString(@"outline")]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePaySucceed object:nil];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
        }
        
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}
- (IBAction)clcikButtonPay:(UIButton *)sender {
    if (self.intRow <0 ) {
        return;
    }
    ModelPayWay *model = self.arrPayType[self.intRow];
    [self requestDataForPayType:model.mark];
//    if ([TransformString(model.mark) isEqualToString:TransformString(@"alipay")]||[TransformString(model.mark) isEqualToString:TransformString(@"wxpay")]||[TransformString(model.mark) isEqualToString:TransformString(@"balance")]||[TransformString(model.mark) isEqualToString:TransformString(@"outline")]) {
//        [self requestDataForPayType:model.mark];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"此版本暂不支持此种方式，请升级后再试"];
//    }
    
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

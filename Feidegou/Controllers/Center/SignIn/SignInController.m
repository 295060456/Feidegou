//
//  SignInController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/4.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "SignInController.h"
#import "CellSignIn.h"
#import "UIButton+Joker.h"
#import "SignInTip.h"
#import "JJHttpClient+ShopGood.h"
#import "AchievementController.h"
#import "JJHttpClient+FourZero.h"

#import "GoodsListController.h"
#import "VendorShopTypeController.h"
#import "GoodOtherListController.h"
#import "GoodDetialAllController.h"
#import "VendorDetailShopController.h"
#import "AreaExchangeListController.h"
#import "SiginShowAdverController.h"

@interface SignInController ()
<
FDAlertViewDelegate,
RefreshControlDelegate
>

@property (weak, nonatomic) IBOutlet BaseTableView *tabSignIn;
@property (nonatomic,strong) NSMutableArray *arrSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (nonatomic,assign) BOOL share;
@property (nonatomic,strong) NSDictionary *dicShare;
@property (nonatomic,strong) RefreshControl *refreshControl;

@end

@implementation SignInController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.btnSignIn setBackgroundColor:ColorGaryDark];
    [self.tabSignIn setBackgroundColor:[UIColor clearColor]];
    [self.tabSignIn registerNib:[UINib nibWithNibName:@"CellSignIn" bundle:nil] forCellReuseIdentifier:@"CellSignIn"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabSignIn delegate:self];
    [self.refreshControl beginRefreshingMethod];
    if (@available(iOS 11.0, *)) {
        self.tabSignIn.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}
- (void)refrehsButton{
    
    if (self.share) {
        [self.btnSignIn setBackgroundColor:ColorHeader];
    }else{
        [self.btnSignIn setBackgroundColor:ColorGaryDark];
    }

}
- (void)requestExchangeList{
    __weak SignInController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodSignIn] subscribeNext:^(NSDictionary* dictionary) {
        myself.share = [dictionary[@"share"] boolValue];
        [myself refrehsButton];
        if ([dictionary[@"signGoods"] isKindOfClass:[NSArray class]]) {
            myself.arrSignIn = [NSMutableArray arrayWithArray:dictionary[@"signGoods"]];
        }
    }error:^(NSError *error) {
        [myself.refreshControl endRefreshing];
        [myself.tabSignIn reloadData];
        [myself.tabSignIn checkNoData:myself.arrSignIn.count];
        myself.disposable = nil;
    }completed:^{
        [myself.refreshControl endRefreshing];
        [myself.tabSignIn reloadData];
        [myself.tabSignIn checkNoData:myself.arrSignIn.count];
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
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.arrSignIn.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellSignIn *cell=[tableView dequeueReusableCellWithIdentifier:@"CellSignIn"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.imgGood setImagePathListSquare:self.arrSignIn[indexPath.row][@"path"]];
    [cell.lblTitle setTextNull:self.arrSignIn[indexPath.row][@"goods_name"]];
    [cell.lblMoney setTextNull:self.arrSignIn[indexPath.row][@"goods_amount"]];
    if ([self.arrSignIn[indexPath.row][@"sign_status"] boolValue]) {
        [cell.viBtn setBackgroundColor:ColorGaryDark];
        [cell.btnSign setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [cell.viBtn setBackgroundColor:ColorRed];
        [cell.btnSign setTitle:@"签到" forState:UIControlStateNormal];
        [cell.btnSign handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self requestSignIn:indexPath.row];
        }];
    }
    
    [cell.lblLeftUp setText:StringFormat(@"%@/天",self.arrSignIn[indexPath.row][@"signed_day"])];
    [cell.lblMiddleUp setText:StringFormat(@"%d/天",[self.arrSignIn[indexPath.row][@"sign_day"] intValue]-[self.arrSignIn[indexPath.row][@"signed_day"] intValue])];
    [cell.lblRightUp setTextNull:self.arrSignIn[indexPath.row][@"signed_money"]];
    return cell;
}

- (void)requestSignIn:(NSInteger)intRow{
    [SVProgressHUD showWithStatus:@"正在请求数据..."];
    __weak SignInController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestFourZeroSignInGoodId:self.arrSignIn[intRow][@"id"]] subscribeNext:^(NSDictionary* dictionary) {
        if ([dictionary[@"code"] intValue]==1) {
            myself.share = YES;
            [myself refrehsButton];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
            SiginShowAdverController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SiginShowAdverController"];
            controller.dicShare = [NSDictionary dictionaryWithDictionary:dictionary];
            [self.navigationController pushViewController:controller animated:YES];

            
            NSMutableDictionary  *dicInfo = [NSMutableDictionary dictionaryWithDictionary:self.arrSignIn[intRow]];
            [dicInfo setObject:StringFormat(@"%d",[dicInfo[@"signed_day"] intValue]+1) forKey:@"signed_day"];
            [dicInfo setObject:StringFormat(@"%.2f",[dicInfo[@"signed_money"] doubleValue]+[dictionary[@"money"] doubleValue]) forKey:@"signed_money"];
            [myself.arrSignIn replaceObjectAtIndex:intRow withObject:dicInfo];
            [myself.tabSignIn reloadData];
            
//            myself.dicShare = [NSDictionary dictionaryWithDictionary:dictionary];
//            [myself showSignTip];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        [myself.refreshControl endRefreshing];
        [myself.tabSignIn reloadData];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [myself.tabSignIn checkNoData:myself.arrSignIn.count];
        myself.disposable = nil;
    }completed:^{
        [myself.refreshControl endRefreshing];
        [myself.tabSignIn reloadData];
        [myself.tabSignIn checkNoData:myself.arrSignIn.count];
        myself.disposable = nil;
    }];
}

- (void)showSignTip{
    FDAlertView *alert = [[FDAlertView alloc] init];
    SignInTip *contentView = [[NSBundle mainBundle] loadNibNamed:@"SignInTip" owner:nil options:nil].lastObject;
    [contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [contentView.lblIntegral setText:[NSString stringStandardFloatTwo:self.dicShare[@"money"]]];
    [contentView.imgTip setImageNoHolder:self.dicShare[@"ad"][@"photo_url"]];
    [alert setDelegate:self];
    alert.contentView = contentView;
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self didClickDelegeteCollectionViewMainTypeDictionary];
    }
}

- (IBAction)clickButtonSignIn:(UIButton *)sender {
    if (!self.share) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
    AchievementController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AchievementController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickDelegeteCollectionViewMainTypeDictionary{
    //    <option value="1">专题</option>
    //    <option value="2">分类</option>
    //    <option value="3">网页</option>
    //    <option value="4">线下店</option>
    //    <option value="6">商品</option>
    //    <option value="7">VIP专区</option>
    //    <option value="8">店铺商品列表</option>
    //    <option value="9">店铺详情</option>
    NSString *strType = self.dicShare[@"ad"][@"clickType"];
    if ([NSString isNullString:strType]) {
        return;
    }
    int intType = [strType intValue];
    NSString *strValue = self.dicShare[@"ad"][@"clickValue"];
    if (intType == 1) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
        controller.goodActivity = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 2){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
        controller.goodsType_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 3){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
        WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
        [controller setTitle:@"详情"];
        controller.strWebUrl = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 4){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorShopTypeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorShopTypeController"];
        controller.strClas = strValue;
        controller.strTitle = self.dicShare[@"ad"][@"title"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 6){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
        controller.strGood_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 7){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaExchangeListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaExchangeListController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 8){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
        controller.strGoods_store_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 9){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
        controller.strStoreID = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 11){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
        AchievementController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AchievementController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
//        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
//        [alertView showAlertView:self andTitle:@"提示" andMessage:@"请更新到最新版本" andCancel:@"确定" andCanelIsRed:YES andBack:^{
//            
//        }];
    }
}

@end

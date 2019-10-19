//
//  CenterController.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/14.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CenterController.h"
#import "CellLogined.h"
#import "CellNotLogin.h"
#import "CellCollection.h"
#import "CellMyService.h"
#import "OrderListMainController.h"
#import "UIButton+Joker.h"
#import "OrderesAddressController.h"
#import "SettingController.h"
#import "PersonalInfoController.h"
#import "CellCollectionType.h"
#import "JJHttpClient+ShopGood.h"
#import "JJDBHelper+Center.h"
#import "MoneyDetailListController.h"
#import "RankListController.h"
#import "ApplyForVenderController.h"
#import "RedPacketTransportController.h"
#import "QRCodeController.h"
#import "AchievememtController.h"
#import "BillHistoryController.h"
#import "IntegerGoodDetailController.h"
#import "ChangeNameController.h"
#import "CellTwoLblArrow.h"

@interface CenterController ()
<
DidClickDelegeteOnlyCollectionView,
DidClickCollectionViewDelegete
>
@property (weak, nonatomic) IBOutlet UITableView *tabCenter;
@property (nonatomic,strong) UIView *viHeader;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) ModelCenter *model;

@end

@implementation CenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabCenter setBackgroundColor:[UIColor clearColor]];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellCollectionType" bundle:nil] forCellReuseIdentifier:@"CellCollectionType"];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellLogined" bundle:nil] forCellReuseIdentifier:@"CellLogined"];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellNotLogin" bundle:nil] forCellReuseIdentifier:@"CellNotLogin"];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellCollection" bundle:nil] forCellReuseIdentifier:@"CellCollection"];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellMyService" bundle:nil] forCellReuseIdentifier:@"CellMyService"];
    [self.tabCenter registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    if (@available(iOS 11.0, *)) {
        self.tabCenter.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self initHeaderView];
}

- (void)initHeaderView{
    
    self.viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             64)];
    [self.viHeader setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.viHeader];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                              20,
                                                              SCREEN_WIDTH - 120,
                                                              44)];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitle setHidden:YES];
    [self.lblTitle setText:@"我的"];
    [self.lblTitle setFont:[UIFont fontWithName:@"Helvetica-Bold"
                                           size:16.0]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.viHeader addSubview:self.lblTitle];
    UIButton *buttonSet=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.viHeader.frame) - 60,
                                                                  self.viHeader.frame.size.height - 44,
                                                                  60,
                                                                  44)];
    [buttonSet setImage:ImageNamed(@"img_center_sz")
               forState:UIControlStateNormal];
    @weakify(self)
    [buttonSet handleControlEvent:UIControlEventTouchUpInside
                        withBlock:^{
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardMine
                                                           bundle:nil];
        SettingController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SettingController"];
        @strongify(self)
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }];
    [self.viHeader addSubview:buttonSet];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:animated];
    [self refreshTab];
    [self requestCenterInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:animated];
}

- (void)refreshTab{
    self.model = [[JJDBHelper sharedInstance] fetchCenterMsg];
    [self.tabCenter reloadData];
}

- (void)requestCenterInfo{
    if (self.disposable) {
        return;
    }
    if ([[PersonalInfo sharedInstance] isLogined]){
        @weakify(self)
        self.disposable = [[[JJHttpClient new] requestShopGoodCenterInfoUserId:[[PersonalInfo sharedInstance]
                                                                                  fetchLoginUserInfo].userId]
                             subscribeNext:^(ModelCenter *model) {
            [self refreshTab];
        }error:^(NSError *error) {
            @strongify(self)
            self.disposable = nil;
        }completed:^{
            @strongify(self)
            self.disposable = nil;
        }];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    if (section == 4) {
        if ([[PersonalInfo sharedInstance] isLogined] &
            [NSString isNullString:self.model.store_id]) {
            return 1;
        }else{
            return 0;
        }
    }return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140.0f;
        }else if (indexPath.row == 1){
            return 50.0f;
        } else{
            return 70.0f;
        }
    }
    if (indexPath.section == 1) {
        return 165.0f;
    }
    if (indexPath.section == 2) {
        return 105.0f;
    }return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[PersonalInfo sharedInstance] isLogined]) {
                CellLogined *cell=[tableView dequeueReusableCellWithIdentifier:@"CellLogined"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell populateData:self.model];
                return cell;
            }else{
                CellNotLogin *cell=[tableView dequeueReusableCellWithIdentifier:@"CellNotLogin"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }else if (indexPath.row == 1){
            CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblName setText:@"我的订单"];
            [cell.lblContent setText:@"查看全部订单"];
            return cell;
        } else{
            CellCollection *cell=[tableView dequeueReusableCellWithIdentifier:@"CellCollection"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateData:indexPath andModel:self.model];
            [cell setDelegete:self];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        CellCollectionType *cell=[tableView dequeueReusableCellWithIdentifier:@"CellCollectionType"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSMutableArray *arrType = [NSMutableArray array];
        NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
        [dic0 setObject:@"img_center_ljsy" forKey:@"image"];
        [dic0 setObject:@"累计收益" forKey:@"name"];
        [dic0 setObject:[NSString stringStandardFloatTwo:self.model.availableBalance] forKey:@"tip"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setObject:@"img_center_qdsye" forKey:@"image"];
        [dic1 setObject:@"签到余额" forKey:@"name"];
        [dic1 setObject:[NSString stringStandardFloatTwo:self.model.redbags] forKey:@"tip"];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setObject:@"img_center_wdjf" forKey:@"image"];
        [dic2 setObject:@"我的积分" forKey:@"name"];
        [dic2 setObject:[NSString stringStandardFloatTwo:self.model.integral] forKey:@"tip"];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
        [dic3 setObject:@"img_center_wdtd" forKey:@"image"];
        [dic3 setObject:@"我的团队" forKey:@"name"];
        [dic3 setObject:[NSString stringStandardZero:self.model.inviterSize] forKey:@"tip"];
        [arrType addObject:dic0];
        [arrType addObject:dic1];
        [arrType addObject:dic2];
        [arrType addObject:dic3];
        [cell setDelegete:self];
        [cell populateDataArray:arrType
                       andTitle:@"我的资产"
                  andButtonName:@""
                   andIndexPath:indexPath];
        @weakify(self)
        [cell.btnMore handleControlEvent:UIControlEventTouchUpInside
                               withBlock:^{
            @strongify(self)
            if ([[PersonalInfo sharedInstance] isLogined]) {
            }else{
                [self pushLoginAlert];
            }
        }];return cell;
    }
    if (indexPath.section == 2) {
        CellCollectionType *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCollectionType"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSMutableArray *arrType = [NSMutableArray array];
        NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
        [dic0 setObject:@"img_center_xxmdjl"
                 forKey:@"image"];
        [dic0 setObject:@"线下买单记录"
                 forKey:@"name"];
        [dic0 setObject:@"我的购买记录"
                 forKey:@"tip"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setObject:@"img_center_jfdhjl"
                 forKey:@"image"];
        [dic1 setObject:@"积分兑换记录"
                 forKey:@"name"];
        [dic1 setObject:@"我的积分记录"
                 forKey:@"tip"];
        [arrType addObject:dic0];
        [arrType addObject:dic1];
        [cell setDelegete:self];
        [cell populateDataArray:arrType
                       andTitle:@"我的订单"
                  andButtonName:@""
                   andIndexPath:indexPath];
        [cell.btnMore handleControlEvent:UIControlEventTouchUpInside
                               withBlock:^{
            @strongify(self)
            if ([[PersonalInfo sharedInstance] isLogined]) {
            }else{
                [self pushLoginAlert];
            }
        }];return cell;
    }
    CellMyService *cell = [tableView dequeueReusableCellWithIdentifier:@"CellMyService"];
    if (indexPath.section == 3) {
        [cell.imgHead setImage:ImageNamed(@"img_center_wdewm")];
        [cell.lblName setText:@"邀请好友"];
        [cell.lblNum setText:@""];
    }
    if (indexPath.section == 4) {
        [cell.imgHead setImage:ImageNamed(@"img_center_sqcwfxs")];
        NSString *strVenderState;
        int stateNum = [self.model.store_status intValue];
        if (stateNum == -1) {
            strVenderState = @"审核失败,点击重新申请";
        }else if (stateNum == 1) {
            strVenderState = @"审核中";
        }else if (stateNum == 2) {
            strVenderState = @"店铺已开通";
        }else if (stateNum == 3) {
            strVenderState = @"店铺已关闭,点击联系客服";
        }else{
            strVenderState = @"加入我们";
        }
        if (stateNum == 1||
            stateNum == 2) {
            [cell.imgArrow setHidden:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else{
            [cell.imgArrow setHidden:NO];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        [cell.lblName setText:strVenderState];
        [cell.lblNum setText:@""];
    }
    if (indexPath.section == 5) {
        [cell.imgHead setImage:ImageNamed(@"img_center_jfcz")];
        [cell.lblName setText:@"积分充值"];
        [cell.lblNum setText:@""];
    }
    if(indexPath.section == 6){
        [cell.imgHead setImage:ImageNamed(@"猫")];
        [cell.lblName setText:@"喵粮管理"];
        [cell.lblNum setText:@""];
    }return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||
        section == 4||
        section == 5) {
        return 0;
    }else return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                SCREEN_WIDTH,
                                                                10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[PersonalInfo sharedInstance] isLogined]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine
                                                                     bundle:nil];
                PersonalInfoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PersonalInfoController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else{
                [self pushLoginController];
            }
        }
        if (indexPath.row == 1) {
            if ([[PersonalInfo sharedInstance] isLogined]) {
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil] instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_quanbu;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else{
                [self pushLoginController];
            }
        }
    }
    if (indexPath.section == 1) {
        
    }
    if (indexPath.section == 2) {
        
    }
    if (indexPath.section == 3) {
        if ([[PersonalInfo sharedInstance] isLogined]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
            QRCodeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"QRCodeController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self pushLoginController];
        }
    }
    if (indexPath.section == 4) {
    
        if ([[PersonalInfo sharedInstance] isLogined]){
            
            int stateNum = [self.model.store_status intValue];
            if (stateNum == -1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardApplyForVender bundle:nil];
                ApplyForVenderController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ApplyForVenderController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
            else if (stateNum == 1) {
                
            }
            else if (stateNum == 2) {
                
            }
            else if (stateNum == 3) {
//                JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
//                [alertView showAlertView:self andTitle:nil andMessage:@"是否拨打电话" andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即拨打" andConfirm:^{
//                    D_NSLog(@"点击了立即发布");
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:StringFormat(@"tel://%@",ServicePhone)]]; //拨号
//                } andCancel:^{
//                    D_NSLog(@"点击了取消");
//                }];
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardApplyForVender bundle:nil];
                ApplyForVenderController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ApplyForVenderController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
        }else{
            [self pushLoginController];
        }
    }
    if (indexPath.section == 5) {
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ChangeNameController *controller = [[UIStoryboard storyboardWithName:StoryboardMine
                                                                          bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeNameController"];
            controller.personalInfo = enum_personalInfo_chongzhi;
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }else{
            [self pushLoginController];
        }
    }
    if (indexPath.section == 6) {
        
    }
}

- (void)didClickCollectionViewHeaderSection:(NSInteger)section{
    if (section == 1) {
        if ([[PersonalInfo sharedInstance] isLogined]) {
            MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }else{
            [self pushLoginAlert];
        }
    }
}

- (void)didClickCollectionViewSection:(NSInteger)section
                               andRow:(NSInteger)row{
    if ([[PersonalInfo sharedInstance] isLogined]) {
        
        if (section == 1) {
            if (row==0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
                AchievememtController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AchievememtController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
            if (row == 1) {
                MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil]
                                                         instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
                controller.numDetail = enum_numDetail_qdsye;
                controller.strMoneyAll = self.model.redbags;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
            if (row == 2) {
                MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil]
                                                         instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
                controller.numDetail = enum_numDetail_wdjf;
                controller.strMoneyAll = self.model.integral;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
            if (row == 3) {
                MoneyDetailListController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil]
                                                         instantiateViewControllerWithIdentifier:@"MoneyDetailListController"];
                controller.numDetail = enum_numDetail_wdtd;
                controller.strMoneyAll = self.model.inviterSize;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
        }
        if(section == 2){
            if (row == 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
                BillHistoryController *controller = [storyboard instantiateViewControllerWithIdentifier:@"BillHistoryController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
            if (row == 1) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
                IntegerGoodDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IntegerGoodDetailController"];
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
        }
    }else{
        [self pushLoginAlert];
    }
}

- (void)didClickOnlyCollectionViewIndexPath:(NSIndexPath *)indexPath
                                     andRow:(NSInteger)row{
    if (indexPath.section == 0&&indexPath.row == 2) {
        if ([[PersonalInfo sharedInstance] isLogined]) {
            if (row == 0) {
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                                 bundle:nil]
                                                       instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_dfk;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else if (row == 1) {
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                                 bundle:nil]
                                                       instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_yfk;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else if (row == 2) {
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                                 bundle:nil]
                                                       instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_yfh;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else if (row == 3) {
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                                 bundle:nil]
                                                       instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_ysh;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }else{
                OrderListMainController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                                 bundle:nil]
                                                       instantiateViewControllerWithIdentifier:@"OrderListMainController"];
                controller.orderState = enumOrder_tksh;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
        }else{
            [self pushLoginAlert];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tabCenter.contentOffset.y < 0) {
        [self.viHeader setHidden:YES];
    }else if(self.tabCenter.contentOffset.y < 50){
        [self.viHeader setHidden:NO];
        D_NSLog(@"%f",self.tabCenter.contentOffset.y);
        D_NSLog(@"%f",0.9*(self.tabCenter.contentOffset.y /50));
        self.viHeader.backgroundColor = ColorFromHexRGBA(0xf22a2a, 0.9*(self.tabCenter.contentOffset.y /50));
        [self.lblTitle setHidden:YES];
    }else{
        [self.viHeader setHidden:NO];
        self.viHeader.backgroundColor = ColorFromHexRGBA(0xf22a2a, 0.9);
        [self.lblTitle setHidden:NO];
    }
}


@end


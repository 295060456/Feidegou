//
//  GoodMainController.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "GoodMainController.h"
#import "ButtonSearch.h"
#import "SearchGoodController.h"
#import "CellPicture.h"
#import "CellGoodMain.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "GoodDetialAllController.h"
#import "BrandRoneListController.h"
#import "GoodsListController.h"
#import "CellMainType.h"
#import "VendorMainController.h"
#import "ButtonShare.h"
//#import "MenberMainController.h"
#import "VendorDetailShopController.h"
#import "VendorShopTypeController.h"
#import "GoodOtherListController.h"
#import "JJDBHelper+MainAdver.h"
#import "SignInController.h"
#import "AreaExchangeListController.h"
#import "AchievementController.h"
//#import "MineTaskListController.h"
//#import "SuspensionView.h"
//#import "StealRedPacketMainController.h"
//#import "AchievementController.h"


@interface GoodMainController ()<RefreshControlDelegate,DidClickDelegeteCollectionViewMainType,DidClickDelegeteOnlyCollectionView>
@property (weak, nonatomic) IBOutlet UITableView *tabGood;

@property (strong, nonatomic) NSMutableArray *arrFloorList;
@property (nonatomic,strong) RACDisposable *disposableType;
@property (nonatomic,strong) RACDisposable *disposableSubject;
@property (nonatomic,strong) RACDisposable *disposableWeb;
@property (nonatomic,strong) RACDisposable *disposableMainAdver;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (strong, nonatomic) NSMutableArray *arrSubject;
@property (strong, nonatomic) NSMutableArray *arrWeb;
@property (strong, nonatomic) NSMutableArray *arrGoods;
@property (strong, nonatomic) NSMutableArray *arrAdvertisement;
@property (strong, nonatomic) NSMutableArray *arrAdvertisementMiddle;
@property (strong, nonatomic) NSMutableArray *arrTip;
@property (strong, nonatomic) NSString *strNotice;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;
@property (nonatomic,strong) UIView *viHeader;
@property (assign, nonatomic) BOOL isLogined;
@property (nonatomic, weak) NSTimer *timerRepeat;
@property (nonatomic,strong) UIView *viMsg;
@property (nonatomic,strong) UILabel *lblMsg;


@property (strong, nonatomic) UIView *viShowGetPrize;
@end

@implementation GoodMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tabGood.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellMainType" bundle:nil] forCellReuseIdentifier:@"CellMainType"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellOneImage" bundle:nil] forCellReuseIdentifier:@"CellOneImage"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellPicture" bundle:nil] forCellReuseIdentifier:@"CellPicture"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellAdver" bundle:nil] forCellReuseIdentifier:@"CellAdver"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellTypeMore" bundle:nil] forCellReuseIdentifier:@"CellTypeMore"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellGoodMain" bundle:nil] forCellReuseIdentifier:@"CellGoodMain"];
    [self.tabGood setBackgroundColor:[UIColor clearColor]];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGood delegate:self];
    [self initHeaderView];
//    [self initgetPirze];
    // Do any additional setup after loading the view.
}
- (void)requestAdver{
    
    __weak GoodMainController *myself = self;
    myself.disposableMainAdver = [[[JJHttpClient new] requestFourZeroMainAdver] subscribeNext:^(NSDictionary* dcitiaonry) {
        [myself addTimerRepeat];
    }error:^(NSError *error) {
        myself.disposableMainAdver = nil;
    }completed:^{
        myself.disposableMainAdver = nil;
    }];
    
}
- (void)requestExchangeList{
    
    __weak GoodMainController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodMainGoodLimit:@"10" andPage:TransformNSInteger(self.intPageIndex)] subscribeNext:^(NSDictionary* dcitiaonry) {
        if ([dcitiaonry[@"recommendedGoods"] isKindOfClass:[NSArray class]]) {
            NSArray *arrayGood= dcitiaonry[@"recommendedGoods"];
            RACSequence *sequence=[arrayGood rac_sequence];
            NSArray *array = [[sequence map:^id(NSDictionary *item){
                ModelGood *model = [MTLJSONAdapter modelOfClass:[ModelGood class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
            myself.curCount = array.count;
            if (myself.intPageIndex == 1) {
                myself.arrGoods = [NSMutableArray array];
            }
            [myself.arrGoods addObjectsFromArray:array];
        }else{
            myself.curCount = 0;
        }
        [myself.tabGood reloadData];
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
- (void)requestTypeSubjectWeb{
    __weak GoodMainController *myself = self;
    myself.disposableSubject = [[[JJHttpClient new] requestFourZeroMainType] subscribeNext:^(NSDictionary* dictionary) {
        [myself refreshTabview:dictionary[@"floorList"]];
    }error:^(NSError *error) {
        myself.disposableSubject = nil;
    }completed:^{
        myself.disposableSubject = nil;
    }];
}
- (void)refreshTabview:(NSArray *)array{
    self.arrFloorList = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
//        if ([LocationHeaper isHadType:array[i][@"type"]]) {
            [self.arrFloorList addObject:array[i]];
//        }
    }
    [self.tabGood reloadData];
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    self.intPageIndex = 1;
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
        [self requestTypeSubjectWeb];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.isLogined = [[PersonalInfo sharedInstance] isLogined];

    if (self.arrGoods.count == 0) {
        [self.refreshControl beginRefreshingMethod];
    }
    [self requestAdver];
//    [self showSuspension];
}
//- (void)initgetPirze{
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        if ([[[PersonalInfo sharedInstance] fetchLoginUserInfo].NEWTASK intValue]==0) {
//            self.viShowGetPrize = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [self.viShowGetPrize setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
//            [self.navigationController.view.window addSubview:self.viShowGetPrize];
//
//            CGFloat fWidthImage = SCREEN_WIDTH*3/5;
//            CGFloat fHeightImage = fWidthImage*512/548;
//
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - fWidthImage)/2, (SCREEN_HEIGHT-fHeightImage)/2, fWidthImage, fHeightImage)];
//            [button addTarget:self action:@selector(clickButtonLingjiang:) forControlEvents:UIControlEventTouchUpInside];
//            [button setImage:ImageNamed(@"img_reminder") forState:UIControlStateNormal];
//            [button setImage:ImageNamed(@"img_reminder") forState:UIControlStateHighlighted];
//            [self.viShowGetPrize addSubview:button];
//
//
//
//            UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 60, 44)];
//            [btnClose addTarget:self action:@selector(clickButtonColse:) forControlEvents:UIControlEventTouchUpInside];
//            [btnClose setImage:ImageNamed(@"img_yiy_guabi") forState:UIControlStateNormal];
//            [self.viShowGetPrize addSubview:btnClose];
//        }
//    }
//}
- (void)clickButtonColse:(UIButton *)sender{
    [self.viShowGetPrize removeFromSuperview];
    self.viShowGetPrize = nil;
}
- (void)clickButtonLingjiang:(UIButton *)sender{
    [self clickButtonColse:nil];
//    MineTaskListController *controller = [[UIStoryboard storyboardWithName:@"MineTask" bundle:nil] instantiateViewControllerWithIdentifier:@"MineTaskListController"];
//    [self.navigationController pushViewController:controller animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self removeTimerRepeat];
}
- (void)initHeaderView{
    self.viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:self.viHeader];
    ButtonSearch *buttonSearch=[[ButtonSearch alloc]initWithFrame:CGRectMake(10, self.viHeader.frame.size.height-44, self.view.frame.size.width-10-60, 35)];
    [buttonSearch setTitle:@"搜索商品名称"];
    [buttonSearch handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        D_NSLog(@"clickButtonSearch");
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        SearchGoodController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SearchGoodController"];
        [self.navigationController pushViewController:controller animated:NO];
    }];
    [self.viHeader addSubview:buttonSearch];
    
    
    ButtonShare *btnSignIn = [[ButtonShare alloc] initWithFrame:CGRectMake(self.view.frame.size.width-53, self.viHeader.frame.size.height-44, 36, 36)];
    [btnSignIn setTitle:@"签到送" forState:UIControlStateNormal];
    [btnSignIn.titleLabel setFont:[UIFont systemFontOfSize:6.0]];
    [btnSignIn addTarget:self action:@selector(clickButtonSign:) forControlEvents:UIControlEventTouchUpInside];
    [btnSignIn setImage:ImageNamed(@"img_sign") forState:UIControlStateNormal];
    [btnSignIn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [btnSignIn setClipsToBounds:YES];
    [btnSignIn.layer setCornerRadius:18.0];
    [self.viHeader addSubview:btnSignIn];
}
- (void)clickButtonSign:(UIButton *)sender{
    if ([[PersonalInfo sharedInstance] isLogined]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
        SignInController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self pushLoginController];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = SCREEN_WIDTH*324/720;
    if(self.tabGood.contentOffset.y<-20) {
        [self.viHeader setHidden:YES];
    }else if(self.tabGood.contentOffset.y<height*0.9){
        [self.viHeader setHidden:NO];
        self.viHeader.backgroundColor=ColorFromHexRGBA(0xf22a2a, self.tabGood.contentOffset.y /height);
    }
}



#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrFloorList.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [PublicFunction heightByInfo:self.arrFloorList[indexPath.row]];
    }
    if (indexPath.section == 1) {
        CGFloat fWidth = SCREEN_WIDTH;
        CGFloat fHeight = (fWidth/2+120)*(self.arrGoods.count/2);
        if (self.arrGoods.count%2 == 1) {
            fHeight += fWidth/2+120;
        }
        return fHeight;
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CellMainType *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMainType"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrFloorList andIndexPath:indexPath];
        [cell setDelegete:self];
        return cell;
        
    }
    if (indexPath.section == 1) {
        CellGoodMain *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMain"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrGoods andRow:indexPath.section];
        [cell setDelegete:self];
        return cell;
    }
    CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
    [cell populateData:[NSArray array]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didClickDelegeteCollectionViewMainTypeDictionary:(NSDictionary *)dicInfo{
    D_NSLog(@"%@",dicInfo);
//    <option value="1">专题</option>
//    <option value="2">分类</option>
//    <option value="3">网页</option>
//    <option value="4">线下店</option>
//    <option value="6">商品</option>
//    <option value="7">VIP专区</option>
//    <option value="8">店铺商品列表</option>
//    <option value="9">店铺详情</option>
    NSString *strType = dicInfo[@"clickType"];
    if ([NSString isNullString:strType]) {
        return;
    }
    int intType = [strType intValue];
    NSString *strValue = dicInfo[@"clickValue"];
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
        controller.strTitle = dicInfo[@"title"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 6){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
        controller.strGood_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 7){
        if ([strValue intValue]==3) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
            AreaExchangeListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaExchangeListController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
            controller.good_area = strValue;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
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
        if ([[PersonalInfo sharedInstance] isLogined]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
            AchievementController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AchievementController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self pushLoginController];
        }
    }else{
//        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
//        [alertView showAlertView:self andTitle:@"提示" andMessage:@"请更新到最新版本" andCancel:@"确定" andCanelIsRed:YES andBack:^{
//            
//        }];
    }
    
    
}
//每个商品
- (void)didClickOnlyCollectionViewModel:(ModelGood *)model andRow:(NSInteger)row{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
    controller.strGood_id = model.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 *添加计时器
 */
- (void)addTimerRepeat{
    D_NSLog(@"addTimer");
    [self removeTimerRepeat];
    self.arrTip = [NSMutableArray arrayWithArray:[[JJDBHelper sharedInstance] fetchMainAdver]];
    self.timerRepeat = [NSTimer scheduledTimerWithTimeInterval:10
                                                        target:self
                                                      selector:@selector(repeatAnimation:)
                                                      userInfo:nil
                                                       repeats:YES];
    //将timer添加到RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:self.timerRepeat
                              forMode:NSRunLoopCommonModes];
}
/**
 *移除计时器
 */
- (void)removeTimerRepeat{
    D_NSLog(@"removeTimer");
    [self.disposableMainAdver dispose];
    self.disposableMainAdver = nil;
    if (self.timerRepeat) {
        [self.timerRepeat invalidate];
    }
    self.timerRepeat = nil;
}
- (void)repeatAnimation:(NSTimer *)timer{
    if (self.arrTip.count>0) {
        if (!self.lblMsg) {
            self.viMsg = [[UIView alloc] init];
            [self.viMsg setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            [self.viMsg setClipsToBounds:YES];
            [self.viMsg.layer setCornerRadius:3.0];
            self.lblMsg = [[UILabel alloc] init];
            [self.lblMsg setTextColor:[UIColor whiteColor]];
            [self.lblMsg setFont:[UIFont systemFontOfSize:12.0]];
            [self.lblMsg setTextAlignment:NSTextAlignmentCenter];
            [self.viMsg addSubview:self.lblMsg];
            [self.view addSubview:self.viMsg];
        }
        NSString *strMsg;
        if ([self.arrTip[0] isKindOfClass:[NSDictionary class]]) {
            strMsg = self.arrTip[0][@"msg"];
            [[JJDBHelper sharedInstance] saveAdverId:self.arrTip[0][@"orderId"]];
        }else{
            return;
        }
        [self.arrTip removeObjectAtIndex:0];
        CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strMsg andWidth:SCREEN_WIDTH-10 andFont:12.0].width+15;
        [self.lblMsg setTextNull:strMsg];
        CGFloat fY = SCREEN_WIDTH*324/720-30;
        [self.viMsg setFrame:CGRectMake(-5-fWidth, fY, fWidth, 20)];
        [self.lblMsg setFrame:CGRectMake(5, 0, CGRectGetWidth(self.viMsg.frame)-5, CGRectGetHeight(self.viMsg.frame))];
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [self.viMsg setFrame:CGRectMake(-5, fY, fWidth, 20)];
        }completion:^(BOOL finished){
            [UIView animateWithDuration:5 animations:^{
                [self.viMsg setFrame:CGRectMake(-6, fY, fWidth, 20)];
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.3 animations:^{
                    [self.viMsg setFrame:CGRectMake(-5-fWidth, fY, fWidth, 20)];
                }completion:^(BOOL finished){
                }];
            }];
        }];
        
    }else{
        [self removeTimerRepeat];
    }
}

//- (void)suspensionViewDidCilcked:(SuspensionView *)suspension{
//    
//    if ([[PersonalInfo sharedInstance] isLogined]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardStealRedPacket bundle:nil];
//        StealRedPacketMainController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StealRedPacketMainController"];
//        controller.isNavigationShow = NO;
//        [self.navigationController pushViewController:controller animated:YES];
//    }else{
//        [self pushLoginController];
//    }
//}
//- (void)showSuspension{
//    if ([[PersonalInfo sharedInstance] isShow]) {
//        if (!self.btnSuspension) {
//            self.btnSuspension = [[SuspensionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30,CGRectGetHeight(self.view.frame)/2-46, 60, 93) andImageName:@"img_thb_xfw"];
//            [self.btnSuspension setDelegete:self];
//            [self.view addSubview:self.btnSuspension];
//        }
//        [self.btnSuspension setHidden:NO];
//    }else{
//        [self hiddenSuspension];
//    }
//}
//- (void)hiddenSuspension{
//    [self.btnSuspension setHidden:YES];
//}


@end

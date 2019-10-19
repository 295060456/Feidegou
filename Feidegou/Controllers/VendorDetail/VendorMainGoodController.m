//
//  VendorMainGoodController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorMainGoodController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellPicture.h"
#import "CellTypeMore.h"
#import "CellHeader.h"
#import "CellVendorGood.h"
#import "CellVendorShop.h"
#import "VendorDetailGoodController.h"
#import "VendorShopTypeController.h"
#import "VendorDetailShopController.h"
#import "LocationManager.h"
#import "ButtonSearch.h"
#import "SearchGoodController.h"
//#import "UIViewController+Cloudox.h"
//#import "UINavigationController+Cloudox.h"


@interface VendorMainGoodController ()
<RefreshControlDelegate,
DidClickDelegeteCollectionViewType>{
}

@property (weak, nonatomic) IBOutlet BaseTableView *tabGood;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrphotoUrlSlider;
@property (strong, nonatomic) NSMutableArray *arrclassification;
@property (strong, nonatomic) NSMutableArray *arrphotoUrl;
@property (strong, nonatomic) NSMutableArray *arrrecommendedGoods;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量
@property (nonatomic,strong) RACDisposable *disposableVendor;
@property (nonatomic,strong) UIView *viHeader;

@end

@implementation VendorMainGoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellPicture" bundle:nil] forCellReuseIdentifier:@"CellPicture"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellTypeMore" bundle:nil] forCellReuseIdentifier:@"CellTypeMore"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellHeader" bundle:nil] forCellReuseIdentifier:@"CellHeader"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGood" bundle:nil] forCellReuseIdentifier:@"CellVendorGood"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorShop" bundle:nil] forCellReuseIdentifier:@"CellVendorShop"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGood delegate:self];
    [self.refreshControl beginRefreshingMethod];
    
    [[LocationManager sharedInstance] updateLocation];
    
    
    if (@available(iOS 11,*)) {
        self.tabGood.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initHeaderView];
    // Do any additional setup after loading the view.
}

- (void)initHeaderView{
    self.viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             64)];
    [self.view addSubview:self.viHeader];
    ButtonSearch *buttonSearch=[[ButtonSearch alloc]initWithFrame:CGRectMake(10,
                                                                             self.viHeader.frame.size.height-44,
                                                                             self.view.frame.size.width-20,
                                                                             35)];
    [buttonSearch setTitle:@"搜索附近的吃喝玩乐"];
    @weakify(self)
    [buttonSearch handleControlEvent:UIControlEventTouchUpInside
                           withBlock:^{
        @strongify(self)
        D_NSLog(@"clickButtonSearch");
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        SearchGoodController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SearchGoodController"];
        controller.isVendor = YES;
        [self.navigationController pushViewController:controller
                                             animated:NO];
    }];
    [self.viHeader addSubview:buttonSearch];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = SCREEN_WIDTH*324/720;
    if(self.tabGood.contentOffset.y<-20) {
        [self.viHeader setHidden:YES];
    }else if(self.tabGood.contentOffset.y<height*0.9){
        [self.viHeader setHidden:NO];
        
        self.viHeader.backgroundColor=ColorFromHexRGBA(0xff9c00, self.tabGood.contentOffset.y /height);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodVenderMain] subscribeNext:^(NSDictionary* dictioanry) {
        @strongify(self)
        NSArray *arrPicUp = dictioanry[@"photoUrl"];
        if ([arrPicUp isKindOfClass:[NSArray class]]) {
            self.arrphotoUrlSlider = [NSMutableArray arrayWithArray:arrPicUp];
        }
        NSArray *arrType = dictioanry[@"classification"];
        if ([arrType isKindOfClass:[NSArray class]]) {
            self.arrclassification = [NSMutableArray arrayWithArray:arrType];
        }
        NSArray *arrPicMiddle = dictioanry[@"photoUrlSlider"];
        if ([arrPicMiddle isKindOfClass:[NSArray class]]) {
            self.arrphotoUrl = [NSMutableArray arrayWithArray:arrPicMiddle];
        }
//        NSArray *arrGood = dictioanry[@"recommendedGoods"];
//        if ([arrGood isKindOfClass:[NSArray class]]) {
//            myself.arrrecommendedGoods = [NSMutableArray arrayWithArray:arrGood];
//        }
        [self.tabGood reloadData];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
//        [myself.refreshControl endRefreshing];
        [self checkNum];
    }completed:^{
         @strongify(self)
//        [myself.refreshControl endRefreshing];
        self.disposable = nil;
        [self checkNum];
    }];
}

- (void)requestVendorList{
    @weakify(self)
    self.disposableVendor = [[[JJHttpClient new] requestShopGoodVendorNearByLimit:@"10"
                                                                            andPage:TransformNSInteger(self.intPageIndex)
                                                                             andlat:[[LocationManager sharedInstance] fetchLocationLatitude]
                                                                             andlng:[[LocationManager sharedInstance] fetchLocationLongitude] andkey:@""]
                               subscribeNext:^(NSArray* array) {
        @strongify(self)
        if (self.intPageIndex == 1) {
            self.arrrecommendedGoods = [NSMutableArray array];
        }
        [self.arrrecommendedGoods addObjectsFromArray:array];
        [self.tabGood reloadData];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableVendor = nil;
        [self checkNum];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        self.disposableVendor = nil;
        [self checkNum];
    }];
}

- (void)requestNerBy{
    D_NSLog(@"requestNerBy");
}
- (void)checkNum{
    if (self.arrphotoUrlSlider.count==0 &&
        self.arrclassification.count==0 &&
        self.arrphotoUrl.count==0 &&
        self.arrrecommendedGoods.count==0) {
        [self.tabGood checkNoData:0];
    }else{
        [self.tabGood checkNoData:1];
    }
    if (self.disposable == nil&&self.disposableVendor == nil) {
        [self.refreshControl endRefreshing];
    }
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        self.intPageIndex = 1;
        [self requestExchangeList];
        [self requestVendorList];
    }
}

-(void)refreshControlForLoadMoreData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestVendorList)]) {
        [self requestVendorList];
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
    if (section == 0) {
        if (self.arrphotoUrlSlider.count>0) {
            return 1;
        }
    }
    if (section == 1) {
        if (self.arrclassification.count > 0) {
            return 1;
        }
    }
    if (section == 2) {
        if (self.arrphotoUrl.count > 0) {
            return 1;
        }
    }
    if (section == 3) {
        if (self.arrrecommendedGoods.count > 0) {
            return 1;
        }
    }
    if (section == 4) {
        return self.arrrecommendedGoods.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.arrphotoUrlSlider.count>0) {
            return SCREEN_WIDTH/2;
        }
    }
    if (indexPath.section == 1) {
        if (self.arrclassification.count > 0) {
            return SCREEN_WIDTH*320/720;
        }
    }
    if (indexPath.section == 2) {
        if (self.arrphotoUrl.count>0) {
            return SCREEN_WIDTH*13/64;
        }
    }
    if (indexPath.section == 3) {
        if (self.arrrecommendedGoods.count > 0) {
            return 30;
        }
    }
    if (indexPath.section == 4) {
        ModelVendorNear *model = self.arrrecommendedGoods[indexPath.row];
        if ([model.gift_integral floatValue]>0) {
            return 130;
        }else{
            return 110;
        }
    }return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrphotoUrlSlider];
        return cell;
    }
    if (indexPath.section == 1) {
        CellTypeMore *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTypeMore"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrclassification andRow:1 andLie:5];
        [cell setDelegete:self];
        return cell;
    }
    if (indexPath.section == 2) {
        CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrphotoUrl];
        return cell;
    }
    if (indexPath.section == 3) {
        CellHeader *cell=[tableView dequeueReusableCellWithIdentifier:@"CellHeader"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    if (indexPath.section == 4) {
        
        CellVendorShop *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorShop"];
        [cell populataData:self.arrrecommendedGoods[indexPath.row]];
        return cell;
//        CellVendorGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorGood"];
//        [cell populateData:self.arrrecommendedGoods[indexPath.row]];
//        return cell;
    }
    CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2&&self.arrphotoUrl.count > 0) {
        return 10;
    }
    if (section == 3&&self.arrrecommendedGoods.count > 0) {
        return 10;
    }return 0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationItem.titleView endEditing:YES];
    if (indexPath.section == 4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
        ModelVendorNear *model = self.arrrecommendedGoods[indexPath.row];
        controller.strStoreID = model.ID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
//上面八个小分类
- (void)didClickOnlyCollectionViewDictionary:(NSDictionary *)model
                                      andRow:(NSInteger)row{
    D_NSLog(@"%@",model);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail
                                                         bundle:nil];
    VendorShopTypeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorShopTypeController"];
    controller.strClas = model[@"type_value"];
    controller.strTitle = model[@"main_name"];
    [self.navigationController pushViewController:controller
                                         animated:YES];
    
}

@end

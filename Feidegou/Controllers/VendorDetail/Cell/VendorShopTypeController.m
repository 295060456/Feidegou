//
//  VendorShopTypeController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/4.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorShopTypeController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellVendorShop.h"
#import "VendorDetailShopController.h"
#import "LocationManager.h"

@interface VendorShopTypeController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabVendor;

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrVendor;

@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;

@end

@implementation VendorShopTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![NSString isNullString:self.strTitle]) {
        self.title = self.strTitle;
    }
    if (![NSString isNullString:self.strSearch]) {
        self.title = self.strSearch;
    }
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorShop" bundle:nil] forCellReuseIdentifier:@"CellVendorShop"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabVendor delegate:self];
    [self.refreshControl beginRefreshingMethod];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodVendorNearByLimit:@"10"
                                                                      andPage:TransformNSInteger(self.intPageIndex)
                                                                      andclas:[NSString stringStandard:self.strClas]
                                                                       andkey:[NSString stringStandard:self.strSearch]
                                                                       andLat:[[LocationManager sharedInstance] fetchLocationLatitude]
                                                                       andLng:[[LocationManager sharedInstance] fetchLocationLongitude]]
                         subscribeNext:^(NSArray* array) {
        @strongify(self)
        if (self.intPageIndex == 1) {
            self.arrVendor = [NSMutableArray array];
        }
        [self.arrVendor addObjectsFromArray:array];
        [self.tabVendor reloadData];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            self.curCount = 0;
        }
        [self.tabVendor checkNoData:self.arrVendor.count];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
        [self.tabVendor checkNoData:self.arrVendor.count];
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
    return self.arrVendor.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelVendorNear *model = self.arrVendor[indexPath.row];
    if ([model.gift_integral floatValue]>0) {
        return 130;
    }else{
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellVendorShop *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorShop"];
    [cell populataData:self.arrVendor[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationItem.titleView endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
    VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
    ModelVendorNear *model = self.arrVendor[indexPath.row];
    controller.strStoreID = model.ID;
    [self.navigationController pushViewController:controller
                                         animated:YES];
}


@end

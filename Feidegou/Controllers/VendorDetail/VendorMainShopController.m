//
//  VendorMainShopController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorMainShopController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellVendorShop.h"
#import "LocationManager.h"
#import "VendorDetailShopController.h"

@interface VendorMainShopController ()
<RefreshControlDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tabVendor;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrVendor;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量

@end

@implementation VendorMainShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorShop" bundle:nil] forCellReuseIdentifier:@"CellVendorShop"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabVendor delegate:self];
    [self.refreshControl beginRefreshingMethod];
    [[LocationManager sharedInstance] updateLocation];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodVendorNearByLimit:@"10"
                                                                      andPage:TransformNSInteger(self.intPageIndex)
                                                                       andlat:[[LocationManager sharedInstance] fetchLocationLatitude]
                                                                       andlng:[[LocationManager sharedInstance] fetchLocationLongitude] andkey:@""]
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
//        if (error.code!=2) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        }else{
//            myself.curCount = 0;
//        }
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

-(BOOL)refreshControlEnableRefresh{
    return YES;
}
-(BOOL)refreshControlEnableLoadMore{
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
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellVendorShop *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorShop"];
    [cell populataData:self.arrVendor[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationItem.titleView endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
    VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
    ModelVendorNear *model = self.arrVendor[indexPath.row];
    controller.strStoreID = model.ID;
    [self.navigationController pushViewController:controller animated:YES];
}


@end

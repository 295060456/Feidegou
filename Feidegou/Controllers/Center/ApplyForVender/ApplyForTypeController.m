//
//  ApplyForTypeController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/18.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ApplyForTypeController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellOneLabel.h"

@interface ApplyForTypeController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabType;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (nonatomic,strong) RefreshControl *refreshControl;

@end

@implementation ApplyForTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabType registerNib:[UINib nibWithNibName:@"CellOneLabel" bundle:nil] forCellReuseIdentifier:@"CellOneLabel"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabType delegate:self];
    [self.refreshControl beginRefreshingMethod];
    // Do any additional setup after loading the view.
}

- (void)requestExchangeList{
    __weak ApplyForTypeController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodVenderType] subscribeNext:^(NSArray* array) {
        if ([array isKindOfClass:[NSArray class]]) {
            myself.arrType = [NSMutableArray arrayWithArray:array];
        }
        [myself.tabType reloadData];
        [myself.tabType checkNoData:myself.arrType.count];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.tabType checkNoData:myself.arrType.count];
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrType.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellOneLabel *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneLabel"];
    [cell.lblContent setTextNull:self.arrType[indexPath.row][@"className"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.applyForVenderAttribute.strVendorTypeID = self.arrType[indexPath.row][@"id"];
    self.applyForVenderAttribute.strVendorTypeName = self.arrType[indexPath.row][@"className"];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end

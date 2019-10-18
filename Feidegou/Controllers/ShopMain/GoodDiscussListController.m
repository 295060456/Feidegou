//
//  GoodDiscussListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDiscussListController.h"
#import "CellDiscuss.h"
#import "JJHttpClient+ShopGood.h"

@interface GoodDiscussListController ()
<RefreshControlDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tabDiscussList;
@property (strong, nonatomic) NSMutableArray *arrDiscussList;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量

@end

@implementation GoodDiscussListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabDiscussList setBackgroundColor:ColorBackground];
    [self.tabDiscussList registerNib:[UINib nibWithNibName:@"CellDiscuss" bundle:nil] forCellReuseIdentifier:@"CellDiscuss"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabDiscussList delegate:self];
    [self.refreshControl beginRefreshingMethod];
}

- (void)requestExchangeList{
    NSString *strState = @"";
    if (self.enumState == enum_discuss_good) {
        strState = @"1";
    }else if (self.enumState == enum_discuss_middle) {
        strState = @"0";
    }else if (self.enumState == enum_discuss_bad) {
        strState = @"-1";
    }
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodDiscussListGoods_id:[NSString stringStandard:self.strGood_id]
                                                                       andLimit:@"10"
                                                                        andPage:TransformNSInteger(self.intPageIndex)
                                                                       andState:strState
                                                                    andstore_id:[NSString stringStandard:self.store_id]]
                         subscribeNext:^(NSDictionary *dictionary) {
        @strongify(self)
        NSArray *array;
        if ([dictionary[@"evaluate"] isKindOfClass:[NSArray class]]) {
            array = [NSArray arrayWithArray:dictionary[@"evaluate"]];
        }else{
            array = [NSArray array];
        }
        if (self.intPageIndex == 1) {
            self.arrDiscussList = [NSMutableArray array];
        }
        [self.arrDiscussList addObjectsFromArray:array];
        [self.tabDiscussList reloadData];
        if (self.enumState == enum_discuss_all) {
            if ([self.delegete respondsToSelector:@selector(discussListNumDictonary:)]) {
                [self.delegete discussListNumDictonary:dictionary];
            }
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            self.curCount = 0;
        }
        [self.tabDiscussList checkNoData:self.arrDiscussList.count];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
        [self.tabDiscussList checkNoData:self.arrDiscussList.count];
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
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDiscussList.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strContent = self.arrDiscussList[indexPath.section][@"evaluate_info"];
    float fHeight = [NSString conculuteRightCGSizeOfString:strContent
                                                  andWidth:SCREEN_WIDTH-20
                                                   andFont:15.0].height+60;
    return fHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellDiscuss *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDiscuss"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populataData:self.arrDiscussList[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 10;
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


@end

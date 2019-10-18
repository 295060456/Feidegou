//
//  BrandRoneListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/3.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "BrandRoneListController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellBrandRone.h"
#import "CellBrandRoneRecommend.h"
#import "GoodsListController.h"

@interface BrandRoneListController ()<RefreshControlDelegate,BrandCollectionView>
@property (weak, nonatomic) IBOutlet BaseTableView *tabBrandRone;
@property (strong, nonatomic) NSMutableArray *arrBrandRone;
@property (strong, nonatomic) NSMutableArray *arrBrandRecommend;
@property (strong, nonatomic) NSMutableArray *arrTitle;
@property (nonatomic,strong) RefreshControl *refreshControl;
@end

@implementation BrandRoneListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.tabBrandRone setBackgroundColor:ColorBackground];
    [self.tabBrandRone registerNib:[UINib nibWithNibName:@"CellBrandRone" bundle:nil] forCellReuseIdentifier:@"CellBrandRone"];
    [self.tabBrandRone registerNib:[UINib nibWithNibName:@"CellBrandRoneRecommend" bundle:nil] forCellReuseIdentifier:@"CellBrandRoneRecommend"];
    
    
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabBrandRone delegate:self];
    [self.refreshControl beginRefreshingMethod];
    
    
}
- (void)requestExchangeList{
    __weak BrandRoneListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodBrandRone] subscribeNext:^(NSDictionary* dictionary) {
        myself.arrBrandRecommend = [NSMutableArray array];
//        先确认推荐的列表
        if ([dictionary[@"brandRecommendList"] isKindOfClass:[NSArray class]]) {
            [myself.arrBrandRecommend addObjectsFromArray:dictionary[@"brandRecommendList"]];
        }
        
//        生成总的列表
        if ([dictionary[@"brandList"] isKindOfClass:[NSArray class]]) {
            [myself orderTheBrandListByArray:dictionary[@"brandList"]];
        }
        
        [myself.tabBrandRone reloadData];
        
        
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        [myself.tabBrandRone checkNoData:myself.arrBrandRecommend.count];
    }completed:^{
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
        [myself.tabBrandRone checkNoData:myself.arrBrandRecommend.count];
    }];
    
}
- (void)orderTheBrandListByArray:(NSArray *)array{
    NSMutableDictionary *sectionDic = [[NSMutableDictionary alloc] initWithCapacity:100];

    
    for (int i = 0; i < 26; i++)
    {
        [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    }
    
    [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    
    for (NSDictionary *placeInfoDic in array) {
//        char first= pinyinFirstLetter([placeInfoDic[@"flag"] characterAtIndex:0]);
        char first = [placeInfoDic[@"flag"] characterAtIndex:0];
        NSString *sectionName;
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            sectionName = [[NSString stringWithFormat:@"%c",[placeInfoDic[@"flag"] characterAtIndex:0]] uppercaseString];
        }else {
            sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        
        [[sectionDic objectForKey:sectionName] addObject:placeInfoDic];
        
    }
    
    self.arrBrandRone = [NSMutableArray array];
    self.arrTitle = [NSMutableArray array];
    if (self.arrBrandRecommend.count>0) {
        [self.arrTitle addObject:@"热"];
        [self.arrBrandRone addObject:self.arrBrandRecommend];
    }
    
    //去除空的数组
    NSArray *allKeys = [[sectionDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i< allKeys.count; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *value = [sectionDic valueForKey:key];
        if (value.count == 0) {
            [sectionDic removeObjectForKey:key];
        }else{
            [self.arrTitle addObject:key];
            [self.arrBrandRone addObject:value];
        }
    }
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}
/*!
 * 是否启用上拉加载
 * @return YES:启用;NO:不启用
 */
-(BOOL)refreshControlEnableLoadMore{
    return NO;
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.arrBrandRecommend.count != 0 &&section == 0) {
        return 1;
    }
    NSArray *arrSection = self.arrBrandRone[section];
    return arrSection.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrBrandRone.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrBrandRecommend.count != 0 &&indexPath.section == 0) {
        NSInteger intHang = self.arrBrandRecommend.count/3;
        if (self.arrBrandRecommend.count%3!=0) {
            intHang ++;
        }
        return intHang*100+2;
    }
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrBrandRecommend.count != 0 &&indexPath.section == 0) {
        CellBrandRoneRecommend *cell=[tableView dequeueReusableCellWithIdentifier:@"CellBrandRoneRecommend"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegete:self];
        [cell populataData:self.arrBrandRecommend];
        return cell;
    }
    CellBrandRone *cell=[tableView dequeueReusableCellWithIdentifier:@"CellBrandRone"];
    [cell.imgHead setImagePathListSquare:self.arrBrandRone[indexPath.section][indexPath.row][@"icon"]];
    [cell.lblName setTextNull:self.arrBrandRone[indexPath.section][indexPath.row][@"name"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.arrBrandRecommend.count != 0 &&indexPath.section == 0) {
        return;
    }
    NSDictionary *dictionary = self.arrBrandRone[indexPath.section][indexPath.row];
    D_NSLog(@"dictionary name is %@",dictionary[@"name"]);
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
    controller.isShow = YES;
    controller.strGoods_brand_id = dictionary[@"id"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
    [lblTitle setTextColor:ColorBlack];
    [lblTitle setFont:[UIFont systemFontOfSize:15.0]];
    NSString *strTitle = self.arrTitle[section];
    if ([strTitle isEqualToString:@"热"]) {
        strTitle = @"推荐品牌";
    }
    [lblTitle setTextNull:strTitle];
    [viHeader addSubview:lblTitle];
    return viHeader;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.arrTitle;
}
- (void)didSelectedBrandDictionary:(NSDictionary *)dictionary{
    D_NSLog(@"dictionary name is %@",dictionary[@"name"]);
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
    controller.isShow = YES;
    controller.strGoods_brand_id = dictionary[@"id"];
    [self.navigationController pushViewController:controller animated:YES];
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

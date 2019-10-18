//
//  AreaExchangeListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/7.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaExchangeListController.h"
#import "CellGoodList.h"
#import "JJHttpClient+ShopGood.h"
#import "AreaExchangeDetailController.h"
#import "CLCellGoods.h"

@interface AreaExchangeListController ()<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tabAreaExchangeList;
@property (strong, nonatomic) NSMutableArray *arrAreaExchangeList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
//当前页数数量
@property (nonatomic,assign) NSInteger curCount;

@end

@implementation AreaExchangeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.collectionView setBackgroundColor:ColorBackground];
    [self.tabAreaExchangeList registerNib:[UINib nibWithNibName:@"CellGoodList"
                                                         bundle:nil]
                   forCellReuseIdentifier:@"CellGoodList"];
    [self.collectionView registerClass:[CLCellGoods class] forCellWithReuseIdentifier:@"CLCellGoods"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabAreaExchangeList
                                                                        delegate:self];
    [self.refreshControl beginRefreshingMethod];
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
    }return NO;
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodEreaExchangeListLimit:@"10"
                                                                          andPage:TransformNSInteger(self.intPageIndex)]
                         subscribeNext:^(NSArray *array) {
        @strongify(self)
        self.curCount = array.count;
        if (self.intPageIndex == 1) {
            self.arrAreaExchangeList = [NSMutableArray array];
        }
        [self.arrAreaExchangeList addObjectsFromArray:array];
        [self.collectionView reloadData];
//        [myself.tabAreaExchangeList checkNoData:myself.arrAreaExchangeList.count];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            self.curCount = 0;
        }
        [self.tabAreaExchangeList checkNoData:self.arrAreaExchangeList.count];
    }completed:^{
        @strongify(self)
        self.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
    }];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrAreaExchangeList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellGoodList *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodList"];
    [cell populateDataExchage:self.arrAreaExchangeList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self pushToGoodDetial:indexPath];
}

- (void)pushToGoodDetial:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
    AreaExchangeDetailController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaExchangeDetailController"];
    controller.model = self.arrAreaExchangeList[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.arrAreaExchangeList.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CLCellGoods";
    CLCellGoods *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ModelEreaExchageList *model = (ModelEreaExchageList *)self.arrAreaExchangeList[indexPath.row];
    [cell.lblTitle setTextNull:model.ig_goods_name];
//    原价和现价
    NSString *strPriceNow = [NSString stringStandardFloatTwo:model.ig_goods_integral];
    NSString *strPriceOld = StringFormat(@"￥%@",[NSString stringStandardFloatTwo:model.ig_goods_price]);
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@积分 %@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                             range:NSMakeRange(0, strPriceNow.length)];
    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}
                             range:NSMakeRange(strPriceNow.length+3, strPriceOld.length)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary,
                                    NSFontAttributeName:[UIFont systemFontOfSize:11.0]}
                            range:NSMakeRange(strPriceNow.length, atrStringPrice.length-strPriceNow.length)];
    [cell.lblPrice setTextColor:ColorHeader];
    [cell.lblPrice setAttributedText:atrStringPrice];
    
    
    NSString *strNum = TransformString(model.ig_exchange_count);
    NSString *strleve = TransformString(model.ig_goods_count);
    NSMutableAttributedString * atrStringNum = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"已换%@     剩余%@",strNum,strleve)];
    [atrStringNum addAttributes:@{NSForegroundColorAttributeName:ColorHeader}
                          range:NSMakeRange(2+strNum.length, atrStringNum.length-strNum.length-2)];
    [cell.lblExchange setAttributedText:atrStringNum];
    [cell.imgGoods setImagePathListSquare:model.img];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/2+110);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        [self pushToGoodDetial:indexPath];
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        CLCellGoods * cell = (CLCellGoods *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = ColorBackground;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.collectionView) {
        CLCellGoods * cell = (CLCellGoods *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}


@end

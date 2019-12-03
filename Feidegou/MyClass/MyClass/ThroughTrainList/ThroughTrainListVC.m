//
//  ThroughTrainListVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/28.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "ThroughTrainListVC.h"
#import "ThroughTrainListVC+VM.h"

#import "HQCollectionViewFlowLayout.h"
#import "HQTopStopView.h"
#import "ThroughTrainListCollectionViewCell.h"
#import "DetailsVC.h"

@interface ThroughTrainListVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
PGBannerDelegate
>

@property(nonatomic,strong)HQCollectionViewFlowLayout *flowlayout;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation ThroughTrainListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    ThroughTrainListVC *vc = ThroughTrainListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.page = 1;
    vc.quantity = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navTitle = @"喵粮精选";
    self.collectionView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
//下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    self.page ++;
    [self netWorking];
    NSLog(@"上拉加载更多");
}
#pragma mark ---------  UICollectionViewDataSource 配置单元格   --------------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThroughTrainListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThroughTrainListCollectionViewCell"
                                                                                         forIndexPath:indexPath];
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    }return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}
#pragma mark —— PGBannerDelegate
- (void)selectAction:(NSInteger)didSelectAtIndex didSelectView:(id)view {
    NSLog(@"index = %ld  view = %@", didSelectAtIndex, view);
}
#pragma mark ——  UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
//点击单元格
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath
                                   animated:YES];
    @weakify(self)
    [DetailsVC ComingFromVC:self_weak_
                  withStyle:ComingStyle_PUSH
              requestParams:nil
                    success:^(id data) {}
                   animated:YES];
}
//配置区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        HQTopStopView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withReuseIdentifier:ReuseIdentifier
                                                                              forIndexPath:indexPath];
        headerView.searchView.scrollView.scrollEnabled = NO;
        return headerView;
    }return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//设置区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH,SCALING_RATIO(50));
}
//设置区尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat d = (SCREEN_WIDTH -1-2-2) / 2;
    return CGSizeMake(d,d * 640 * 2 / 467 / 3);
}
#pragma mark —— lazyLoad
-(HQCollectionViewFlowLayout *)flowlayout{
    if (!_flowlayout) {
        _flowlayout = HQCollectionViewFlowLayout.new;
        //设置悬停高度
        _flowlayout.naviHeight = 0;
        //设置滚动方向
        [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        _flowlayout.minimumInteritemSpacing = 1;
        //上下间距
        _flowlayout.minimumLineSpacing = 1;
        _flowlayout.sectionInset = UIEdgeInsetsMake(0,
                                                    2,
                                                    0,
                                                    2);
    }return _flowlayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                 self.gk_navigationBar.mj_h,
                                                                                 SCREEN_WIDTH,
                                                                                 SCREEN_HEIGHT)
                                                 collectionViewLayout:self.flowlayout];
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.mj_header = self.tableViewHeader;
    _collectionView.mj_footer = self.tableViewFooter;
    [_collectionView setBackgroundColor:kClearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册单元格
    [_collectionView registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[ThroughTrainListCollectionViewCell class]
        forCellWithReuseIdentifier:@"ThroughTrainListCollectionViewCell"];
    //注册区头
    [_collectionView registerClass:[HQTopStopView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:ReuseIdentifier];
    [self.view addSubview:_collectionView];
    return _collectionView;
}

-(NSMutableArray<ThroughTrainListModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}



@end

//
//  GoodsListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodsListController.h"
#import "TypeSegmentControl.h"
#import "CellGoodList.h"
#import "JJHttpClient+ShopGood.h"
#import "CLCellGoods.h"
#import "GoodDetailController.h"
#import "GoodDetialAllController.h"
#import "ViewForTypeSelect.h"
#import "ViewForTypeSelectLeftSlide.h"
#import "FilterMoreController.h"
#import "FilterTypeController.h"
#import "TypeSelectFunction.h"
#import "ButtonSearch.h"
#import "SearchGoodController.h"

@interface GoodsListController ()
<RefreshControlDelegate,
TypeSelectDelegete>

@property (weak, nonatomic) IBOutlet UIView *viHead;
@property (weak, nonatomic) IBOutlet UIView *viType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet BaseTableView *tabGoods;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
@property (strong, nonatomic) NSMutableArray *arrGoods;
@property (strong, nonatomic) UIButton *btnSelect;
@property (nonatomic,strong) RefreshControl *refreshControlGood;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量
//@property (nonatomic,strong) NSArray *arrType;//类型数组
//@property (nonatomic,strong) RefreshControl *refreshControl;
@end
NSMutableArray *arrTypeSelected;
NSString *strPriceStart;
NSString *strPriceEnd;
@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    arrTypeSelected = [NSMutableArray array];
    self.layoutConstraintHeight.constant = 0;
    UIView *viHead = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              SCREEN_WIDTH,
                                                              64)];
    [viHead setBackgroundColor:ColorHeader];
    [self.viHead addSubview:viHead];
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setFrame:CGRectMake(0,
                                      20,
                                      60,
                                      44)];
    [self.btnBack addTarget:self
                     action:@selector(clickButtonBack:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack setImage:ImageNamed(@"img_back") forState:UIControlStateNormal];
    [viHead addSubview:self.btnBack];
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSelect setFrame:CGRectMake(SCREEN_WIDTH - 60,
                                        20,
                                        60,
                                        44)];
    [self.btnSelect setSelected:YES];
    [self.btnSelect addTarget:self
                       action:@selector(clickButtonTypeSelect:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelect setImage:ImageNamed(@"img_hengxiang_n")
                    forState:UIControlStateNormal];
    [self.btnSelect setImage:ImageNamed(@"img_hengxiang_s")
                    forState:UIControlStateSelected];
//    [viHead addSubview:self.btnSelect];
    ButtonSearch *buttonSearch=[[ButtonSearch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btnBack.frame),
                                                                             viHead.frame.size.height - 37,
                                                                             CGRectGetMinX(self.btnSelect.frame) - CGRectGetMaxX(self.btnBack.frame),
                                                                             30)];
    if (![NSString isNullString:self.strSearch]) {
        [buttonSearch.lblContent setText:self.strSearch];
    }
    [buttonSearch handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([NSString isNullString:self.strSearch]) {
            D_NSLog(@"clickButtonSearch");
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            SearchGoodController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SearchGoodController"];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:controller animated:NO];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    [viHead addSubview:buttonSearch];
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetHeight(viHead.frame) - 0.5,
                                                                 CGRectGetWidth(viHead.frame),
                                                                 0.5)];
    [lblLine setBackgroundColor:ColorFromRGBSame(216)];
    [viHead addSubview:lblLine];
    
    TypeSegmentControl *segmented=[[TypeSegmentControl alloc]
                                        initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 36)
                                        items:
                                        @[@{@"text":@"综合"},
                                          @{@"text":@"销量",@"icon":@"yes"},
                                          @{@"text":@"价格",@"icon":@"yes"},
                                          @{@"text":@"筛选",@"icon":@"img_select_sx"}
                                          ]
                                        iconPosition:IconPositionLeft
                                        andSelectionBlock:^(NSUInteger segmentIndex, BOOL selcted) {
                                            switch (segmentIndex) {
                                                case 0:
                                                    D_NSLog(@"0 %ld",(long)selcted);
                                                    self.strOrder = @"";
                                                    self.strSort = @"";
                                                    [self.refreshControlGood beginRefreshingMethod];
                                                case 1:
                                                    D_NSLog(@"1 %ld",(long)selcted);
                                                    self.strOrder = @"salenum";
                                                    if (selcted) {
                                                        self.strSort = @"2";
                                                    }else{
                                                        self.strSort = @"1";
                                                    }
                                                    [self.refreshControlGood beginRefreshingMethod];
                                                    break;
                                                case 2:
                                                    D_NSLog(@"2 %ld",(long)selcted);
                                                    self.strOrder = @"price";
                                                    if (selcted) {
                                                        self.strSort = @"2";
                                                    }else{
                                                        self.strSort = @"1";
                                                    }
                                                    [self.refreshControlGood beginRefreshingMethod];
                                                    break;
                                                case 3:
                                                    [self initSelectTypeLeftSlide];
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }
                                        }];
    [self.view addSubview:segmented];
    
    [self.collectionView setBackgroundColor:ColorBackground];
    [self.collectionView registerClass:[CLCellGoods class]
            forCellWithReuseIdentifier:@"CLCellGoods"];
//    [self.tabGoods registerNib:[UINib nibWithNibName:@"CellGoodList" bundle:nil] forCellReuseIdentifier:@"CellGoodList"];
    [self.tabGoods setHidden:YES];
    [self.collectionView setHidden:NO];
//    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGoods delegate:self];
    self.refreshControlGood = [[RefreshControl new] initRefreshControlWithScrollView:self.collectionView delegate:self];
    [self.refreshControlGood beginRefreshingMethod];
}
#pragma mark --- 新建选择分类
- (void)initSelectType:(NSArray *)array{
    self.layoutConstraintHeight.constant = 40;
    ViewForTypeSelect *viewTypeSelect = [[ViewForTypeSelect alloc] initWithFrame:CGRectMake(0,
                                                                                            100,
                                                                                            SCREEN_WIDTH,
                                                                                            40)
                                                                        andArray:array];
    [viewTypeSelect setDelegete:self];
    [self.view addSubview:viewTypeSelect];
}

- (void)clickConfilmAndTheResult{
    NSMutableArray *arrNew = [NSMutableArray array];
    for (int i = 0; i<arrTypeSelected.count; i++) {
        NSString *strName = arrTypeSelected[i][@"name"];
        NSMutableArray *arrMiddle = [NSMutableArray array];
        
        NSArray *arrValue = [NSArray arrayWithArray:arrTypeSelected[i][@"value"]];
        for (int j = 0; j<arrValue.count; j++) {
            if ([arrValue[j][IsSelected] intValue] == 1) {
                [arrMiddle addObject:arrValue[j][TypeName]];
            }
        }
        if (arrMiddle.count>0) {
            NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
            [dictionay setObject:strName forKey:@"name"];
            NSString *strValue = [arrMiddle componentsJoinedByString:@","];
            [dictionay setObject:strValue forKey:@"value"];
            [arrNew addObject:dictionay];
            D_NSLog(@"name is %@,value is %@",strName,strValue);
        }
    }
    [self.refreshControlGood beginRefreshingMethod];
//    [self.refreshControl beginRefreshingMethod];
    D_NSLog(@"arrNew is %@",arrNew);
}
#pragma mark --- 新建筛选
- (void)initSelectTypeLeftSlide{
    ViewForTypeSelectLeftSlide *viewTypeSelect = [[ViewForTypeSelectLeftSlide alloc] initWithFrame:CGRectMake(0,
                                                                                                              0,
                                                                                                              SCREEN_WIDTH,
                                                                                                              SCREEN_HEIGHT)
                                                                                          andArray:arrTypeSelected];
    [viewTypeSelect setDelegete:self];
    [self.view.window addSubview:viewTypeSelect];
}

- (void)clickButtonTypeSelect:(UIButton *)sender{
    [self refreshListType];
}

- (void)refreshListType{
//    if (self.btnSelect.selected) {
//        [self.tabGoods setHidden:NO];
//        [self.collectionView setHidden:YES];
//        [self.btnSelect setSelected:NO];
//    }else{
//        [self.tabGoods setHidden:YES];
        [self.collectionView setHidden:NO];
        [self.btnSelect setSelected:YES];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:animated];
    D_NSLog(@"arrTypeSelected is %@",arrTypeSelected);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isShow) {
        [self.navigationController setNavigationBarHidden:NO
                                                 animated:animated];
    }
}

- (void)requestExchangeList{
    if ([self.dicInfo isKindOfClass:[NSDictionary class]]) {
        self.goodsType_id = self.dicInfo[@"goodsType_id"];
    }
    __weak GoodsListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodGoodTypeLimit:@"10"
                                                                  andPage:TransformNSInteger(self.intPageIndex)
                                                          andGoodsType_id:[NSString stringStandard:self.goodsType_id]
                                                             andgoodsName:[NSString stringStandard:self.strSearch]
                                                        andgoods_brand_id:[NSString stringStandard:self.strGoods_brand_id]
                                                                  andsort:[NSString stringStandard:self.strSort]
                                                                 andorder:[NSString stringStandard:self.strOrder]
                                                            andpriceStart:[NSString stringStandard:strPriceStart]
                                                              andpriceEnd:[NSString stringStandard:strPriceEnd]
                                                              andgoodArea:[NSString stringStandard:self.goodArea]
                                                          andgoodActivity:[NSString stringStandard:self.goodActivity]
                                                             andgood_area:[NSString stringStandard:self.good_area]]
                         subscribeNext:^(NSDictionary *dictionary) {
        NSArray *array = [NSArray array];
        if ([dictionary[@"goodsList"] isKindOfClass:[NSArray class]]) {
            NSArray *arrayMiddle = [NSArray arrayWithArray:dictionary[@"goodsList"]];
            RACSequence *sequence=[arrayMiddle rac_sequence];
            array = [[sequence map:^id(NSDictionary *item){
                ModelGood *model = [MTLJSONAdapter modelOfClass:[ModelGood class] fromJSONDictionary:item error:nil];
                return model;
            }] array];
        }
        if ([dictionary[@"goodstypeproperty"] isKindOfClass:[NSArray class]]) {
            if (arrTypeSelected.count==0) {
                NSArray *arrGoodstypeproperty = [NSArray arrayWithArray:dictionary[@"goodstypeproperty"]];
                arrTypeSelected = [NSMutableArray array];
                for (int i = 0; i<arrGoodstypeproperty.count; i++) {
                    NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrGoodstypeproperty[i]];
                    
                    NSString *strName = dicMiddle[@"name"];
                    NSString *strValue = dicMiddle[@"value"];
                    NSArray *arrValue = [strValue componentsSeparatedByString:@","];
                    
                    NSMutableArray *arrSelected = [NSMutableArray array];
                    for (int j = 0; j<arrValue.count; j++) {
                        NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
                        [dicValue setObject:arrValue[j] forKey:TypeName];
                        [dicValue setObject:@"" forKey:IsSelected];
                        [arrSelected addObject:dicValue];
                    }
                    [dicMiddle setObject:@"" forKey:IsAll];
                    [dicMiddle setObject:strName forKey:@"name"];
                    [dicMiddle setObject:arrSelected forKey:@"value"];
                    [arrTypeSelected addObject:dicMiddle];
                }
                [self initSelectType:arrTypeSelected];
            }
        }
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrGoods = [NSMutableArray array];
        }
        [myself.arrGoods addObjectsFromArray:array];
//        [myself.tabGoods checkNoData:myself.arrGoods.count];
//        [myself.tabGoods reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself.collectionView reloadData];
        });
    }error:^(NSError *error) {
        myself.disposable = nil;
//        [myself.refreshControl endRefreshing];
        [myself.refreshControlGood endRefreshing];
//        [myself.tabGoods checkNoData:myself.arrGoods.count];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
    }completed:^{
        myself.intPageIndex++;
//        [myself.refreshControl endRefreshing];
        [myself.refreshControlGood endRefreshing];
        myself.disposable = nil;
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
    }return NO;
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.arrGoods.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellGoods";
    CLCellGoods *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                  forIndexPath:indexPath];
    [cell populateData:self.arrGoods[indexPath.row]];
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
    return UIEdgeInsetsMake(0,
                            0,
                            0,
                            0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        [self pushToGoodDetial:indexPath];
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        CLCellGoods * cell = (CLCellGoods *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = ColorBackground;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        CLCellGoods * cell = (CLCellGoods *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.arrGoods.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellGoodList *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodList"];
    [cell populateData:self.arrGoods[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self pushToGoodDetial:indexPath];
}

- (void)pushToGoodDetial:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
    ModelGood *model = self.arrGoods[indexPath.row];
    controller.strGood_id = model.goods_id;
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}


@end

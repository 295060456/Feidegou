//
//  OrderListVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderListVC+VM.h"

#import "OrderManager_producingAreaVC.h"//厂家（产地）
#import "OrderManager_wholesaleVC.h"//批发
#import "OrderManager_panicBuyingVC.h"//抢购

@interface OrderListVC ()
<
UITextFieldDelegate
,JXCategoryTitleViewDataSource
,JXCategoryListContainerViewDelegate
,JXCategoryViewDelegate
>

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)JXCategoryTitleImageView *categoryView;
@property(nonatomic,strong)JXCategoryIndicatorLineView *lineView;
@property(nonatomic,strong)JXCategoryListContainerView *listContainerView;
@property(nonatomic,strong)OrderManager_producingAreaVC *producingAreaVC;
@property(nonatomic,strong)OrderManager_wholesaleVC *wholesaleVC;
@property(nonatomic,strong)OrderManager_panicBuyingVC *panicBuyingVC;

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*imageNamesMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*selectedImageNamesMutArr;
@property(nonatomic,strong)NSMutableArray <BaseVC *>*childVCMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation OrderListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)CominngFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderListVC *vc = OrderListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.page = 1;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {

    }
 
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                vc.isFirstComing = YES;
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
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
//    self.gk_navTitle = @"个人喵粮变动清单";
    self.categoryView.alpha = 1;
    self.lineView.alpha = 1;
    self.listContainerView.alpha = 1;
    self.textField.alpha = 1;
//    self.tableView.alpha = 1;

    self.gk_navigationBar.backgroundColor = KYellowColor;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.page++;
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark —— UITextFieldDelegate

//rong)OrderManager_producingAreaVC *producingAreaVC;
//@property(nonatomic,strong)OrderManager_wholesaleVC *wholesaleVC;
//@property(nonatomic,strong)OrderManager_panicBuyingVC *panicBuyingVC;

#pragma mark JXCategoryTitleViewDataSource
// 如果将JXCategoryTitleView嵌套进UITableView的cell，每次重用的时候，JXCategoryTitleView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给JXCategoryTitleView。
// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
//- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView
//               widthForTitle:(NSString *)title{
//
//    return 100;
//}
#pragma mark JXCategoryListContainerViewDelegate
/**
 返回list的数量
 
 @param listContainerView 列表的容器视图
 @return list的数量
 */
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return self.titleMutArr.count;
}
/**
 根据index初始化一个对应列表实例，需要是遵从`JXCategoryListContentViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIViewController即可。
 
 @param listContainerView 列表的容器视图
 @param index 目标下标
 @return 遵从JXCategoryListContentViewDelegate协议的list实例
 */
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView
                                          initListForIndex:(NSInteger)index{
    return self.childVCMutArr[index];
}
#pragma mark JXCategoryViewDelegate
//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView
didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

//传递scrolling事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView
scrollingFromLeftIndex:(NSInteger)leftIndex
        toRightIndex:(NSInteger)rightIndex
               ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex
                                      toRightIndex:rightIndex
                                             ratio:ratio
                                     selectedIndex:categoryView.selectedIndex];
}
#pragma mark —— lazyLoad
-(UITextField *)textField{
    if (!_textField) {
        _textField = UITextField.new;
        _textField.backgroundColor = KLightGrayColor;
        _textField.placeholder = @"请输入查询ID";
        _textField.delegate = self;
        [UIView cornerCutToCircleWithView:_textField
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_textField
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        [self.gk_navigationBar addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gk_navigationBar.mj_y);
            make.height.mas_equalTo(SCALING_RATIO(35));
            make.width.mas_equalTo(SCREEN_WIDTH - SCALING_RATIO(150));
            make.left.equalTo(self.view).offset(SCALING_RATIO(80));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-30));
        }];
    }return _textField;
}

-(OrderManager_producingAreaVC *)producingAreaVC{
    if (!_producingAreaVC) {
        _producingAreaVC = [OrderManager_producingAreaVC initWithrequestParams:nil
                                                                       success:^(id data) {
        }];
    }return _producingAreaVC;
}

-(OrderManager_wholesaleVC *)wholesaleVC{
    if (!_wholesaleVC) {
        _wholesaleVC = [OrderManager_wholesaleVC initWithrequestParams:nil
                                                               success:^(id data) {
        }];
    }return _wholesaleVC;
}

-(OrderManager_panicBuyingVC *)panicBuyingVC{
    if (!_panicBuyingVC) {
        _panicBuyingVC = [OrderManager_panicBuyingVC initWithrequestParams:nil
                                                                   success:^(id data) {
        }];
    }return _panicBuyingVC;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"抢购"];
        [_titleMutArr addObject:@"厂家"];
        [_titleMutArr addObject:@"批发"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)imageNamesMutArr{
    if (!_imageNamesMutArr) {
        _imageNamesMutArr = NSMutableArray.array;
        [_imageNamesMutArr addObject:@"抢购_unselected"];
        [_imageNamesMutArr addObject:@"厂家_unselected"];
        [_imageNamesMutArr addObject:@"批发_unselected"];
    }return _imageNamesMutArr;
}

-(NSMutableArray<NSString *> *)selectedImageNamesMutArr{
    if (!_selectedImageNamesMutArr) {
        _selectedImageNamesMutArr = NSMutableArray.array;
        [_selectedImageNamesMutArr addObject:@"抢购_selected"];
        [_selectedImageNamesMutArr addObject:@"厂家_selected"];
        [_selectedImageNamesMutArr addObject:@"批发_selected"];
    }return _selectedImageNamesMutArr;
}

-(NSMutableArray<BaseVC *> *)childVCMutArr{
    if (!_childVCMutArr) {
        _childVCMutArr = NSMutableArray.array;
        [self.childVCMutArr addObject:self.producingAreaVC];
        [self.childVCMutArr addObject:self.wholesaleVC];
        [self.childVCMutArr addObject:self.panicBuyingVC];
    }return _childVCMutArr;
}

-(JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        //        _listContainerView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_listContainerView];
        [self.view layoutIfNeeded];
        [_listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.lineView.mas_bottom);
        }];
        //关联cotentScrollView，关联之后才可以互相联动！！！
        self.categoryView.contentScrollView = _listContainerView.scrollView;
        [self.view layoutIfNeeded];
    }return _listContainerView;
}

-(JXCategoryTitleImageView *)categoryView{
    
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   self.gk_navigationBar.mj_y + self.gk_navigationBar.mj_h,
                                                                                   MAINSCREEN_WIDTH - SCALING_RATIO(0),
                                                                                   SCALING_RATIO(50))];
        _categoryView.delegate = self;
        _categoryView.titles = self.titleMutArr;
        _categoryView.backgroundColor = kWhiteColor;//AppMainThemeColor;
        //        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.imageNames = self.imageNamesMutArr;
        _categoryView.selectedImageNames = self.selectedImageNamesMutArr;
        _categoryView.imageZoomEnabled = YES;
        _categoryView.imageZoomScale = 1.3;
        _categoryView.averageCellSpacingEnabled = YES;
        [self configCategoryViewWithType:JXCategoryTitleImageType_LeftImage];
        [self.view addSubview:_categoryView];
    }return _categoryView;
}

- (void)configCategoryViewWithType:(JXCategoryTitleImageType)imageType {
    if ((NSInteger)imageType == 100) {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titleMutArr.count; i++) {
            if (i == 2) {
                [types addObject:@(JXCategoryTitleImageType_OnlyImage)];
            }else if (i == 4) {
                [types addObject:@(JXCategoryTitleImageType_LeftImage)];
            }else {
                [types addObject:@(JXCategoryTitleImageType_OnlyTitle)];
            }
        }
        self.categoryView.imageTypes = types;
    }else {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titleMutArr.count; i++) {
            [types addObject:@(imageType)];
        }
        self.categoryView.imageTypes = types;
    }
    [self.categoryView reloadData];
}

-(JXCategoryIndicatorLineView *)lineView{
    if (!_lineView) {
        _lineView = JXCategoryIndicatorLineView.new;
        _lineView.indicatorLineViewColor = HEXCOLOR(0x5688F7);
        _lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        self.categoryView.indicators = @[_lineView];
    }return _lineView;
}

@end

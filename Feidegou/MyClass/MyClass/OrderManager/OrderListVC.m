//
//  OrderListVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderListVC+VM.h"
#import "SearchVC.h"

#import "OrderManager_producingAreaVC.h"//厂家（产地）
#import "OrderManager_panicBuyingVC.h"//直通车

OrderListVC *orderListVC;

@interface OrderListVC ()<JXCategoryViewDelegate>

@property(nonatomic,strong)OrderManager_producingAreaVC *producingAreaVC;
@property(nonatomic,strong)OrderManager_panicBuyingVC *panicBuyingVC;
@property(nonatomic,strong)JXCategoryTitleImageView *myCategoryView;
@property(nonatomic,strong)JXCategoryIndicatorLineView *lineView;
@property(nonatomic,assign)JXCategoryTitleImageType currentType;
@property(nonatomic,strong)UIButton *filterBtn;

@property(nonatomic,strong)NSArray *imageNames;
@property(nonatomic,strong)NSArray *selectedImageNames;
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

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    OrderListVC *vc = OrderListVC.new;
    orderListVC = vc;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.titles = (NSArray *)vc.titleMutArr;
    vc.imageNames = (NSArray *)vc.titleMutArr;
    vc.selectedImageNames = (NSArray *)vc.selectedImageNamesMutArr;

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
    
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];
    self.gk_navTitle = @"订单管理";
    
    self.myCategoryView.titles = (NSArray *)self.titleMutArr;
    self.myCategoryView.backgroundColor = kWhiteColor;
    self.myCategoryView.imageNames = (NSArray *)self.imageNamesMutArr;
    self.myCategoryView.selectedImageNames = (NSArray *)self.selectedImageNamesMutArr;
    self.myCategoryView.imageZoomEnabled = YES;
    self.myCategoryView.imageZoomScale = 1.3;
    self.myCategoryView.averageCellSpacingEnabled = YES;
    self.myCategoryView.indicators = @[self.lineView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.gk_interactivePopDisabled = YES;//禁止手势侧滑
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
 
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.categoryView.frame = CGRectMake(0,
                                         self.gk_navigationBar.mj_h,
                                         self.view.bounds.size.width,
                                         [self preferredCategoryViewHeight]);
    self.listContainerView.frame = CGRectMake(0,
                                              self.gk_navigationBar.mj_h,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"");
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));
}
#pragma mark —— JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView
didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryViewAction"
                                                        object:@(index)];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView
didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView
                                          initListForIndex:(NSInteger)index {
    return self.childVCMutArr[index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

-(void)filterBtnClickEvent:(UIButton *)sender{
    @weakify(self)
    [SearchVC ComingFromVC:self_weak_
                  withStyle:ComingStyle_PUSH
              requestParams:@""
                    success:^(id data) {}
                   animated:YES];
}
#pragma mark —— 私有方法

#pragma mark —— lazyLoad
- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (JXCategoryTitleImageView *)myCategoryView {
    return (JXCategoryTitleImageView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return JXCategoryTitleImageView.new;
}

-(UIButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = UIButton.new;
        [_filterBtn setImage:kIMG(@"magnifier")
                    forState:UIControlStateNormal];
        [_filterBtn addTarget:self
                       action:@selector(filterBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    }return _filterBtn;
}

-(OrderManager_producingAreaVC *)producingAreaVC{
    if (!_producingAreaVC) {
        _producingAreaVC = [OrderManager_producingAreaVC initWithrequestParams:nil
                                                                       success:^(id data) {
        }];
    }return _producingAreaVC;
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
        [_titleMutArr addObject:@"直通车"];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {//高级商家
                
            }else if ([model.grade_id intValue] == 3){//vip商家
                [_titleMutArr addObject:@"厂家"];
            }
        }
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)imageNamesMutArr{
    if (!_imageNamesMutArr) {
        _imageNamesMutArr = NSMutableArray.array;
        [_imageNamesMutArr addObject:@"panicPurchase_unselected"];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {//高级商家
                
            }else if ([model.grade_id intValue] == 3){//vip商家
                [_imageNamesMutArr addObject:@"producingArea_unselected"];
            }
        }
    }return _imageNamesMutArr;
}

-(NSMutableArray<NSString *> *)selectedImageNamesMutArr{
    if (!_selectedImageNamesMutArr) {
        _selectedImageNamesMutArr = NSMutableArray.array;
        [_selectedImageNamesMutArr addObject:@"panicPurchase_selected"];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {//高级商家
                
            }else if ([model.grade_id intValue] == 3){//vip商家
                [_selectedImageNamesMutArr addObject:@"producingArea_selected"];
            }
        }
    }return _selectedImageNamesMutArr;
}

-(NSMutableArray<BaseVC *> *)childVCMutArr{
    if (!_childVCMutArr) {
        _childVCMutArr = NSMutableArray.array;
        [self.childVCMutArr addObject:self.panicBuyingVC];
        if ([[PersonalInfo sharedInstance] isLogined]) {
            ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
            if ([model.grade_id intValue] == 2) {//高级商家
                
            }else if ([model.grade_id intValue] == 3){//vip商家
                [self.childVCMutArr addObject:self.producingAreaVC];
            }
        }
    }return _childVCMutArr;
}

-(JXCategoryIndicatorLineView *)lineView{
    if (!_lineView) {
        _lineView = JXCategoryIndicatorLineView.new;
        _lineView.indicatorWidth = SCREEN_WIDTH / self.titleMutArr.count;
    }return _lineView;
}

@end

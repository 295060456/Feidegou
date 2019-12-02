//
//  DetailsVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/27.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "DetailsVC.h"

#import "EvaluateVC.h"
#import "GoodsDetailsVC.h"
#import "GoodsVC.h"

@interface DetailsVC ()
<
JXCategoryViewDelegate
>

@property(nonatomic,strong)EvaluateVC *evaluateVC;
@property(nonatomic,strong)GoodsDetailsVC *goodsDetailsVC;
@property(nonatomic,strong)GoodsVC *goodsVC;

@property(nonatomic,strong)JXCategoryTitleImageView *myCategoryView;
@property(nonatomic,strong)JXCategoryIndicatorLineView *lineView;
@property(nonatomic,assign)JXCategoryTitleImageType currentType;

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
//@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation DetailsVC

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    DetailsVC *vc = DetailsVC.new;
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
    self.gk_navBackgroundColor = kClearColor;
    
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
    self.gk_navigationBar.alpha = 0;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
 
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.categoryView.frame = CGRectMake(0,
                                         rectOfStatusbar,
                                         self.view.bounds.size.width,
                                         [self preferredCategoryViewHeight]);
    self.listContainerView.frame = CGRectMake(0,
                                              rectOfStatusbar,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height);
}

#pragma mark - JXCategoryViewDelegate
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
#pragma mark —— lazyLoad
- (CGFloat)preferredCategoryViewHeight {
    return SCALING_RATIO(50);
}

- (JXCategoryTitleImageView *)myCategoryView {
    return (JXCategoryTitleImageView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return JXCategoryTitleImageView.new;
}

-(EvaluateVC *)evaluateVC{
    if (!_evaluateVC) {
        _evaluateVC  = [EvaluateVC initWithrequestParams:nil
                                                 success:^(id data) {}];
    }return _evaluateVC;
}

-(GoodsDetailsVC *)goodsDetailsVC{
    if (!_goodsDetailsVC) {
        _goodsDetailsVC = [GoodsDetailsVC initWithrequestParams:nil
                                                        success:^(id data) {}];
    }return _goodsDetailsVC;
}

-(GoodsVC *)goodsVC{
    if (!_goodsVC) {
        _goodsVC = [GoodsVC initWithrequestParams:nil
                                          success:^(id data) {}];
    }return _goodsVC;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"商品"];
        [_titleMutArr addObject:@"详情"];
        [_titleMutArr addObject:@"评价"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)imageNamesMutArr{
    if (!_imageNamesMutArr) {
        _imageNamesMutArr = NSMutableArray.array;
        [_imageNamesMutArr addObject:@"panicPurchase_unselected"];
        [_imageNamesMutArr addObject:@"wholesaleMarket_unselected"];
        [_imageNamesMutArr addObject:@"producingArea_unselected"];
    }return _imageNamesMutArr;
}

-(NSMutableArray<NSString *> *)selectedImageNamesMutArr{
    if (!_selectedImageNamesMutArr) {
        _selectedImageNamesMutArr = NSMutableArray.array;
        [_selectedImageNamesMutArr addObject:@"panicPurchase_selected"];
        [_selectedImageNamesMutArr addObject:@"wholesaleMarket_selected"];
        [_selectedImageNamesMutArr addObject:@"producingArea_selected"];
    }return _selectedImageNamesMutArr;
}

-(NSMutableArray<BaseVC *> *)childVCMutArr{
    if (!_childVCMutArr) {
        _childVCMutArr = NSMutableArray.array;
        [self.childVCMutArr addObject:self.goodsVC];
        [self.childVCMutArr addObject:self.goodsDetailsVC];
        [self.childVCMutArr addObject:self.evaluateVC];
    }return _childVCMutArr;
}

-(JXCategoryIndicatorLineView *)lineView{
    if (!_lineView) {
        _lineView = JXCategoryIndicatorLineView.new;
        _lineView.indicatorWidth = SCALING_RATIO(80);
    }return _lineView;
}


@end

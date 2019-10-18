//
//  GoodsTypeController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/6/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodsTypeController.h"
#import "CellOneLabel.h"
#import "GoodSecendTypeController.h"
#import "JJHttpClient+ShopGood.h"
#import "ButtonSearch.h"
#import "SearchGoodController.h"

@interface GoodsTypeController ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tabType;
@property (weak, nonatomic) IBOutlet UIView *viContainer;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign, nonatomic) NSInteger intSelected;

@end

@implementation GoodsTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self initHeaderView];
    [self.tabType setBackgroundColor:[UIColor whiteColor]];
    [self.viContainer setBackgroundColor:ColorBackground];
    [self.tabType registerNib:[UINib nibWithNibName:@"CellOneLabel"
                                             bundle:nil]
       forCellReuseIdentifier:@"CellOneLabel"];
    [self requestData];
}

- (void)initHeaderView{
    UIView *viHead = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              SCREEN_WIDTH,
                                                              64)];
    [viHead setBackgroundColor:ColorHeader];
    [self.view addSubview:viHead];
    ButtonSearch *buttonSearch=[[ButtonSearch alloc]initWithFrame:CGRectMake(60,
                                                                             viHead.frame.size.height - 37,
                                                                             SCREEN_WIDTH - 60 - 60,
                                                                             30)];
    [buttonSearch handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        D_NSLog(@"clickButtonSearch");
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        SearchGoodController *controller=[storyboard instantiateViewControllerWithIdentifier:@"SearchGoodController"];
        [self.navigationController pushViewController:controller animated:NO];
    }];
    [viHead addSubview:buttonSearch];
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetHeight(viHead.frame) - 0.5,
                                                                 CGRectGetWidth(viHead.frame),
                                                                 0.5)];
    [lblLine setBackgroundColor:ColorFromRGBSame(216)];
    [viHead addSubview:lblLine];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:animated];
}

- (void)requestData{
    [self showException];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodTypeOne] subscribeNext:^(NSArray* array) {
        @strongify(self)
        self.arrType = [NSMutableArray arrayWithArray:array];
        [self setLayout];
        [self hideException];
    }error:^(NSError *error) {
        @strongify(self)
        [self failedRequestException:enum_exception_timeout];
        self.disposable = nil;
    }completed:^{
        @strongify(self)
        self.disposable = nil;
    }];
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.arrType.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellOneLabel *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneLabel"];
    ModelGoodTypeOne *model = self.arrType[indexPath.row];
    [cell.lblContent setTextNull:model.className];
    [cell.lblContent setTextAlignment:NSTextAlignmentCenter];
    [cell.lblContent setNumberOfLines:2];
    cell.layoutConstraintPre.constant = 5;
    cell.layoutConstraintEnd.constant = 5;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=ColorBackground;
    cell.selectedBackgroundView=view;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.intSelected = indexPath.row;
    [self pageControlValueChanged:indexPath.row];
}

- (void)setLayout{
    self.intSelected = 0;
    [self.tabType reloadData];
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< self.arrType.count; i++) {
        GoodSecendTypeController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodSecendTypeController"];
        controller.model = self.arrType[i];
        [self.pages addObject:controller];
    }
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.view.frame = CGRectMake(0,
                                                    0,
                                                    self.viContainer.frame.size.width,
                                                    self.viContainer.frame.size.height);
//    [self.pageViewController setDataSource:self];
//    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.viContainer addSubview:self.pageViewController.view];
    if ([self.pages count]>0) {
        [self pageControlValueChanged:self.intSelected];
        [self.tabType selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.intSelected inSection:0]
                                  animated:YES
                            scrollPosition:UITableViewScrollPositionTop];
    }
}
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self.pages indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    if (!completed){
        return;
    }
    [self refreshSelectedButton:[self.pages indexOfObject:[viewController.viewControllers
                                                           lastObject]]];
}

#pragma mark -
#pragma mark - Callback
- (void)pageControlValueChanged:(NSInteger)interger{
    UIPageViewControllerNavigationDirection direction = interger > self.intSelected ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.pages[interger]]
                                      direction:direction
                                       animated:NO
                                     completion:NULL];
    [self refreshSelectedButton:interger];
}

- (void)refreshSelectedButton:(NSInteger)integer{
    [self.tabType scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle
                                                    animated:YES];
}

@end

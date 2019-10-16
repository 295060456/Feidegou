//
//  OrderListMainController.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/11.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "OrderListMainController.h"
#import "CLCellOneLblNoLine.h"
#import "MyOrderListController.h"

@interface OrderListMainController ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
UIGestureRecognizerDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionType;
@property (weak, nonatomic) IBOutlet UIView *viContainer;
@property (assign, nonatomic) NSInteger intRow;
@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLeading;

@end

@implementation OrderListMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionType registerClass:[CLCellOneLblNoLine class] forCellWithReuseIdentifier:@"CLCellOneLblNoLine"];
    [self.lblLine setBackgroundColor:ColorHeader];
    self.layoutWidth.constant = SCREEN_WIDTH/6-10;
    if (self.orderState == enumOrder_dfk){
        self.intRow = 1;
    }else if (self.orderState == enumOrder_yfk){
        self.intRow = 2;
    }else if (self.orderState == enumOrder_yfh){
        self.intRow = 3;
    }else if (self.orderState == enumOrder_ysh){
        self.intRow = 4;
    }else if (self.orderState == enumOrder_tksh){
        self.intRow = 5;
    }else{
        self.intRow = 0;
    }
    [self setLayout];
    // Do any additional setup after loading the view.
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CLCellOneLblNoLine";
    CLCellOneLblNoLine *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 1){
        [cell.lblContent setTextNull:@"待付款"];
    }else if (indexPath.row == 2){
        [cell.lblContent setTextNull:@"待发货"];
    }else if (indexPath.row == 3){
        [cell.lblContent setTextNull:@"待收货"];
    }else if (indexPath.row == 4){
        [cell.lblContent setTextNull:@"待评价"];
    }else if (indexPath.row == 5){
        [cell.lblContent setTextNull:@"退款售后"];
    }else{
        [cell.lblContent setTextNull:@"全部"];
    }
    if (self.intRow == indexPath.row) {
        [cell.lblContent setTextColor:ColorHeader];
    }else{
        [cell.lblContent setTextColor:ColorGaryDark];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/6,60);
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
//    if (indexPath.row == 1){
//        self.orderState = enumOrder_dfk;
//    }else if (indexPath.row == 2){
//        self.orderState = enumOrder_yfk;
//    }else if (indexPath.row == 3){
//        self.orderState = enumOrder_yfh;
//    }else if (indexPath.row == 4){
//        self.orderState = enumOrder_ysh;
//    }else if (indexPath.row == 5){
//        self.orderState = enumOrder_dbx;
//    }else{
//        self.orderState = enumOrder_quanbu;
//    }
    self.intRow = indexPath.row;
    [self pageControlValueChanged:self.intRow];
}

- (void)setLayout{
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< 6; i++) {
        MyOrderListController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderListController"];
        if (i == 1){
            controller.orderState = enumOrder_dfk;
        }else if (i == 2){
            controller.orderState = enumOrder_yfk;
        }else if (i == 3){
            controller.orderState = enumOrder_yfh;
        }else if (i == 4){
            controller.orderState = enumOrder_ysh;
        }else if (i == 5){
            controller.orderState = enumOrder_tksh;
        }else{
            controller.orderState = enumOrder_quanbu;
        }
        [self.pages addObject:controller];
    }
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viContainer.frame.size.width, self.viContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.viContainer addSubview:self.pageViewController.view];
    if ([self.pages count]>0) {
        [self pageControlValueChanged:self.intRow];
    }
}
#pragma mark -
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self.pages indexOfObject:viewController];

    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    } return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
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
    [self refreshSelectedButton:[self.pages indexOfObject:[viewController.viewControllers lastObject]]];
}

#pragma mark - Callback
- (void)pageControlValueChanged:(NSInteger)interger{
    UIPageViewControllerNavigationDirection direction = interger > self.intRow ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.pages[interger]]
                                      direction:direction
                                       animated:NO
                                     completion:NULL];
    [self refreshSelectedButton:interger];
}

- (void)refreshSelectedButton:(NSInteger)integer{
    self.intRow = integer;
    [UIView animateWithDuration:0.27 animations:^{
        self.layoutLeading.constant = self.intRow*SCREEN_WIDTH/6+5;
        [self.view layoutIfNeeded];
    }];
    [self.collectionType reloadData];
}


@end

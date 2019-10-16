//
//  GoodDetailDiscussController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/27.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDetailDiscussController.h"
#import "GoodDiscussListController.h"
#import "CLCellTwoLbl.h"

@interface GoodDetailDiscussController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,DiscussListNumDelegete>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viContainer;

@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign, nonatomic) NSInteger intSelected;

@property (strong, nonatomic) NSDictionary *dictionary;
@end

@implementation GoodDetailDiscussController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    
    [self.collectionView registerClass:[CLCellTwoLbl class] forCellWithReuseIdentifier:@"CLCellTwoLbl"];
    [self setLayout];
}
- (void)discussListNumDictonary:(NSDictionary *)dictionary{
    self.dictionary = [NSDictionary dictionaryWithDictionary:dictionary];
    [self.collectionView reloadData];
}
- (void)setLayout{
    self.intSelected = 0;
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< 4; i++) {
        GoodDiscussListController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDiscussListController"];
        if (i == 0) {
            [controller setDelegete:self];
            controller.enumState = enum_discuss_all;
        }else if (i == 1){
            controller.enumState = enum_discuss_good;
        }else if (i == 2){
            controller.enumState = enum_discuss_middle;
        }else{
            controller.enumState = enum_discuss_bad;
        }
        controller.strGood_id = self.strGood_id;
        controller.store_id = self.store_id;
        [self.pages addObject:controller];
    }
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viContainer.frame.size.width, self.viContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.viContainer addSubview:self.pageViewController.view];
    if ([self.pages count]>0) {
        [self pageControlValueChanged:self.intSelected];
    }
}
#pragma mark -
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    [self refreshSelectedButton:[self.pages indexOfObject:[viewController.viewControllers lastObject]]];
}

#pragma mark -
#pragma mark - Callback
- (void)pageControlValueChanged:(NSInteger)interger
{
    UIPageViewControllerNavigationDirection direction = interger > self.intSelected ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.pages[interger]]
                                      direction:direction
                                       animated:NO
                                     completion:NULL];
    [self refreshSelectedButton:interger];
}

- (void)refreshSelectedButton:(NSInteger)integer{
    self.intSelected = integer;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellTwoLbl";
    CLCellTwoLbl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == self.intSelected) {
        [cell.lblUp setTextColor:ColorRed];
        [cell.lblDown setTextColor:ColorRed];
    }else{
        [cell.lblUp setTextColor:ColorBlack];
        [cell.lblDown setTextColor:ColorBlack];
    }
    if (indexPath.row == 0) {
        [cell.lblUp setText:@"全部评价"];
        [cell.lblDown setText:[NSString stringStandardZero:self.dictionary[@"all"]]];
    }else if (indexPath.row == 1) {
        [cell.lblUp setText:@"好评"];
        [cell.lblDown setText:[NSString stringStandardZero:self.dictionary[@"good"]]];
    }else if (indexPath.row == 2) {
        [cell.lblUp setText:@"中评"];
        [cell.lblDown setText:[NSString stringStandardZero:self.dictionary[@"general"]]];
    }else{
        [cell.lblUp setText:@"差评"];
        [cell.lblDown setText:[NSString stringStandardZero:self.dictionary[@"poor"]]];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/4,60);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pageControlValueChanged:indexPath.row];
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

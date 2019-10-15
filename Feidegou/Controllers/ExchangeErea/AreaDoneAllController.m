//
//  AreaDoneAllController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaDoneAllController.h"
#import "AreaDoneListController.h"

@interface AreaDoneAllController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIView *viHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnReady;
@property (weak, nonatomic) IBOutlet UIButton *btnSendOut;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPre;
@property (weak, nonatomic) IBOutlet UIView *viContainer;



@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign, nonatomic) NSInteger intSelected;
@end

@implementation AreaDoneAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.btnAll setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnAll setTitleColor:ColorHeader forState:UIControlStateSelected];
    [self.btnReady setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnReady setTitleColor:ColorHeader forState:UIControlStateSelected];
    [self.btnSendOut setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnSendOut setTitleColor:ColorHeader forState:UIControlStateSelected];
    [self.btnAll setSelected:YES];
    [self.btnReady setSelected:NO];
    [self.btnSendOut setSelected:NO];
    [self.lblLine setBackgroundColor:ColorHeader];
    [self setLayout];
}

- (void)setLayout{
    self.intSelected = 100;
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< 3; i++) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaDoneListController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaDoneListController"];
        if (i == 1) {
            controller.orderState = enumOrder_yfk;
        }else if (i == 2){
            controller.orderState = enumOrder_yfh;
        }else{
            controller.orderState = enumOrder_quanbu;
        }
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
    [self refreshSelectedButton:[self.pages indexOfObject:[viewController.viewControllers lastObject]]+100];
}

#pragma mark -
#pragma mark - Callback
- (void)pageControlValueChanged:(NSInteger)interger
{
    UIPageViewControllerNavigationDirection direction = interger > self.intSelected ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.pages[interger-100]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
    [self refreshSelectedButton:interger];
}

- (void)refreshSelectedButton:(NSInteger)integer{
    self.intSelected = integer;
    for (int i = 100; i<103; i++) {
        UIButton *btn = (UIButton *)[self.viHeader viewWithTag:i];
        if (integer == i) {
            [btn setSelected:YES];
        }else{
            [btn setSelected:NO];
        }
    }
    [self refreshPreForLblLine:(integer-100)*SCREEN_WIDTH/5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButtonTypeSelect:(UIButton *)sender {
    [self pageControlValueChanged:sender.tag];
}
- (IBAction)clickButtonAll:(UIButton *)sender {
    [self.btnAll setSelected:YES];
    [self.btnReady setSelected:NO];
    [self.btnSendOut setSelected:NO];
    [self refreshPreForLblLine:CGRectGetMinX(self.btnAll.frame)];
}
- (IBAction)clickButtonReady:(UIButton *)sender {
    [self.btnAll setSelected:NO];
    [self.btnReady setSelected:YES];
    [self.btnSendOut setSelected:NO];
    [self refreshPreForLblLine:CGRectGetMinX(self.btnReady.frame)];
}
- (IBAction)clickButtonSendOut:(UIButton *)sender {
    [self.btnAll setSelected:NO];
    [self.btnReady setSelected:NO];
    [self.btnSendOut setSelected:YES];
    [self refreshPreForLblLine:CGRectGetMinX(self.btnSendOut.frame)];
}
- (void)refreshPreForLblLine:(CGFloat)floatMinX{
    [UIView animateWithDuration:0.27 animations:^{
        self.layoutConstraintPre.constant = floatMinX;
        [self.view layoutIfNeeded];
    }];
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

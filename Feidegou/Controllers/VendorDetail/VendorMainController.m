//
//  VendorMainController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorMainController.h"
#import "ButtonUpDown.h"
#import "VendorMainGoodController.h"
#import "VendorMainShopController.h"
#import "StarView.h"
#import "CLCellUpImgLbl.h"
#import "CellTypeMore.h"

@interface VendorMainController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet ButtonUpDown *btnMain;
@property (weak, nonatomic) IBOutlet ButtonUpDown *btnNear;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;
//@property (strong, nonatomic) UITextField *txtSearch;


@property (weak, nonatomic) IBOutlet UIView *viContainer;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *pages;
@property (assign, nonatomic) NSInteger intSelected;

@end

@implementation VendorMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblLine setBackgroundColor:ColorLine];
    [self.btnMain setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnMain setTitleColor:ColorRed forState:UIControlStateSelected];
    [self.btnNear setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnNear setTitleColor:ColorRed forState:UIControlStateSelected];
    [self setLayout];
//
//    self.navigationItem.rightBarButtonItem = searchButton;
    
//    self.txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 30)];
//    [self.txtSearch setClipsToBounds:YES];
//    [self.txtSearch.layer setCornerRadius:3.0];
//    [self.txtSearch setPlaceholder:@"搜索商品名称"];
//    [self.txtSearch setBackgroundColor:ColorFromRGB(238, 242, 243)];
//    [self.txtSearch setTextColor:ColorGaryDark];
//    self.navigationItem.titleView = self.txtSearch;
//    [self.navigationItem.titleView setFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 40)];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 40, 44)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    barButton.width = 40;
    self.navigationItem.rightBarButtonItem = barButton;
    
    
//    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 35)];
//    
//    [titleView setBackgroundColor:[UIColor clearColor]];
//    
//    
//    UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH-100, 35.0f)];
////    searchbar.delegate = self;
//    
//    //    [searchbar setTintColor:[UIColor redColor]];
//    
//    [searchbar setPlaceholder:@"搜索吃喝玩乐"];
//    [searchbar setBackgroundColor:ColorFromRGB(241, 241, 246)];
//    [searchbar.layer setBorderWidth:1];
//    [searchbar.layer setBorderColor:ColorFromRGB(241, 241, 246).CGColor];  //设置边框为白色
//    [titleView addSubview:searchbar];
//    
//    
//    self.navigationItem.titleView = titleView;
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScorviewEditing:)];
//    [tapGestureRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

//- (void)clickScorviewEditing:(UITapGestureRecognizer *)sender {
//    [self.navigationItem.titleView endEditing:YES];
//}
- (void)setLayout{
    /**
     *100代表商品，101代表附近商家
     */
    self.intSelected = 100;
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< 2; i++) {
        if (i == 0) {
            VendorMainGoodController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"VendorMainGoodController"];
            [self.pages addObject:controller];
        }else{
            VendorMainShopController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"VendorMainShopController"];
            [self.pages addObject:controller];
        }
    }
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viContainer.frame.size.width, self.viContainer.frame.size.height);
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.viContainer addSubview:self.pageViewController.view];
    if ([self.pages count]>0) {
        [self pageControlValueChanged:self.intSelected];
    }
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
    if (integer == 100) {
        [self.btnMain setSelected:YES];
        [self.btnNear setSelected:NO];
        self.title = @"商家首页";
    }else{
        [self.btnMain setSelected:NO];
        [self.btnNear setSelected:YES];
        self.title = @"附近商家";
    }
}
- (IBAction)clickButtonMain:(ButtonUpDown *)sender {
    if (!sender.selected) {
        [self pageControlValueChanged:100];
    }
}
- (IBAction)clickButtonNear:(ButtonUpDown *)sender {
    if (!sender.selected) {
        [self pageControlValueChanged:101];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    D_NSLog(@"name is %@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[touch.view isKindOfClass:[StarView class]]||[touch.view isKindOfClass:[CellTypeMore class]]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

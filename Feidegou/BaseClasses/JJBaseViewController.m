//
//  JJBaseViewController.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/15.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
#import "LoginViewController.h"

@interface JJBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *exceptionView;
@property (nonatomic,strong) UIImageView *imgFailed;
@property (nonatomic,strong) UILabel *lblTip;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,assign) NSInteger integerHead;

@end

@implementation JJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ColorBackground];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *imgHeader = [UIImage imageWithColor:ColorHeader];
    [self.navigationController.navigationBar setBackgroundImage:imgHeader forBarMetrics:UIBarMetricsDefault];
//    设置导航栏返回样式
    if (self.navigationController.viewControllers.count>1) {
        self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnBack setFrame:CGRectMake(0, 0, 40, 44)];
        [self.btnBack.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.btnBack addTarget:self action:@selector(clickButtonBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBack setImage:ImageNamed(@"img_back") forState:UIControlStateNormal];
        [self.btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack];
        barButton.width = 40;
        self.navigationItem.leftBarButtonItem = barButton;
    }
    [self locationControls];
    [self initData];
    [self populateData];
    // Do any additional setup after loading the view.
}
- (void)clickButtonBack:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    侧滑返回
    if (self.navigationController.viewControllers.count>1) {
//        右滑返回代理
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    D_NSLog(@"进入----------------------------cName is %@",self.class);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.tabBarItem.title, nil];
    D_NSLog(@"cName is %@",cName);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.tabBarItem.title, nil];
    D_NSLog(@"cName is %@",cName);
}
//添加控件
- (void)locationControls{
    
}
//初始化数据源
- (void)initData{
    
}
//添加数据
- (void)populateData{
    
}
- (void)dealloc{
    [self.disposable dispose];
    self.disposable = nil;
    D_NSLog(@"%@",NSStringFromClass([self class]));
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -正在加载
-(void)showExceptionNoHead{
    self.integerHead = 64;
    [self showException];
}
-(void)showException{
    
    if (!self.exceptionView) {
        [self initException];
    }else{
        [self.imgFailed removeFromSuperview];
        [self.exceptionView setHidden:NO];
    }
    [self.view bringSubviewToFront:self.exceptionView];
}
-(void)hideException{
    if (self.exceptionView) {
        [self.exceptionView setHidden:YES];
    }
}
- (void)initException{
    self.exceptionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.integerHead, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.integerHead)];
    [self.exceptionView setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [self.view addSubview:self.exceptionView];
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [self.activity setCenter:CGPointMake(self.exceptionView.center.x, self.exceptionView.center.y-50)];//指定进度轮中心点
    
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self.activity startAnimating];
    [self.exceptionView addSubview:self.activity];
    
    self.lblTip = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.activity.frame)+10, CGRectGetWidth(self.exceptionView.frame), 20)];
    [self.lblTip setTextColor:ColorFromRGB(32, 32, 32)];
    [self.lblTip setText:@"正在加载中..."];
    [self.lblTip setTextAlignment:NSTextAlignmentCenter];
    [self.lblTip setFont:[UIFont systemFontOfSize:14.0]];
    [self.exceptionView addSubview:self.lblTip];
    
}
-(void)failedRequestException:(enumException)exception{
    [self.lblTip setHidden:YES];
    [self.activity stopAnimating];
    UIImageView *imgError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    [imgError setCenter:CGPointMake(self.view.center.x, self.view.center.y-50)];
    [imgError setContentMode:UIViewContentModeScaleAspectFit];
    [imgError setImage:ImageNamed(@"img_error")];
    [self.exceptionView addSubview:imgError];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}
- (void)pushLoginAlert{
    JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
    [alertView showAlertView:self andTitle:nil andMessage:@"您当前没有登录，是否登录"  andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即登录" andConfirm:^{
        D_NSLog(@"点击了登录");
        [self pushLoginController];
    } andCancel:^{
        D_NSLog(@"点击了取消");
    }];
}
- (void)pushLoginController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

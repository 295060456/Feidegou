//
//  TestVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "TestVC.h"

@interface TestVC ()

@property(nonatomic,strong)TestView *testView;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation TestVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    TestVC *vc = TestVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kOrangeColor;
    self.gk_navTitle = @"控制器001";
    
    self.view.backgroundColor    = [UIColor whiteColor];
    self.gk_navBackgroundColor   = [UIColor orangeColor];
    self.gk_statusBarStyle       = UIStatusBarStyleLightContent;
    self.gk_backStyle            = GKNavigationBarBackStyleWhite;
    self.gk_navLineHidden        = YES;
    
    self.gk_navItemRightSpace       = 12.0f;
    self.gk_navItemLeftSpace        = 16.0f;
    
    self.gk_navTitleFont    = [UIFont systemFontOfSize:18];
    self.gk_navTitleColor   = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.pet hide];
//    [self.pet.laAnimation removeFromSuperview];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES
//                             completion:nil];
//}

#pragma mark —— lazyLoad

-(TestView *)testView{
    if (!_testView) {
        _testView = TestView.new;
        _testView.backgroundColor = kRedColor;
        [_testView becomeFirstResponder];
        [self.view addSubview:_testView];
        _testView.frame = CGRectMake(100,
                                     100,
                                     100,
                                     100);
    }return _testView;
}

@end

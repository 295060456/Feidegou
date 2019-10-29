//
//  TestVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "TestVC.h"

@interface TestVC ()

@property(nonatomic,strong)Q_Pet *pet;
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
    self.testView.alpha = 1;
//    self.pet.alpha = 1;
//    [self.pet becomeFirstResponder];
    
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
-(Q_Pet *)pet{
    if (!_pet) {
        _pet = [[Q_Pet alloc]initWithFrame:CGRectMake(100,
                                                      100,
                                                      100,
                                                      100)];
//        _pet.autoCloseEdge = YES;
//        [_pet show];
        [_pet becomeFirstResponder];
    }return _pet;
}

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

//
//  RegisterSucceedController.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "RegisterSucceedController.h"
#import "LoginViewController.h"

@interface RegisterSucceedController ()

@property (weak, nonatomic) IBOutlet UIButton *btnTip;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation RegisterSucceedController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForgetPsw) {
        [self setTitle:@"找回密码"];
        [self.btnTip setTitle:@"恭喜您找回成功" forState:UIControlStateNormal];
    }else{
        [self.btnTip setTitle:@"恭喜您注册成功" forState:UIControlStateNormal];
    }
    [self.btnTip.layer setBorderWidth:0.5];
    [self.btnTip.layer setBorderColor:ColorRed.CGColor];
    [self.btnLogin setTitleColor:ColorRed forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (IBAction)clickButtonLogin:(UIButton *)sender {
    NSArray *array = self.navigationController.viewControllers;
    for (int i = 0; i<array.count; i++) {
        UIViewController *controller = array[i];
        if ([controller isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


@end

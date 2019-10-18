//
//  LoginViewController.m
//  guanggaobao
//
//  Created by 谭自强 on 15/11/19.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "LoginViewController.h"
#import "JJHttpClient+Login.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "UITextFieldPassWord.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextFieldPassWord *txtPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.btnRegister setTitleColor:ColorGary
                           forState:UIControlStateNormal];
    [self.btnForgetPsw setTitleColor:ColorGary
                            forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:ColorGary
                        forState:UIControlStateNormal];
    [self.btnLogin setBackgroundColor:ColorGaryButtom];
    [self.txtUserName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.txtUserName addTarget:self
                         action:@selector(textFiledDidChanged:)
               forControlEvents:UIControlEventEditingChanged];
    [self.txtPsw addTarget:self
                    action:@selector(textFiledDidChanged:)
          forControlEvents:UIControlEventEditingChanged];
}
- (void)textFiledDidChanged:(UITextField *)text{
    NSString *strUserNum = self.txtUserName.text;
    NSString *strPsw = self.txtPsw.text;
    if (![NSString isNullString:strUserNum] && ![NSString isNullString:strPsw]) {
        [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:ColorRed];
    }else{
        [self.btnLogin setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:ColorGaryButtom];
    }
}

- (IBAction)clickButtonLogin:(UIButton *)sender {
    NSString *strUserNum = self.txtUserName.text;
    NSString *strPsw = self.txtPsw.text;
    if ([NSString isNullString:strUserNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (![NSString isUser:strUserNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名"];
        return;
    }
    if ([NSString isNullString:strPsw]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (strPsw.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    __weak LoginViewController *myself = self;
    self.disposable = [[[JJHttpClient new] requestLoginUSERNAME:strUserNum
                                                    andPASSWORD:strPsw
                                                andIsChangedPsw:NO]
                       subscribeNext:^(ModelLogin*model) {
        if (model) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setAlias];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [myself.navigationController popViewControllerAnimated:YES];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}

- (IBAction)clickButtonReg:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister
                                                         bundle:nil];
    RegisterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

- (IBAction)clickButtonForgetPsw:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
    RegisterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    controller.isForgetPsw = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}


@end

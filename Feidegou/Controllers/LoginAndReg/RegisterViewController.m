//
//  RegisterViewController.m
//  guanggaobao
//
//  Created by 谭自强 on 15/11/19.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterCodeController.h"
#import "JJHttpClient+Login.h"
#import "RegisterInviterController.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UIView *viPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) NSString *strPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnDelegete;
@property (weak, nonatomic) IBOutlet UIButton *btnUrl;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    if (self.isForgetPsw) {
        [self setTitle:@"找回密码"];
    }
    [self.btnDelegete setHidden:self.isForgetPsw];
    [self.btnUrl setHidden:self.isForgetPsw];
    [self.txtPhoneNum setPlaceholder:@"请输入手机号码"];
    [self refrehButtonNextState];
    [self.viPhone.layer setBorderWidth:0.5];
    [self.viPhone.layer setBorderColor:ColorLine.CGColor];
    [self.txtPhoneNum setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.txtPhoneNum addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFiledDidChanged:(UITextField *)text{
    [self refrehButtonNextState];
}
- (void)refrehButtonNextState{
    NSString *strUserNum = self.txtPhoneNum.text;
    if (strUserNum.length>6&&self.btnDelegete.selected) {
        [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnRegister setBackgroundColor:ColorRed];
    }else{
        [self.btnRegister setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnRegister setBackgroundColor:ColorGaryButtom];
    }
}

- (IBAction)clickButtonNext:(UIButton *)sender {
    if (self.isForgetPsw) {
        NSString *strUserNum = self.txtPhoneNum.text;
        if ([NSString isNullString:strUserNum]) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
            return;
        }
        if (![NSString isPhone:strUserNum]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据,请稍后..."];
        
        NSString *strType = @"reg";
        if (self.isForgetPsw) {
            strType = @"forget";
        }
        __weak RegisterViewController *myself = self;
        self.disposable = [[[JJHttpClient new] requestPswGetBackPHONE:strUserNum andType:strType] subscribeNext:^(NSDictionary*dictionary) {
            D_NSLog(@"msg is %@",dictionary[@"msg"]);
            [SVProgressHUD dismiss];
            if ([dictionary[@"code"] intValue]==1) {
                RegisterCodeController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterCodeController"];
                controller.strPhone = strUserNum;
                controller.isForgetPsw = self.isForgetPsw;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringStandard:dictionary[@"msg"]]];
            }
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
        
        
        return;
    }
    NSString *strUserNum = self.txtPhoneNum.text;
    if ([NSString isNullString:strUserNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (![NSString isUser:strUserNum]) {
        [SVProgressHUD showErrorWithStatus:@"用户名由6到16位的数字和字母组成"];
        return;
    }
    if (!self.btnDelegete.selected) {
        [SVProgressHUD showErrorWithStatus:@"请同意注册协议"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在请求数据,请稍后..."];
    __weak RegisterViewController *myself = self;
    self.disposable = [[[JJHttpClient new] requestIsRegisterPHONE:strUserNum] subscribeNext:^(NSDictionary*dictionary) {
        D_NSLog(@"msg is %@",dictionary[@"msg"]);
        [SVProgressHUD dismiss];
        if ([dictionary[@"code"] intValue]==1) {
            RegisterCodeController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterCodeController"];
            controller.strPhone = strUserNum;
            controller.isForgetPsw = self.isForgetPsw;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringStandard:dictionary[@"msg"]]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
- (IBAction)clickButtonDelegete:(UIButton *)sender {
    if (sender.selected) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    [self refrehButtonNextState];
}
- (IBAction)clickButtonDelegeteDetail:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
    WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
    [controller setTitle:@"用户注册协议"];
    controller.strWebUrl = @"http://feidegou.com/doc_agree.htm";
    [self.navigationController pushViewController:controller animated:YES];
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

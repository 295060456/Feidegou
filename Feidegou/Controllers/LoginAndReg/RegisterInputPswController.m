//
//  RegisterInputPswController.m
//  guanggaobao
//
//  Created by 谭自强 on 15/11/19.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "RegisterInputPswController.h"
#import "JJHttpClient+Login.h"
#import "RegisterSucceedController.h"

@interface RegisterInputPswController ()
@property (weak, nonatomic) IBOutlet UIView *viPswOld;
@property (weak, nonatomic) IBOutlet UITextField *txtPswOld;
@property (weak, nonatomic) IBOutlet UIView *viPsw;
@property (weak, nonatomic) IBOutlet UITextField *txtPsw;
@property (weak, nonatomic) IBOutlet UIView *viCode;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation RegisterInputPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForgetPsw) {
        [self setTitle:@"找回密码"];
        self.layoutCodeHeight.constant = 0;
        [self.viCode setHidden:YES];
        [self.txtCode setHidden:YES];
    }else{
        self.layoutCodeHeight.constant = 40;
        [self.viCode setHidden:NO];
        [self.txtCode setHidden:NO];
    }
    [self refrehButtonNextState];
    [self.txtPsw addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFiledDidChanged:(UITextField *)text{
    [self refrehButtonNextState];
}
- (void)refrehButtonNextState{
    NSString *strPsw = self.txtPsw.text;
    if ([NSString isPassword:strPsw]&&![NSString isNullString:strPsw]) {
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorRed];
    }else{
        [self.btnNext setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorGaryButtom];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonCommit:(UIButton *)sender {
    @weakify(self)
    [self.view endEditing:YES];
    NSString *strPswOld = self.txtPswOld.text;
    NSString *strPsw = self.txtPsw.text;
    if ([NSString isNullString:strPsw] ||
        [NSString isNullString:strPswOld]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (![NSString isPassword:strPsw]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的格式"];
        return;
    }
    
    if (![TransformString(strPswOld) isEqualToString:TransformString(strPsw)]) {
        [SVProgressHUD showErrorWithStatus:@"请输入相同的密码"];
        return;
    }
    if (self.isForgetPsw) {//忘记密码走这里
        [SVProgressHUD showWithStatus:@"正在修改密码,请稍后..."];
        self.disposable = [[JJHttpClient.new requestPswGetBackPHONE:self.strPhone
                                                    andpassword_new:strPsw]
                           subscribeNext:^(NSDictionary *dictionary) {
            D_NSLog(@"msg is %@",dictionary[@"msg"]);
            @strongify(self)
            if ([dictionary[@"code"] intValue] == 1) {
                [SVProgressHUD dismiss];
                RegisterSucceedController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterSucceedController"];
                controller.isForgetPsw = self.isForgetPsw;
                controller.strPhone = self.strPhone;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringStandard:dictionary[@"msg"]]];
            }
        }error:^(NSError *error) {
            @strongify(self)
            self.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            @strongify(self)
            self.disposable = nil;
        }];return;
    }else{//注册走这里
        if (![NSString isNumber:self.txtCode.text]){
            if (self.txtCode.text.length >= 6 &&
                self.txtCode.text.length <= 15) {
                self.disposable = [[[JJHttpClient new] requestRegisterPHONE:self.strPhone
                                                                andPASSWORD:strPsw
                                                              andinviter_id:[NSString stringStandard:self.txtCode.text]]
                                   subscribeNext:^(NSDictionary*dictionary) {
                    D_NSLog(@"msg is %@",dictionary[@"msg"]);
                    @strongify(self)
                    if ([dictionary[@"code"] intValue] == 1) {
                        [SVProgressHUD dismiss];
                        RegisterSucceedController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterSucceedController"];
                        controller.isForgetPsw = self.isForgetPsw;
                        controller.strPhone = self.strPhone;
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        [SVProgressHUD showErrorWithStatus:[NSString stringStandard:dictionary[@"msg"]]];
                    }
                }error:^(NSError *error) {
                    @strongify(self)
                    self.disposable = nil;
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }completed:^{
                    @strongify(self)
                    self.disposable = nil;
                }];

            }else{
                Toast(@"昵称请设置6～15位");
            }
        }else{
            Toast(@"昵称不能为纯数字");
            return;
        }
    }
    [SVProgressHUD showWithStatus:@"正在注册,请稍后..."];
}

@end

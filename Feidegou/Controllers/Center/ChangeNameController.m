//
//  ChangeNameController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/3/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ChangeNameController.h"
#import "JJHttpClient+FourZero.h"
#import "JJDBHelper+Center.h"

@interface ChangeNameController ()

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

@end

@implementation ChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblTip setTextColor:ColorGary];
    [self.btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCommit setBackgroundColor:ColorHeader];
    ModelInfo *model = [[JJDBHelper sharedInstance]  fetchPersonalInfo];
    if (self.personalInfo == enum_personalInfo_phone) {
        [self setTitle:@"修改手机号码"];
        [self.lblTip setHidden:NO];
        [self.lblTip setText:@"请输入正确的手机号码,填写后不可更改,如果修改请联系客服"];
        [self.txtName setPlaceholder:@"请输入您的手机号码"];
        [self.btnCommit setTitle:@"保存" forState:UIControlStateNormal];
    }
    if (self.personalInfo == enum_personalInfo_email) {
        [self setTitle:@"修改邮箱"];
        [self.lblTip setHidden:YES];
        [self.txtName setPlaceholder:@"请输入您的邮箱"];
        [self.txtName setText:model.email];
    }
    if (self.personalInfo == enum_personalInfo_chongzhi) {
        [self setTitle:@"积分充值"];
        [self.lblTip setHidden:YES];
        [self.lblTip setText:@""];
        [self.txtName setPlaceholder:@"请输入充值密码"];
        [self.btnCommit setTitle:@"确认充值" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}
- (IBAction)clickButtonCommit:(UIButton *)sender {
    [self.view endEditing:YES];
    ModelInfo *model = [[JJDBHelper sharedInstance]  fetchPersonalInfo];
    if (self.personalInfo == enum_personalInfo_phone) {
        NSString *strPhone = self.txtName.text;
        if ([NSString isNullString:strPhone]) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"];
            return;
        }
        if (![NSString isPhone:strPhone]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
        __weak ChangeNameController *myself = self;
        self.disposable = [[[JJHttpClient new] requestFourZeroChangeInfoUserName:[NSString stringStandard:model.userName]
                                                                    andtelePhone:strPhone
                                                                      andarea_id:@""
                                                                          andsex:@""
                                                                     andbirthday:@""
                                                                        andemail:@""]
                           subscribeNext:^(NSDictionary*dictionry) {
            if ([dictionry[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                model.mobile = strPhone;
                [[JJDBHelper sharedInstance] savePersonalInfo:model];
                [myself.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
            }
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
        
        
    }else if (self.personalInfo == enum_personalInfo_email){
        NSString *strEmail = self.txtName.text;
        if ([NSString isNullString:strEmail]) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的邮箱"];
            return;
        }
        if (![NSString isEmail:strEmail]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱"];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
        __weak ChangeNameController *myself = self;
        self.disposable = [[[JJHttpClient new] requestFourZeroChangeInfoUserName:[NSString stringStandard:model.userName]
                                                                    andtelePhone:@""
                                                                      andarea_id:@""
                                                                          andsex:@""
                                                                     andbirthday:@""
                                                                        andemail:strEmail]
                           subscribeNext:^(NSDictionary*dictionry) {
            if ([dictionry[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                model.email = strEmail;
                [[JJDBHelper sharedInstance] savePersonalInfo:model];
                [myself.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
            }
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
    }else if (self.personalInfo == enum_personalInfo_chongzhi){
        NSString *strEmail = self.txtName.text;
        if ([NSString isNullString:strEmail]) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的充值密码"];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
        __weak ChangeNameController *myself = self;
        self.disposable = [[[JJHttpClient new] requestFourZeroAddInteger:[NSString stringStandard:strEmail]]
                           subscribeNext:^(NSDictionary*dictionry) {
            if ([dictionry[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                [myself.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
            }
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

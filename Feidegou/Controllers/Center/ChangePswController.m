//
//  ChangePswController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/7/5.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ChangePswController.h"
#import "JJHttpClient+FourZero.h"

@interface ChangePswController ()
@property (weak, nonatomic) IBOutlet UITextView *txtPswOld;
@property (weak, nonatomic) IBOutlet UITextField *txtPswNew;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UIView *viPswOld;
@property (weak, nonatomic) IBOutlet UIView *viPswNew;

@end

@implementation ChangePswController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnCommit setBackgroundColor:ColorLine];
    [self.viPswNew.layer setBorderWidth:0.5];
    [self.viPswNew.layer setBorderColor:ColorLine.CGColor];
    [self.viPswOld.layer setBorderWidth:0.5];
    [self.viPswOld.layer setBorderColor:ColorLine.CGColor];
    [self.txtPswNew addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
}
- (void)textFiledDidChanged:(UITextField *)text{
    NSString *strPswNew = self.txtPswNew.text;
    if (![NSString isPassword:strPswNew]) {
        [self.btnCommit setBackgroundColor:ColorLine];
    }else{
        [self.btnCommit setBackgroundColor:ColorRed];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonCommit:(UIButton *)sender {
    NSString *strPswOld = self.txtPswOld.text;
    NSString *strPswNew = self.txtPswNew.text;
    if ([NSString isNullString:strPswOld]) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if ([NSString isNullString:strPswNew]) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (![NSString isPassword:strPswNew]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
        return;
    }
    [self.view endEditing:YES];
    ModelLogin *model = [[PersonalInfo sharedInstance]  fetchLoginUserInfo];
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak ChangePswController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroChangePswUserName:[NSString stringStandard:model.userName] andpassword_new:strPswNew andpassword_old:strPswOld] subscribeNext:^(NSDictionary*dictionry) {
        if ([dictionry[@"code"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:dictionry[@"msg"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

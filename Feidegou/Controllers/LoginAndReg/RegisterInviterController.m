//
//  RegisterInviterController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/20.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "RegisterInviterController.h"
#import "JJHttpClient+Login.h"
#import "RegisterInputPswController.h"

@interface RegisterInviterController ()

@property (weak, nonatomic) IBOutlet UIView *viCode;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIButton *btnService;

@end

@implementation RegisterInviterController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)locationControls{
    [self refrehButtonNextState];
    [self.lblTip setTextColor:ColorGary];
    [self.btnService setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.viCode.layer setBorderWidth:0.5];
    [self.viCode.layer setBorderColor:ColorLine.CGColor];
    [self.txtCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.txtCode addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFiledDidChanged:(UITextField *)text{
    [self refrehButtonNextState];
}

- (void)refrehButtonNextState{
    NSString *strUserNum = self.txtCode.text;
    if ([NSString isNullString:strUserNum]) {
        [self.btnNext setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorGaryButtom];
    }else{
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorRed];
    }
}

- (IBAction)clickButtonNext:(UIButton *)sender {
    NSString *strCode = self.txtCode.text;
    if ([NSString isNullString:strCode]) {
        [SVProgressHUD showErrorWithStatus:@"请输邀请码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在请求数据,请稍后..."];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestIsRegisterinviterCode:strCode] subscribeNext:^(NSDictionary*dictionary) {
        @strongify(self)
        D_NSLog(@"msg is %@",dictionary[@"msg"]);
        [SVProgressHUD dismiss];
        if ([dictionary[@"code"] intValue] == 1) {
            RegisterInputPswController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterInputPswController"];
            controller.strPhone = self.strPhone;
            controller.strCode = strCode;
            controller.isForgetPsw = self.isForgetPsw;
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
}

- (IBAction)clickButtonService:(UIButton *)sender {
    [JJAlertViewTwoButton.new showAlertView:self
                                   andTitle:nil
                                 andMessage:@"是否拨打电话"
                                  andCancel:@"取消"
                              andCanelIsRed:NO
                              andOherButton:@"立即拨打"
                                 andConfirm:^{
        D_NSLog(@"点击了确定");
        Tel(ServicePhone);
    } andCancel:^{
        D_NSLog(@"点击了取消");
    }];
}

@end

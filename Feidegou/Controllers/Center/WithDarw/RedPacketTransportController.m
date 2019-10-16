//
//  RedPacketTransportController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/28.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "RedPacketTransportController.h"
#import "UITextField+EditChanged.h"
#import "JJHttpClient+FourZero.h"

@interface RedPacketTransportController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirlm;

@end

@implementation RedPacketTransportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtUser handleTextFieldControlEvent:UIControlEventEditingChanged withBlock:^{
        [self textFieldChanged];
    }];
    [self.txtMoney handleTextFieldControlEvent:UIControlEventEditingChanged withBlock:^{
        [self.lblMoney setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.txtMoney.text])];
        [self textFieldChanged];
    }];
    // Do any additional setup after loading the view.
}

- (void)textFieldChanged{
    if ([NSString isNullString:self.txtUser.text]||[NSString isNullString:self.txtMoney.text]) {
        [self.btnComfirlm setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnComfirlm setBackgroundColor:ColorGaryButtom];
    }else{
        [self.btnComfirlm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnComfirlm setBackgroundColor:ColorRed];
    }
}

- (IBAction)clcikButtonComfilrm:(UIButton *)sender {
    NSString *strUserNum = self.txtUser.text;
    NSString *strMoney = self.txtMoney.text;
    if ([NSString isNullString:strUserNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入对方用户名"];
        return;
    }
    if ([NSString isNullString:strMoney]) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    if ([strMoney doubleValue]>100000) {
        [SVProgressHUD showErrorWithStatus:@"转账金额一次性不能大于100000"];
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeBlack];
    __weak RedPacketTransportController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroRedPacketTransportuserId:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] andaccounts:strUserNum andredbag:strMoney] subscribeNext:^(NSDictionary*dictionray) {
        if ([dictionray[@"code"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"转账成功"];
            [myself.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionray[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}


@end

//
//  RegisterCodeController.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "RegisterCodeController.h"
#import "RegisterInputPswController.h"
#import "JJHttpClient+Login.h"

@interface RegisterCodeController ()
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblPhone;
@property (weak, nonatomic) IBOutlet UIView *viCode;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int intTime;

@end

@implementation RegisterCodeController
- (void)clickButtonBack:(UIButton *)sender{
    [self removeTimer];
    [super clickButtonBack:sender];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForgetPsw) {
        [self setTitle:@"找回密码"];
    }
    [self.btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCode setTitleColor:ColorGary forState:UIControlStateSelected];
    [self.btnCode setBackgroundColor:ColorGaryButtom];
    [self.lblPhone setText:StringFormat(@"请输入%@收到的短信验证码:",self.strPhone)];
    [self.viCode.layer setBorderWidth:0.5];
    [self.viCode.layer setBorderColor:ColorLine.CGColor];
    [self.txtCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.txtCode addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addTimer];
    if (!self.isForgetPsw) {
        [self requesetCode];
    }
}
- (void)textFiledDidChanged:(UITextField *)text{
    [self refrehButtonNextState];
}
- (void)refrehButtonNextState{
    NSString *strUserNum = self.txtCode.text;
    if (![NSString isNullString:strUserNum]) {
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorRed];
    }else{
        [self.btnNext setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnNext setBackgroundColor:ColorGaryButtom];
    }
}
- (IBAction)clickButtonCode:(UIButton *)sender {
    if (self.btnCode.selected) {
        return;
    }
    [self requesetCode];
}
- (IBAction)clickButtonNext:(UIButton *)sender {
    
    NSString *strCode = self.txtCode.text;
    
    if ([NSString isNullString:strCode]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在请求数据,请稍后..."];
    
    __weak RegisterCodeController *myself = self;
    self.disposable = [[[JJHttpClient new] requestPswGetBackPHONE:self.strPhone andCODE:strCode] subscribeNext:^(NSDictionary*dictionary) {
        D_NSLog(@"msg is %@,sendType is %@",dictionary[@"msg"],dictionary[@"sendType"]);
        if ([dictionary[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            RegisterInputPswController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RegisterInputPswController"];
            controller.strCode = strCode;
            controller.strPhone = self.strPhone;
            controller.isForgetPsw = self.isForgetPsw;
            [self.navigationController pushViewController:controller animated:YES];
            [myself removeTimer];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
            [self removeTimer];
        }
        
        
    }error:^(NSError *error) {
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
    
    
}
- (IBAction)clickButtonCall:(UIButton *)sender {
    JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
    [alertView showAlertView:self andTitle:nil andMessage:@"是否拨打电话" andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即拨打" andConfirm:^{
        D_NSLog(@"点击了确定");
        Tel(ServicePhone);
    } andCancel:^{
        D_NSLog(@"点击了取消");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerCountDown:(NSTimer *)timer{
    D_NSLog(@"timerCountDown");
    if (self.intTime <= 1) {
        [self removeTimer];
    }else{
        self.intTime--;
        NSString *strTip = [NSString stringWithFormat:@"重新发送(%d)",self.intTime];
        [self.btnCode setTitle:strTip forState:UIControlStateNormal];
        [self.btnCode setTitle:strTip forState:UIControlStateSelected];
    }
}
/**
 *添加计时器
 */
- (void)addTimer{
    [self removeTimer];
    [self.btnCode setBackgroundColor:ColorGaryButtom];
    self.intTime = 60;
    NSString *strTip = [NSString stringWithFormat:@"重新发送(%d)",self.intTime];
    [self.btnCode setTitle:strTip forState:UIControlStateNormal];
    [self.btnCode setTitle:strTip forState:UIControlStateSelected];
    [self.btnCode setSelected:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
    //将timer添加到RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
/**
 *移除计时器
 */
- (void)removeTimer{
    [self.btnCode setBackgroundColor:ColorRed];
    [self.btnCode setSelected:NO];
    [self.btnCode setTitle:@"重新获取" forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)requesetCode{
    [self addTimer];
    NSString *strType = @"reg";
    if (self.isForgetPsw) {
        strType = @"forget";
    }
    __weak RegisterCodeController *myself = self;
    self.disposable = [[[JJHttpClient new] requestPswGetBackPHONE:self.strPhone andType:strType] subscribeNext:^(NSDictionary*dictionary) {
        D_NSLog(@"msg is %@",dictionary[@"msg"]);
    }error:^(NSError *error) {
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

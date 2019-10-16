//
//  InputApliayController.m
//  guanggaobao
//
//  Created by 谭自强 on 15/12/15.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "InputApliayController.h"
#import "JJDBHelper+Center.h"
#import "JJHttpClient+FourZero.h"

@interface InputApliayController ()

@property (weak, nonatomic) IBOutlet UITextField *txtApliyAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtApliyName;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (nonatomic,strong) ModelCenter *model;

@end

@implementation InputApliayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnCommit setBackgroundColor:ColorRed];
    self.model = [[JJDBHelper sharedInstance] fetchCenterMsg];
    [self.txtApliyName setText:self.model.alipayName];
    [self.txtApliyAccount setText:self.model.alipay];
    // Do any additional setup after loading the view.
}

- (IBAction)clickButtonCommit:(UIButton *)sender {
    NSString *strName = self.txtApliyName.text;
    if ([NSString isNullString:strName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入支付宝姓名"];
        return;
    }
    NSString *strAccount = self.txtApliyAccount.text;
    if ([NSString isNullString:strAccount]) {
        [SVProgressHUD showErrorWithStatus:@"请输入支付宝账号"];
        return;
    }
    
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak InputApliayController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroChangeAlipy:strAccount andalipayName:strName] subscribeNext:^(NSDictionary*dictionry) {
        if ([dictionry[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            myself.model.alipayName = strName;
            myself.model.alipay = strAccount;
            [[JJDBHelper sharedInstance] saveCenterMsg:self.model];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

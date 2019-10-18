//
//  BillSelectedController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/22.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "BillSelectedController.h"

@interface BillSelectedController ()

@property (weak, nonatomic) IBOutlet UIView *viTxt;
@property (weak, nonatomic) IBOutlet UITextField *txtCompnyName;
@property (weak, nonatomic) IBOutlet UIButton *btnConfilm;
@property (weak, nonatomic) IBOutlet UIButton *btnPersonal;
@property (weak, nonatomic) IBOutlet UIButton *btnCompny;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (assign, nonatomic) enumBillType billType;

@end

@implementation BillSelectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.txtCompnyName setBackgroundColor:ColorBackground];
    [self.btnConfilm setBackgroundColor:ColorHeader];
    self.billType = self.model.billType;
    [self.txtCompnyName setText:self.model.strCompanyName];
    [self refreshView];
}

- (void)refreshView{
    if (self.billType == enum_billType_personal) {
        [self.btnPersonal setSelected:YES];
        [self.btnCompny setSelected:NO];
        [self.btnNo setSelected:NO];
        [self.viTxt setHidden:YES];
    }else if (self.billType == enum_billType_company) {
        [self.btnPersonal setSelected:NO];
        [self.btnCompny setSelected:YES];
        [self.btnNo setSelected:NO];
        [self.viTxt setHidden:NO];
    }else{
        [self.btnPersonal setSelected:NO];
        [self.btnCompny setSelected:NO];
        [self.btnNo setSelected:YES];
        [self.viTxt setHidden:YES];
    }
}
 
- (IBAction)clickButtonSelectedType:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag == 100) {
        self.billType = enum_billType_personal;
    }else if (sender.tag == 101) {
        self.billType = enum_billType_company;
    }else{
        self.billType = enum_billType_no;
    }
    [self refreshView];
}

- (IBAction)clickButtonConfilm:(UIButton *)sender {
    if (self.billType == enum_billType_company) {
        NSString *strCompnyName = self.txtCompnyName.text;
        if ([NSString isNullString:strCompnyName]) {
            [SVProgressHUD showErrorWithStatus:@"请填写单位名称"];
            return;
        }
        self.model.strCompanyName = self.txtCompnyName.text;
    }else{
        self.model.strCompanyName = @"";
    }
    self.model.billType = self.billType;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

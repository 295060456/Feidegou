//
//  VendorPayTheBillController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/19.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorPayTheBillController.h"
#import "JJHttpClient+FourZero.h"
#import "PayMonyForGoodController.h"

@interface VendorPayTheBillController ()

@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnPrice;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblTip;

@end

@implementation VendorPayTheBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.store_name;
    [self.txtPrice addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self textFieldChange:self.txtPrice];
    
    if ([self.strTip floatValue]>0) {
        NSString *strDiscount = TransformString(self.strTip);
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"线下买单送%@%%积分",strDiscount)];
        [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(5, strDiscount.length+1)];
        [self.lblTip setAttributedText:atrStringPrice];
    }else{
        [self.lblTip setText:@""];
    }
}

- (void)textFieldChange:(UITextField *)textField{
    NSString *strPrice = textField.text;
    if ([NSString isNullString:strPrice]) {
        [self.btnPrice setBackgroundColor:ColorGaryButtom];
    }else{
        [self.btnPrice setBackgroundColor:ColorRed];
    }
    [self.lblPrice setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:strPrice])];
}

- (IBAction)clickButtonBuy:(UIButton *)sender {
    NSString *strPrice = self.txtPrice.text;
    if ([NSString isNullString:strPrice]) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    if (![NSString isMoney:strPrice]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak VendorPayTheBillController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestFourZeroBuyTheBillbuy_user_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId
                                                                andseller_user_id:[NSString stringStandard:self.seller_user_id]
                                                                     andbuy_money:[NSString stringStandard:strPrice] anddirectPurchase:@"1"]
                         subscribeNext:^(NSDictionary* dictionary) {
        if ([dictionary[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
            PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
            controller.strOrderId = dictionary[@"order_id"];
            controller.strTotalPrice = strPrice;
            controller.isPayTheBill = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}



@end

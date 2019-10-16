//
//  DrawbackMoney.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "DrawbackMoney.h"

@implementation DrawbackMoney
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)clickButtonCancel:(UIButton *)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}

- (IBAction)clickButtonConfilm:(UIButton *)sender {
    if ([NSString isNullString:self.txtInput.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入退款理由"];
        return;
    }
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDrawbackMoneySucceed
                                                        object:self.txtInput.text];
}

@end

//
//  SignInTip.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/4.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "SignInTip.h"

@implementation SignInTip
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.lblIntegral setTextColor:ColorRed];
}
- (IBAction)clickButtonShare:(UIButton *)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
    
    if (alert.delegate && [alert.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [alert.delegate alertView:alert clickedButtonAtIndex:1];
    }
    [alert hide];
    
}
- (IBAction)clickButtonClose:(UIButton *)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

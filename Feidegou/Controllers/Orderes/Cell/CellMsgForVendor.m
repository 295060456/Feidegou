//
//  CellMsgForVendor.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellMsgForVendor.h"

@implementation CellMsgForVendor

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.txtMsg setDelegate:self];
    // Initialization code
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.integerMost>1 && ![NSString isNullString:string]) {
        if (textField == self.txtMsg) {
            if (self.txtMsg.text.length > self.integerMost-1) return NO;
        }
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

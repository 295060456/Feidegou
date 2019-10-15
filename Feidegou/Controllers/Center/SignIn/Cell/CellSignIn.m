//
//  CellSignIn.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/4.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellSignIn.h"

@implementation CellSignIn

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblLineOne setBackgroundColor:ColorLine];
    [self.lblLineTwo setBackgroundColor:ColorLine];
    [self.lblMoney setTextColor:ColorRed];
    [self.lblRightUp setTextColor:ColorRed];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

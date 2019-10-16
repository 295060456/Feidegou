//
//  CellGoodBigLeft.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellGoodBigLeft.h"

@implementation CellGoodBigLeft

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viRight setBackgroundColor:ColorLine];
    [self setBackgroundColor:ColorLine];
    [self.lblUpName setTextColor:ColorGreen];
    [self.lblDwonName setTextColor:ColorRed];
    [self.lblBigTip setTextColor:ColorGary];
    [self.lblUpTip setTextColor:ColorGary];
    [self.lblDownTip setTextColor:ColorGary];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

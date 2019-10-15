//
//  CellGoodBigRight.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellGoodBigRight.h"

@implementation CellGoodBigRight

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viLeft setBackgroundColor:ColorLine];
    [self setBackgroundColor:ColorLine];
    [self.lblUpName setTextColor:ColorGreen];
    [self.lblDwonName setTextColor:ColorRed];
    [self.lblBigTip setTextColor:ColorGary];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

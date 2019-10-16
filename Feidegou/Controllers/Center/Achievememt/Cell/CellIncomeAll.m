//
//  CellIncomeAll.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/5.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellIncomeAll.h"

@implementation CellIncomeAll

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblLineOne setBackgroundColor:ColorLine];
    [self.lblLineTwo setBackgroundColor:ColorLine];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

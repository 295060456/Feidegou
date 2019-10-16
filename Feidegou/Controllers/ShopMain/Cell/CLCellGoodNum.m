//
//  CLCellGoodNum.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/14.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoodNum.h"

@implementation CLCellGoodNum

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnReduce setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnAdd setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.lblNum setTextColor:ColorGary];
    [self.viNum.layer setBorderWidth:1];
    [self.viNum.layer setBorderColor:ColorGary.CGColor];
    // Initialization code
}

@end

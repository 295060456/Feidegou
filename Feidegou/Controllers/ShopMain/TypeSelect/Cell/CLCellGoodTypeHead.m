//
//  CLCellGoodTypeHead.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/29.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoodTypeHead.h"

@implementation CLCellGoodTypeHead

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viBack.layer setBorderWidth:0.5];
    [self.viBack.layer setBorderColor:ColorLine.CGColor];
    [self.viLbel setBackgroundColor:[UIColor clearColor]];
    [self.lblLine setBackgroundColor:ColorLine];
    // Initialization code
}

@end

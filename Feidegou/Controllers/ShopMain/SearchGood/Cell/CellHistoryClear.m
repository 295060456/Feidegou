//
//  CellHistoryClear.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellHistoryClear.h"

@implementation CellHistoryClear

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnClear.layer setBorderColor:ColorGary.CGColor];
    [self.btnClear.layer setBorderWidth:0.5];
    [self.btnClear setTitleColor:ColorGary forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CellGoodEnterIn.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellGoodEnterIn.h"

@implementation CellGoodEnterIn

- (void)awakeFromNib {
    [self.btnCheck.layer setBorderWidth:0.5];
    [self.btnCheck.layer setBorderColor:ColorFromRGB(140, 140, 140).CGColor];
    
    [self.btnPhone.layer setBorderWidth:0.5];
    [self.btnPhone.layer setBorderColor:ColorFromRGB(140, 140, 140).CGColor];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

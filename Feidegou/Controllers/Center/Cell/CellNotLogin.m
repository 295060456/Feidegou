//
//  CellNotLogin.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellNotLogin.h"

@implementation CellNotLogin

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgBack setImage:[PublicFunction getImageWithRect:self.imgBack.frame andColorBegin:ColorFromHexRGB(0xf22a2a) andColorEnd:ColorFromHexRGB(0xf22a2a) andDerection:enumColorDirectionFrom_left]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

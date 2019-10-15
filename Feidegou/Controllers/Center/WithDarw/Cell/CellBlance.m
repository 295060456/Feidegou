//
//  CellBlance.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/12.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellBlance.h"

@implementation CellBlance

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgBack setImage:[PublicFunction getImageWithRect:self.imgBack.frame andColorBegin:ColorFromHexRGB(0xffc600) andColorEnd:ColorFromHexRGB(0xff9c00) andDerection:enumColorDirectionFrom_left]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

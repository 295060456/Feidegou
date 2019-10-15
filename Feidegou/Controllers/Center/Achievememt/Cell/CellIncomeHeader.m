//
//  CellIncomeHeader.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/5.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellIncomeHeader.h"

@implementation CellIncomeHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *imgBack = [PublicFunction getImageWithRect:CGRectMake(0, 0, SCREEN_WIDTH, 120) andColorBegin:ColorFromHexRGB(0xffc600) andColorEnd:ColorFromHexRGB(0xff9c00) andDerection:enumColorDirectionFrom_left];
    [self.imgBack setImage:imgBack];
    UIImage *imgN = [UIImage imageWithColor:ColorFromHexRGB(0xff9c00)];
    UIImage *imgS = [UIImage imageWithColor:ColorFromHexRGB(0xffc600)];
    [self.btnOnline setBackgroundImage:imgN forState:UIControlStateNormal];
    [self.btnOnline setBackgroundImage:imgS forState:UIControlStateSelected];
    [self.btnOutLine setBackgroundImage:imgN forState:UIControlStateNormal];
    [self.btnOutLine setBackgroundImage:imgS forState:UIControlStateSelected];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

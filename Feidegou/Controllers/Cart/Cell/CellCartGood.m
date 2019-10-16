//
//  CellCartGood.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellCartGood.h"
#import "UIButton+EnlargeTouchArea.h"

@implementation CellCartGood

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viNum.layer setBorderWidth:0.5];
    [self.viNum.layer setBorderColor:ColorLine.CGColor];
    [self.btnReduce setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnReduce setTitleColor:ColorGaryDark forState:UIControlStateDisabled];
    [self.btnAdd setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.lblLineOne setBackgroundColor:ColorLine];
    [self.lblLineTwo setBackgroundColor:ColorLine];
    [self.btnReduce setEnlargeEdgeWithTop:20 right:0 bottom:20 left:20];
    [self.btnAdd setEnlargeEdgeWithTop:20 right:20 bottom:20 left:0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

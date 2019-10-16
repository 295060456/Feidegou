//
//  CellOneLabel.m
//  guanggaobao
//
//  Created by 谭自强 on 16/6/3.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOneLabel.h"

@implementation CellOneLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.lblContent setTextColor:ColorRed];
    }else{
        [self.lblContent setTextColor:ColorBlack];
    }
    // Configure the view for the selected state
}

@end

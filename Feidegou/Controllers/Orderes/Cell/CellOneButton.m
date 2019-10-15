//
//  CellOneButton.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/11.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellOneButton.h"

@implementation CellOneButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnCommit.layer setBorderWidth:0.5];
    [self.btnCommit.layer setBorderColor:ColorLine.CGColor];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

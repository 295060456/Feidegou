//
//  CellHeaderMore.m
//  Feidegou
//
//  Created by 谭自强 on 2018/9/17.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellHeaderMore.h"

@implementation CellHeaderMore

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblUp setBackgroundColor:ColorHeader];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

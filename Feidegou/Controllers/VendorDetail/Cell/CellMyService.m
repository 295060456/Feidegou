//
//  CellMyService.m
//  Smartlink
//
//  Created by 谭自强 on 16/3/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellMyService.h"

@implementation CellMyService

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblNum.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

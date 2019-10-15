//
//  CellCartHead.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellCartHead.h"

@implementation CellCartHead

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)refreshData{
    NSString *strTitle = @"商家自营店";
    [self.lblTitle setText:strTitle];
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strTitle andWidth:SCREEN_WIDTH-75 andFont:15.0].width;
    self.layoutConstraintWidth.constant = fWidth;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

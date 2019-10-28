//
//  CellVendorTitle.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/30.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorTitle.h"

@implementation CellVendorTitle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnBuy setBackgroundColor:ColorRed];
    // Initialization code
}
- (void)populateData:(NSDictionary *)dicInfo{
    [self.lblTitle setTextNull:dicInfo[@"store_name"]];
    self.viStar.show_star = [dicInfo[@"store_evaluate1"] floatValue]*100;
    [self.viStar refreshView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CellVendorGoodShopInfo.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGoodShopInfo.h"

@implementation CellVendorGoodShopInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblLine setBackgroundColor:ColorLine];
    // Initialization code
}

- (void)populataData:(NSDictionary *)dicInfo{
    [self.lblName setTextNull:dicInfo[@"goods"][@"store_name"]];
    [self.lblAddress setTextNull:dicInfo[@"goods"][@"store_address"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

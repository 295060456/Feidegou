//
//  CellVendorGoodList.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/31.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGoodList.h"

@implementation CellVendorGoodList

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblTip setBackgroundColor:ColorRed];
    // Initialization code
}
- (void)populataData:(ModelGood *)model{
    [self.imgHead setImagePathHead:model.path];
    
    [self.lblPrice setTextColor:ColorRed];
    [self.lblTitle setTextNull:model.goods_name];
    [self.lblNum setTextNull:StringFormat(@"%@人付款",[NSString stringStandardZero:model.goods_salenum])];
    if ([model.give_integral floatValue]>0) {
        [self.viGive setHidden:NO];
        [self.lblGive setTextNull:StringFormat(@"购买后送%@",[NSString stringStandardFloatTwo:model.give_integral])];
        self.layoutConstraintY.constant = 0;
    }else{
        [self.viGive setHidden:YES];
        self.layoutConstraintY.constant = 25;
    }
    
    [self.lblPrice setTextVendorPrice:model.store_price andOldPrice:model.goods_price];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

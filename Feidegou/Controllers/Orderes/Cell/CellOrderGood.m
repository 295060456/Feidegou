//
//  CellOrderGood.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderGood.h"

@implementation CellOrderGood

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(ModelOrderList *)model{
//    [self.imgHead setImagePathHead:model.icon];
//    [self.lblTitle setTextNull:model.goodsName];
}

- (void)populateDataArea:(ModelAreaList *)model{
    [self.imgHead setImagePathListSquare:model.path];
    [self.lblTitle setTextNull:model.ig_goods_name];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

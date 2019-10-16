//
//  CellOrderAddress.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderAddress.h"

@implementation CellOrderAddress

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(ModelOrderDtail *)model{
    
    [self.lblName setText:StringFormat(@"收货人:%@",model.trueName)];
    [self.lblPhone setTextNull:model.mobile];
    [self.lblAddress setText:StringFormat(@"收货地址:%@",model.area_info)];
    
}

- (void)populateDataArea:(ModelAreaDetail *)model{
    
    [self.lblName setText:StringFormat(@"收货人:%@",model.trueName)];
    [self.lblPhone setTextNull:model.mobile];
    [self.lblAddress setText:StringFormat(@"收货地址:%@",model.area_info)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

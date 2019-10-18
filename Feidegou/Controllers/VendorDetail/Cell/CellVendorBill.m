//
//  CellVendorBill.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/1/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellVendorBill.h"

@implementation CellVendorBill

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo{
    [self.imgHead setImagePathHead:dicInfo[@"path"]];
    [self.lblTitle setTextNull:dicInfo[@"store_name"]];
    [self.lblPrice setTextNull:StringFormat(@"付款总额:￥%@",dicInfo[@"buy_money"])];
    [self.lblTime setTextNull:StringFormat(@"下单时间:%@",[PublicFunction translateTimeHMS:dicInfo[@"addTime"]])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

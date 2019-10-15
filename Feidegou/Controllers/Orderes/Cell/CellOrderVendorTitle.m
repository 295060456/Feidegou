//
//  CellOrderVendorTitle.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderVendorTitle.h"

@implementation CellOrderVendorTitle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(ModelOrderList *)model{
//    NSString *strTitle = model.store_name;
    NSString *strTitle = StringFormat(@"订单号:%@",model.order_id);
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strTitle andWidth:SCREEN_WIDTH-120 andFont:15.0].width;
    self.layoutConstrintWidth.constant = fWidth;
    [self.lblTitle setTextNull:strTitle];
//    NSString *strType = @"交易成功";
//    enumOrderState state = [PublicFunction returnStateByNum:model.order_status];
//    if (state == enumOrder_dfk) {
//        strType = @"等待付款";
//    }
//    if (state == enumOrder_yfk) {
//        strType = @"等待发货";
//    }
//    if (state == enumOrder_yfh) {
//        strType = @"商家已发货";
//    }
//    if (state == enumOrder_ysh) {
//        strType = @"待评价";
//    }
//    if (state == enumOrder_yqx) {
//        strType = @"已取消";
//    }
    [self.lblType setHidden:NO];
    [self.lblType setTextNull:model.state];
}
- (void)populateDataNoType:(ModelOrderDtail *)model{
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:model.store_name andWidth:SCREEN_WIDTH-40 andFont:15.0].width;
    self.layoutConstrintWidth.constant = fWidth;
    [self.lblType setHidden:YES];
    [self.lblTitle setTextNull:model.store_name];
}

- (void)populateDataArea:(ModelAreaList *)model{
    NSString *strTitle = @"平台自营店";
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strTitle andWidth:SCREEN_WIDTH-145 andFont:15.0].width;
    self.layoutConstrintWidth.constant = fWidth;
    [self.lblTitle setTextNull:strTitle];
    NSString *strType = @"交易成功";
    enumOrderState state = [PublicFunction returnStateByNum:model.igo_status];
    if (state == enumOrder_dfk) {
        strType = @"等待付款";
    }
    if (state == enumOrder_yfk) {
        strType = @"等待发货";
    }
    if (state == enumOrder_yfh) {
        strType = @"商家已发货";
    }
    if (state == enumOrder_ysh) {
        strType = @"待评价";
    }
    [self.lblType setHidden:NO];
    [self.lblType setTextNull:strType];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CellOrderButtones.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderButtones.h"

@implementation CellOrderButtones

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnOne.layer setBorderWidth:0.5];
    [self.btnOne.layer setBorderColor:ColorRed.CGColor];
    [self.btnOne setTitleColor:ColorRed forState:UIControlStateNormal];
    [self.btnTwo.layer setBorderWidth:0.5];
    [self.btnTwo.layer setBorderColor:ColorLine.CGColor];
    [self.btnTwo setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnThree.layer setBorderWidth:0.5];
    [self.btnThree.layer setBorderColor:ColorLine.CGColor];
    [self.btnThree setTitleColor:ColorBlack forState:UIControlStateNormal];
    // Initialization code
}

- (void)populateDataOrderList:(ModelOrderList *)model{
    NSArray *array = model.arrButton;
    [self.btnOne setHidden:YES];
    [self.btnTwo setHidden:YES];
    [self.btnThree setHidden:YES];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+10];
        [button setHidden:NO];
        [button setTitle:array[i] forState:UIControlStateNormal];
    }
}
//- (void)populateData:(ModelOrderList *)model{
//    enumOrderState state = [PublicFunction returnStateByNum:model.order_status];
//    switch (state) {
//        case enumOrder_dfk:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:NO];
//            [self.btnOne setTitle:@"去支付" forState:UIControlStateNormal];
//            [self.btnTwo setTitle:@"取消订单" forState:UIControlStateNormal];
//        }
//            break;
//        case enumOrder_xxzfdsh:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"查看详情" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//        case enumOrder_yfk:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"查看详情" forState:UIControlStateNormal];
//        }
//            break;
//        case enumOrder_yfh:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"确认收货" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//
//        case enumOrder_ysh:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"去评价" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//        break;
//
//        case enumOrder_ywc:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"查看详情" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//        break;
//
//        default:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"取消订单" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//    }
//
//}
//
//- (void)populateDataArea:(ModelAreaList *)model{
//    enumOrderState state = [PublicFunction returnStateByNum:model.igo_status];
//    switch (state) {
//        case enumOrder_yfk:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"查看订单" forState:UIControlStateNormal];
//        }
//            break;
//
//        default:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"查看订单" forState:UIControlStateNormal];
//            if (![NSString isNullString:model.igo_ship_code]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

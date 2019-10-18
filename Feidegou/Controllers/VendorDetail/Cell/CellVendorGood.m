//
//  CellVendorGood.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGood.h"

@implementation CellVendorGood

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblMoney setTextColor:ColorRed];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo{
    [self.imgHead setImagePathHead:dicInfo[@"path"]];
    [self.lblTitle setTextNull:dicInfo[@"goods_name"]];
    NSString *strPriceNow = [NSString stringStandardFloatTwo:dicInfo[@"store_price"]];
//    if ([dicInfo[@"use_integral_set"] intValue]==2) {
//        NSString *strIntegral = [NSString stringStandardFloatTwo:dicInfo[@"use_integral_value"]];
//        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@+%@%@",strPriceNow,strIntegral,[NSString stringStandardToIntegralOrRedPacket:dicInfo[@"good_area"]])];
//        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
//        [self.lblMoney setAttributedText:atrStringPrice];
//    }else{
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                range:NSMakeRange(1, strPriceNow.length)];
        [self.lblMoney setAttributedText:atrStringPrice];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CellVendorGoodBuy.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGoodBuy.h"

@implementation CellVendorGoodBuy

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnBuy setBackgroundColor:ColorHeader];
    [self.lblMoney setTextColor:ColorRed];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo andPrice:(NSString *)strPrice{
    NSString *strPriceNow = [NSString stringStandardFloatTwo:strPrice];
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

//
//  CellGoodDetai.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellGoodDetai.h"

@implementation CellGoodDetai

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(NSDictionary *)dicInfo{
    NSString *strNameTip = [NSString stringStandard:dicInfo[@"name_prefix"]];
    NSString *strName = [NSString stringStandard:dicInfo[@"goods_name"]];
    NSMutableAttributedString * atrTitle = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@%@",strNameTip,strName)];
    [atrTitle addAttributes:@{NSForegroundColorAttributeName:ColorHeader} range:NSMakeRange(0, strNameTip.length)];
    [self.lblName setAttributedText:atrTitle];
    
//    [self.lblName setTextNull:dicInfo[@"goods_name"]];
    /**
    NSString *strPriceNow = [NSString stringStandardFloatTwo:dicInfo[@"store_price"]];
    NSString *strPriceOld = [NSString stringStandardFloatTwo:dicInfo[@"goods_price"]];
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@ ￥%@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [self.lblPrice setAttributedText:atrStringPrice];*/
    
    NSString *strPriceNow = [NSString stringStandardFloatTwo:dicInfo[@"store_price"]];
    
    if ([dicInfo[@"use_integral_set"] intValue]==2) {
        NSString *strIntegral = [NSString stringStandardFloatTwo:dicInfo[@"use_integral_value"]];
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@+%@%@",strPriceNow,strIntegral,[NSString stringStandardToIntegralOrRedPacket:dicInfo[@"good_area"]])];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
        [self.lblPrice setAttributedText:atrStringPrice];
    }else{
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
        [self.lblPrice setAttributedText:atrStringPrice];
    }
    
    NSString *strNum = [NSString stringStandardZero:dicInfo[@"goods_salenum"]];
    NSMutableAttributedString * atrStringNum = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"已购买%@件",strNum)];
    [atrStringNum addAttributes:@{NSForegroundColorAttributeName:ColorHeader} range:NSMakeRange(3, strNum.length)];
    [self.lblExchange setAttributedText:atrStringNum];
}
- (void)populateDataAreaExchange:(ModelEreaExchangeDetail *)model{
    [self.lblName setTextNull:model.ig_goods_name];
    NSString *strPriceNow = TransformString(model.ig_goods_integral);
    NSString *strPriceOld = TransformString(model.ig_goods_price);
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@分 ￥%@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(0, strPriceNow.length)];
    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [self.lblPrice setAttributedText:atrStringPrice];
    

    NSString *strNum = [NSString stringStandardZero:model.ig_exchange_count];
    NSMutableAttributedString * atrStringNum = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"已兑换%@件",strNum)];
    [atrStringNum addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(3, strNum.length)];
    [self.lblExchange setAttributedText:atrStringNum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CLCellGoods.m
//  guanggaobao
//
//  Created by 谭自强 on 16/6/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoods.h"

@implementation CLCellGoods

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(ModelGood *)model{
    [self.lblTitle setTextNull:model.goods_name];
    /**原价和现价
    NSString *strPriceNow = [NSString stringStandardFloatTwo:model.store_price];
    NSString *strPriceOld = [NSString stringStandardFloatTwo:model.goods_price];
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@ ￥%@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary} range:NSMakeRange(strPriceNow.length+2, strPriceOld.length+1)];
    [self.lblPrice setAttributedText:atrStringPrice];*/
    
    NSString *strPriceNow = [NSString stringStandardFloatTwo:model.store_price];
    
    if ([model.use_integral_set intValue]==2) {
        NSString *strIntegral = [NSString stringStandardFloatTwo:model.use_integral_value];
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@+%@%@",strPriceNow,strIntegral,[NSString stringStandardToIntegralOrRedPacket:model.good_area])];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
        [self.lblPrice setAttributedText:atrStringPrice];
    }else{
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
        [self.lblPrice setAttributedText:atrStringPrice];
    }
    
    NSString *strNum = TransformString(model.goods_salenum);
    NSMutableAttributedString * atrStringNum = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"已购买%@件",strNum)];
    [atrStringNum addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(3, strNum.length)];
    [self.lblExchange setAttributedText:atrStringNum];
    [self.imgGoods setImagePathListSquare:model.path];
    
}
@end

//
//  CellGoodList.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellGoodList.h"

@implementation CellGoodList

- (void)awakeFromNib {
    self.fWidthPre = 90;
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(ModelGood *)model{
    [self.lblTitle setTextNull:model.goods_name];
    /**原价和现价
    NSString *strPriceNow = TransformString(model.store_price);
    NSString *strPriceOld = TransformString(model.goods_price);
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@ ￥%@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(1, strPriceNow.length)];
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

- (void)populateDataExchage:(ModelEreaExchageList *)model{
    [self.lblTitle setTextNull:model.ig_goods_name];
    NSString *strPriceNow = TransformString(model.ig_goods_integral);
    NSString *strPriceOld = [NSString stringStandardFloatTwo:model.ig_goods_price];
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@分 ￥%@",strPriceNow,strPriceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, strPriceNow.length)];
    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(strPriceNow.length+1+1, strPriceOld.length+1)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary} range:NSMakeRange(strPriceNow.length+1+1, strPriceOld.length+1)];
    [self.lblPrice setAttributedText:atrStringPrice];
    
    
    NSString *strNum = TransformString(model.ig_exchange_count);
    NSMutableAttributedString * atrStringNum = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"已兑换%@件",strNum)];
    [atrStringNum addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(3, strNum.length)];
    [self.lblExchange setAttributedText:atrStringNum];
    [self.imgGoods setImagePathListSquare:model.img];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

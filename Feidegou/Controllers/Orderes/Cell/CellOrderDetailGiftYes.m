//
//  CellOrderDetailGiftYes.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderDetailGiftYes.h"

@implementation CellOrderDetailGiftYes

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo{
    
    
    [self.lblName setTextNull:dicInfo[@"goods_name"]];
    [self.lblAttribute setTextNull:dicInfo[@"spec_info"]];
    [self.lblPriceSale setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:dicInfo[@"store_price"]])];
    
//    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@ ",[NSString stringStandardFloatTwo:model.goods_price])];
//    [atrStringPrice addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, atrStringPrice.length)];
//    [self.lblPriceOld setAttributedText:atrStringPrice];
    [self.lblPriceOld setTextNull:@""];
    [self.lblNum setTextNull:StringFormat(@"x%@",[NSString stringStandardZero:dicInfo[@"count"]])];
    [self.imgHead setImagePathListSquare:dicInfo[@"path"]];
    
    [self.viGift setHidden:YES];
//    NSString *deliveryGoods = model.deliveryGoods;
//    if ([NSString isNullString:deliveryGoods]) {
//        [self.viGift setHidden:YES];
//    }else{
//        [self.viGift setHidden:NO];
//        [self.lblGiftName setText:StringFormat(@"[赠品]%@",deliveryGoods)];
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

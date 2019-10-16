//
//  CellOrderGiftYes.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderGiftYes.h"

@implementation CellOrderGiftYes

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo andAttributeName:(NSString *)strAttribute andPirce:(NSString *)strPrice andNum:(int)intNum{
    [self.lblName setTextNull:dicInfo[@"goods"][@"goods_name"]];
    [self.imgHead setImagePathListSquare:dicInfo[@"goods"][@"icon"]];
    [self.lblAttributeName setTextNull:StringFormat(@"数量:%d %@",intNum,strAttribute)];
    [self.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:strPrice])];
    [self.lblGiftName setTextNull:StringFormat(@"[赠品]%@",dicInfo[@"deliveryGoods"][@"goods_name"])];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

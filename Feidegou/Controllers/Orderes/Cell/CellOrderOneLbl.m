//
//  CellOrderOneLbl.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderOneLbl.h"

@implementation CellOrderOneLbl

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(ModelOrderList *)model{
    NSString *strNum = [NSString stringStandardZero:model.count];
    NSString *strPrice = StringFormat(@"￥%@",[NSString stringStandardFloatTwo:model.totalPrice]);
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"共%@件商品 实付款：%@",strNum,strPrice)];
    [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(strNum.length+9,strPrice.length)];
    [self.lblContent setAttributedText:atrString];
}
- (void)populateDataArea:(ModelAreaList *)model{
    NSString *strNum = [NSString stringStandardZero:model.count];
    NSString *strPrice = StringFormat(@"%@积分",[NSString stringStandardZero:model.integral]);
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"共%@件商品 实付款：%@",strNum,strPrice)];
    [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(strNum.length+9,strPrice.length)];
    [self.lblContent setAttributedText:atrString];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

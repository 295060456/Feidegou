//
//  CellOrderGiftNo.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellOrderGiftNo.h"

@implementation CellOrderGiftNo

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:ColorFromRGBSame(247)];
    [self.btnShare setTitleColor:ColorHeader forState:UIControlStateNormal];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo{
    [self.btnShare setHidden:YES];
    [self.lblName setTextNull:dicInfo[@"goods_name"]];
    [self.imgHead setImagePathListRectangle:dicInfo[@"path"]];
    [self.lblAttributeName setTextNull:StringFormat(@"%@",dicInfo[@"spec_info"])];
    [self.lblNum setText:StringFormat(@"x%@",[NSString stringStandardZero:dicInfo[@"count"]])];
    [self.lblPrice setTextGoodPrice:dicInfo[@"price"] andDB:dicInfo[@"gift_d_coins"]];
}
- (void)populateData:(NSDictionary *)dicInfo andAttributeName:(NSString *)strAttribute andPirce:(NSString *)strPrice andNum:(int)intNum{
    [self.btnShare setHidden:YES];
    [self.lblName setTextNull:dicInfo[@"goods"][@"goods_name"]];
    [self.imgHead setImagePathListRectangle:dicInfo[@"goods"][@"icon"]];
    [self.lblAttributeName setTextNull:StringFormat(@"%@",[NSString stringStandard:strAttribute])];
    [self.lblNum setText:StringFormat(@"x%@",[NSString stringStandardZero:dicInfo[@"count"]])];
    [self.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:strPrice])];
}
- (void)populateDataName:(NSString *)strName andPath:(NSString *)strPath andNum:(NSString *)strNum andspec_info:(NSString *)spec_info andprice:(NSString *)strprice andgift_d_coins:(NSString *)gift_d_coins{
    [self.btnShare setHidden:YES];
    [self.lblName setTextNull:strName];
    [self.imgHead setImagePathHead:strPath];
    [self.lblAttributeName setTextNull:StringFormat(@"%@",spec_info)];
    [self.lblNum setText:StringFormat(@"x%@",[NSString stringStandardZero:strNum])];
    [self.lblPrice setTextGoodPrice:strprice andDB:gift_d_coins];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animanted {
    [super setSelected:selected animated:animanted];

    // Configure the view for the selected state
}

@end

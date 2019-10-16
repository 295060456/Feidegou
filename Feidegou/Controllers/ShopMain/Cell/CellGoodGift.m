//
//  CellGoodGift.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellGoodGift.h"

@implementation CellGoodGift

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(NSDictionary *)dicInfo{
    
    [self.lblName setTextNull:dicInfo[@"goods_name"]];
    [self.imgHead setImagePathListSquare:dicInfo[@"photoUrl"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

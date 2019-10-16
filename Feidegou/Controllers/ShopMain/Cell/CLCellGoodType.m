//
//  CLCellGoodType.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoodType.h"

@implementation CLCellGoodType

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(NSDictionary *)dicInfo{
    [self.lblTittle setTextNull:dicInfo[@"className"]];
    [self.imgHead setImageWebp:dicInfo[@"photoUrl"]];
}
@end

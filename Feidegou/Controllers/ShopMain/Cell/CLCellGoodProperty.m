//
//  CLCellGoodProperty.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/14.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoodProperty.h"

@implementation CLCellGoodProperty

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSDictionary *)dicInfo{
    [self.lblContent setTextNull:dicInfo[@"value"]];
    [self.lblContent.layer setBorderWidth:0.5];
    if ([dicInfo[@"select"] intValue]==1) {
        [self.lblContent.layer setBorderColor:ColorRed.CGColor];
        [self.lblContent setTextColor:ColorRed];
    }else{
        [self.lblContent.layer setBorderColor:ColorLine.CGColor];
        [self.lblContent setTextColor:ColorBlack];
    }
}
@end

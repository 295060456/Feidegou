//
//  CellDiscussVendor.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellDiscussVendor.h"

@implementation CellDiscussVendor

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populataData:(NSDictionary *)dicInfo{
    [self.imgHead setImagePathHead:dicInfo[@"path"]];
    [self.lblName setTextNull:dicInfo[@"userName"]];
    [self.lblTime setTextNull:[PublicFunction translateTime:dicInfo[@"addTime"]]];
    [self.lblContent setTextNull:dicInfo[@"evaluate_info"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

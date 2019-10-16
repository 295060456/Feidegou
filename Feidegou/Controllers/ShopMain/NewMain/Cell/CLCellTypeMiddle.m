//
//  CLCellTypeMiddle.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CLCellTypeMiddle.h"

@implementation CLCellTypeMiddle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblLineUp setBackgroundColor:ColorLine];
    [self.lblLineLeft setBackgroundColor:ColorLine];
    [self.lblLineDown setBackgroundColor:ColorLine];
    [self.lblLineRight setBackgroundColor:ColorLine];
    // Initialization code
}

@end

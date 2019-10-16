//
//  CellAdver.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellAdver.h"

@implementation CellAdver

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshLable:(NSString *)strMsg{
    NSArray *arrImg = [NSArray arrayWithObjects:ImageNamed(@"img_good_0"),ImageNamed(@"img_good_1"),ImageNamed(@"img_good_2"), nil];
    [self.imgTip setAnimationImages:arrImg];
    [self.imgTip setAnimationDuration:0.8];
    [self.imgTip startAnimating];
    [self.lblMsg refreshLabels];
    [self.lblMsg observeApplicationNotifications];
    [self.lblMsg setPauseInterval:2.0];
    [self.lblMsg setLabelSpacing:30];
    [self.lblMsg setScrollSpeed:35.0];
    [self.lblMsg setTextColor:[UIColor whiteColor]];
    [self.lblMsg setTextAlignment:NSTextAlignmentLeft];
    [self.lblMsg setFadeLength:12.0];
    [self.lblMsg setScrollDirection:CBAutoScrollDirectionLeft];
    [self.lblMsg setFont:[UIFont systemFontOfSize:14.0]];
    [self.lblMsg setTextColor:ColorBlack];
    [self.lblMsg setText:strMsg refreshLabels:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

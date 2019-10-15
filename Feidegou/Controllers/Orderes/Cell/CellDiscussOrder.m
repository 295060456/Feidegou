//
//  CellDiscussOrder.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/19.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellDiscussOrder.h"

@implementation CellDiscussOrder

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viBackCell setBackgroundColor:ColorBackground];
    // Initialization code
}

- (void)popuLateData:(DiscussAttribute *)attribute{
    [self.imgHead setImagePathHead:attribute.strIcon];
    [self.lblTitle setTextNull:attribute.strGoodsName];
    [self.textView setText:attribute.strContent];
    UIButton *btnGood = (UIButton *)[self viewWithTag:100];
    UIButton *btnMiddle = (UIButton *)[self viewWithTag:101];
    UIButton *btnBad = (UIButton *)[self viewWithTag:102];
    if ([attribute.strGood intValue]==-1) {
        [btnGood setSelected:NO];
        [btnMiddle setSelected:NO];
        [btnBad setSelected:YES];
    }else if ([attribute.strGood intValue]==0){
        
        [btnGood setSelected:NO];
        [btnMiddle setSelected:YES];
        [btnBad setSelected:NO];
    }else{
        [btnGood setSelected:YES];
        [btnMiddle setSelected:NO];
        [btnBad setSelected:NO];
    }
    int intMS = [attribute.strMS intValue];
    for (int i = 200; i<205; i++) {
        UIButton *btnMS = (UIButton *)[self viewWithTag:i];
        if (i-200<intMS) {
            [btnMS setSelected:YES];
        }else{
            [btnMS setSelected:NO];
        }
    }
    
    int intFH = [attribute.strFH intValue];
    for (int i = 300; i<305; i++) {
        UIButton *btnFH = (UIButton *)[self viewWithTag:i];
        if (i-300<intFH) {
            [btnFH setSelected:YES];
        }else{
            [btnFH setSelected:NO];
        }
    }
    int intFW = [attribute.strFW intValue];
    for (int i = 400; i<405; i++) {
        UIButton *btnFW = (UIButton *)[self viewWithTag:i];
        if (i-400<intFW) {
            [btnFW setSelected:YES];
        }else{
            [btnFW setSelected:NO];
        }
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

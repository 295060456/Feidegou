//
//  CellVendorShop.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorShop.h"

@implementation CellVendorShop

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viLine setBackgroundColor:ColorLine];
    // Initialization code
}
- (void)populataData:(ModelVendorNear *)model{
    if ([model.gift_integral floatValue]>0) {
        [self.viDiscount setHidden:NO];
        NSString *strDiscount = TransformString(model.gift_integral);
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"线下买单送%@%%积分",strDiscount)];
        [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorRed}
                                range:NSMakeRange(5, strDiscount.length+1)];
        [self.lblDiscount setAttributedText:atrStringPrice];
    }else{
        [self.viDiscount setHidden:YES];
    }
    
    [self.imgHead setImagePathHead:model.path];
    
    [self.lblTitle setTextNull:model.store_name];
    [self.lblMoney setTextNull:StringFormat(@"%@人付款",[NSString stringStandardZero:model.selNum])];
    NSString *strLocation = [NSString stringStandard:model.areaName];
    if (![NSString isNullString:model.distance]) {
        long distace = [model.distance longLongValue];
        if (distace>100) {
            strLocation = StringFormat(@"%@<%.2fkm",strLocation,distace/1000.0);
        }else{
            strLocation = StringFormat(@"%@<%ldm",strLocation,distace);
        }
        
    }
    [self.lblDescription setTextNull:strLocation];
    
    self.viStarNew.show_star = [model.store_evaluate1 floatValue]*100;
    [self.viStarNew refreshView];
    self.viStarNew.userInteractionEnabled = NO;
//    int intDiscuss = [model.store_evaluate1 intValue];
//    for (int i = 100; i<105; i++) {
//        UIImageView *imgDiscuss = (UIImageView *)[self viewWithTag:i];
//        if (i-100<intDiscuss) {
//            [imgDiscuss setImage:ImageNamed(@"img_discuss_s_px")];
//        }else{
//            [imgDiscuss setImage:ImageNamed(@"img_discuss_n_px")];
//        }
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

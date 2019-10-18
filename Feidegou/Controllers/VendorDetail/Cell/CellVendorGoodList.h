//
//  CellVendorGoodList.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/31.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelGood.h"

@interface CellVendorGoodList : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelDarkBig *lblPrice;
@property (weak, nonatomic) IBOutlet UILabelDarkSmall *lblNum;
@property (weak, nonatomic) IBOutlet UIView *viGive;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintY;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblGive;

- (void)populataData:(ModelGood *)model;

@end

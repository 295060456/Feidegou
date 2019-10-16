//
//  CellCartGood.h
//  Vendor
//
//  Created by 谭自强 on 2016/12/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellCartGood : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIView *viAttribute;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UILabelDarkSmall *lblAttribute;
@property (weak, nonatomic) IBOutlet UIView *viNum;
@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblLineOne;
@property (weak, nonatomic) IBOutlet UILabel *lblLineTwo;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidth;

@end

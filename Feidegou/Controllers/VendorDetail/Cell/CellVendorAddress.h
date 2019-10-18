//
//  CellVendorAddress.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/30.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellVendorAddress : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UILabelDarkBig *lblAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthPhone;

@end

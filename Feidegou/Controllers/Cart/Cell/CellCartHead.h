//
//  CellCartHead.h
//  Vendor
//
//  Created by 谭自强 on 2016/12/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCartHead : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblButtonWidth;
- (void)refreshData;
@end

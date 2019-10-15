//
//  CellGoodBigRight.h
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Joker.h"

@interface CellGoodBigRight : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIButton *btnBig;

@property (weak, nonatomic) IBOutlet UILabel *lblUpName;
@property (weak, nonatomic) IBOutlet UILabel *lblDwonName;
@property (weak, nonatomic) IBOutlet UILabel *lblBigTip;
@end

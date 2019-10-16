//
//  CellTextField.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "UITextField+EditChanged.h"

@interface CellTextField : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;

@end

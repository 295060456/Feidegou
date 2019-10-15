//
//  CellOneLabel.h
//  guanggaobao
//
//  Created by 谭自强 on 16/6/3.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellOneLabel : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintEnd;

@end

//
//  CellOnlyOneLbl.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellOnlyOneLbl : JJTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintEnd;
@end

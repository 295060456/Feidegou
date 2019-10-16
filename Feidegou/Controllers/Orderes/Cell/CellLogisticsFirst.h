//
//  CellLogisticsFirst.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellLogisticsFirst : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblLineUp;
@property (weak, nonatomic) IBOutlet UILabel *lblLineDown;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end

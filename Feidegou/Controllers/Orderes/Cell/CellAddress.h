//
//  CellAddress.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellAddress : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnEtit;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIButton *btnDefault;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
- (void)populateData:(BOOL)isSelected;
@end

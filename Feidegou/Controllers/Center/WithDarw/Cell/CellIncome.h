//
//  CellIncome.h
//  guanggaobao
//
//  Created by 谭自强 on 16/3/7.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelIncome.h"
#import "ModelPerformance.h"
#import "MoneyDetailListController.h"

@interface CellIncome : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@end

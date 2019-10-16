//
//  CellGoodMoney.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellGoodMoney : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblLeftUp;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftDown;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyUp;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyDown;
@property (weak, nonatomic) IBOutlet UIView *viMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyMiddle;
@property (weak, nonatomic) IBOutlet UIView *viMiddleTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblMiddleLeftTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblMiddleRightTwo;

@end

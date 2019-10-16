//
//  CellOrderDetialNumber.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Joker.h"

@interface CellOrderDetialNumber : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblTimePay;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;

@end

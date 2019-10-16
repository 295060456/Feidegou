//
//  CellIncomeHeader.h
//  Feidegou
//
//  Created by 谭自强 on 2018/9/5.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellIncomeHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnOutLine;
@property (weak, nonatomic) IBOutlet UIView *viMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@end

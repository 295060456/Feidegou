//
//  CellSignIn.h
//  Feidegou
//
//  Created by 谭自强 on 2018/9/4.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellSignIn : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblMoney;
@property (weak, nonatomic) IBOutlet UIView *viBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSign;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblLeftUp;
@property (weak, nonatomic) IBOutlet UILabelDarkSmall *lblLeftDown;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblMiddleUp;
@property (weak, nonatomic) IBOutlet UILabelDarkSmall *lblMiddleDown;
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblRightUp;
@property (weak, nonatomic) IBOutlet UILabelDarkSmall *lblRightDown;
@property (weak, nonatomic) IBOutlet UILabel *lblLineOne;
@property (weak, nonatomic) IBOutlet UILabel *lblLineTwo;

@end

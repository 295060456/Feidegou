//
//  CellDiscussOrder.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/19.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussAttribute.h"

@interface CellDiscussOrder : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viBackCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *viScoreGood;
@property (weak, nonatomic) IBOutlet UIView *viScoreMS;
@property (weak, nonatomic) IBOutlet UIView *viScoreFH;
@property (weak, nonatomic) IBOutlet UIView *viScoreFW;
- (void)popuLateData:(DiscussAttribute *)attribute;
@end

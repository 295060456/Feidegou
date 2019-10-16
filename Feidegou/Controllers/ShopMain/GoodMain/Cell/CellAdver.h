//
//  CellAdver.h
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "CBAutoScrollLabel.h"

@interface CellAdver : JJTableViewCell
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *lblMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgTip;
- (void)refreshLable:(NSString *)strMsg;
@end

//
//  CellVendorTitle.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/30.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "StarView.h"

@interface CellVendorTitle : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet StarView *viStar;
- (void)populateData:(NSDictionary *)dicInfo;
@end

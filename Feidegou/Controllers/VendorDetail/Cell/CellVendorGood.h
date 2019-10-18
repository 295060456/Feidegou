//
//  CellVendorGood.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellVendorGood : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

- (void)populateData:(NSDictionary *)dicInfo;

@end

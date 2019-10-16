//
//  CellVendorGoodBuy.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellVendorGoodBuy : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
- (void)populateData:(NSDictionary *)dicInfo andPrice:(NSString *)strPrice;
@end

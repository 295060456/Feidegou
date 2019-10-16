//
//  CellVendorGoodShopInfo.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellVendorGoodShopInfo : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblName;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

- (void)populataData:(NSDictionary *)dicInfo;
@end

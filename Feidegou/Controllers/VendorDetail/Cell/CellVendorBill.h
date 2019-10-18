//
//  CellVendorBill.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/1/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellVendorBill : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblTime;

- (void)populateData:(NSDictionary *)dicInfo;
@end

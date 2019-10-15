//
//  CellOrderVendorTitle.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrderList.h"
#import "ModelOrderDtail.h"
#import "ModelAreaList.h"

@interface CellOrderVendorTitle : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstrintWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
- (void)populateData:(ModelOrderList *)model;
- (void)populateDataNoType:(ModelOrderDtail *)model;

- (void)populateDataArea:(ModelAreaList *)model;
@end

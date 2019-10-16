//
//  CellOrderAddress.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrderDtail.h"
#import "ModelAreaDetail.h"


@interface CellOrderAddress : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

- (void)populateData:(ModelOrderDtail *)model;
- (void)populateDataArea:(ModelAreaDetail *)model;
@end

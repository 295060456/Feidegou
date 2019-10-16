//
//  CellOrderGood.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrderList.h"
#import "ModelAreaList.h"

@interface CellOrderGood : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (void)populateData:(ModelOrderList *)model;


- (void)populateDataArea:(ModelAreaList *)model;
@end

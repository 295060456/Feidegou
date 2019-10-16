//
//  CellOrderButtones.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelOrderList.h"
#import "ModelAreaList.h"

@interface CellOrderButtones : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;

//- (void)populateData:(ModelOrderList *)model;
//- (void)populateDataArea:(ModelAreaList *)model;
- (void)populateDataOrderList:(ModelOrderList *)model;
@end

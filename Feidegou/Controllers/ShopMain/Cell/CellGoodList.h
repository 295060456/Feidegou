//
//  CellGoodList.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelGood.h"
#import "ModelEreaExchageList.h"

@interface CellGoodList : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblExchange;
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
- (void)populateData:(ModelGood *)model;
- (void)populateDataExchage:(ModelEreaExchageList *)model;

@end

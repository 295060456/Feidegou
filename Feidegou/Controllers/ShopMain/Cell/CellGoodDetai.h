//
//  CellGoodDetai.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelEreaExchangeDetail.h"

@interface CellGoodDetai : JJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblExchange;
- (void)populateData:(NSDictionary *)dicInfo;

- (void)populateDataAreaExchange:(ModelEreaExchangeDetail *)model;
@end

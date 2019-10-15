//
//  CLCellGoods.h
//  guanggaobao
//
//  Created by 谭自强 on 16/6/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"
#import "ModelGood.h"

@interface CLCellGoods : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblExchange;
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
- (void)populateData:(ModelGood *)model;
@end

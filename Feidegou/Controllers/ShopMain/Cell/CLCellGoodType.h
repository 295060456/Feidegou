//
//  CLCellGoodType.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellGoodType : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTittle;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
- (void)populateData:(NSDictionary *)dicInfo;
@end

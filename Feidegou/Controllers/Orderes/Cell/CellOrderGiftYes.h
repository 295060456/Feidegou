//
//  CellOrderGiftYes.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellOrderGiftYes : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAttributeName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftName;
- (void)populateData:(NSDictionary *)dicInfo andAttributeName:(NSString *)strAttribute andPirce:(NSString *)strPrice andNum:(int)intNum;
@end

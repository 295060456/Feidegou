//
//  CellOrderDetailGiftYes.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrderDtail.h"

@interface CellOrderDetailGiftYes : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAttribute;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceSale;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceOld;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftName;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftNum;
@property (weak, nonatomic) IBOutlet UIView *viGift;
- (void)populateData:(NSDictionary *)dicInfo;
@end

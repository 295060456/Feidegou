//
//  CellOrderGiftNo.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellOrderGiftNo : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAttributeName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
- (void)populateData:(NSDictionary *)dicInfo andAttributeName:(NSString *)strAttribute andPirce:(NSString *)strPrice andNum:(int)intNum;
- (void)populateData:(NSDictionary *)dicInfo;
- (void)populateDataName:(NSString *)strName andPath:(NSString *)strPath andNum:(NSString *)strNum andspec_info:(NSString *)spec_info andprice:(NSString *)strprice andgift_d_coins:(NSString *)gift_d_coins;
@end

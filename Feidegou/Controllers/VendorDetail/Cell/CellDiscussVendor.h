//
//  CellDiscussVendor.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellDiscussVendor : JJTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
- (void)populataData:(NSDictionary *)dicInfo;
@end

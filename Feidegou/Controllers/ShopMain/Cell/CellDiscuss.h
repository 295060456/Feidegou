//
//  CellDiscuss.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDiscuss : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
- (void)populataData:(NSDictionary *)dicInfo;
@end

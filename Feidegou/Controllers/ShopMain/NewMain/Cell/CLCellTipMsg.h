//
//  CLCellTipMsg.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/28.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"
//#import "CBAutoScrollLabel.h"

@interface CLCellTipMsg : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgZhixun;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (assign, nonatomic) int intRow;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) NSTimer *timer;
- (void)refreshLable:(NSArray *)array;
@end

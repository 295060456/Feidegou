//
//  CellVendorGoodPic.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface CellVendorGoodPic : UITableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
- (void)populateData:(NSArray *)arrPicture andTitle:(NSDictionary *)dicInfo;

@end

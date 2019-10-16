//
//  CellPicture.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "SDCycleScrollView.h"

@interface CellPicture : JJTableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutRight;
- (void)populateData:(NSArray *)arrPicture;
@end

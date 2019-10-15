//
//  JJTableViewCell.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/17.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTableViewCell : UITableViewCell
@property (assign, nonatomic) float fWidthPre;
@property (assign, nonatomic) float fWidthEnd;
@property (assign, nonatomic) BOOL isHidden;
@property (strong, nonatomic) UIColor *colorLine;
@end

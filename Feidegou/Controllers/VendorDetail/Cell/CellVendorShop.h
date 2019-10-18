//
//  CellVendorShop.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelVendorNear.h"
#import "StarView.h"

@interface CellVendorShop : JJTableViewCell

@property (weak, nonatomic) IBOutlet UIView *viDiscount;
@property (weak, nonatomic) IBOutlet UIView *viLine;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UIView *viStar;
@property (weak, nonatomic) IBOutlet StarView *viStarNew;

- (void)populataData:(ModelVendorNear *)model;

@end

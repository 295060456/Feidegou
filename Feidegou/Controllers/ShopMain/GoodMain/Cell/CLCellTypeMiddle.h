//
//  CLCellTypeMiddle.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellTypeMiddle : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblLineUp;
@property (weak, nonatomic) IBOutlet UILabel *lblLineLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblLineDown;
@property (weak, nonatomic) IBOutlet UILabel *lblLineRight;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblTitle;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblTip;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;

@end

//
//  CLCellUpImgDownLbl.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellUpImgDownLbl : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTip;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;

@end

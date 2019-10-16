//
//  CLCellGoodNum.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/14.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellGoodNum : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIView *viNum;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblLeave;

@end

//
//  CLCellRegion.h
//  guanggaobao
//
//  Created by 谭自强 on 16/6/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellRegion : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIImageView *imgTip;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

@end

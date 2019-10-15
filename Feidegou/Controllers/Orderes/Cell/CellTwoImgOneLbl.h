//
//  CellTwoImgOneLbl.h
//  guanggaobao
//
//  Created by 谭自强 on 15/11/24.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@interface CellTwoImgOneLbl : JJTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

@end

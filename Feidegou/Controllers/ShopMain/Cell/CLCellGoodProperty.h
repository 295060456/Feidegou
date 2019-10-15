//
//  CLCellGoodProperty.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/14.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@interface CLCellGoodProperty : JJCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidth;
- (void)populateData:(NSDictionary *)dicInfo;
@end

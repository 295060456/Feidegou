//
//  CLCellGoodType.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CLCellGoodType.h"

@implementation CLCellGoodType

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(NSDictionary *)dicInfo{
    [self.lblTittle setTextNull:dicInfo[@"className"]];
    [self.imgHead setImageWebp:dicInfo[@"photoUrl"]];
//    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:dicInfo[@"photoUrl"]]
//                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]
//                           completed:^(UIImage *image,
//                                       NSError *error,
//                                       SDImageCacheType cacheType,
//                                       NSURL *imageURL) {
//       //... completion code here ...
//        NSLog(@"");
//    }];
}
@end

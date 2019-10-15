//
//  JJCollectionViewCell.m
//  guanggaobao
//
//  Created by 谭自强 on 16/6/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"

@implementation JJCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        D_NSLog(@"name is %@",[self class]);
        NSString *strClassName = NSStringFromClass([self class]);
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:strClassName owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
@end

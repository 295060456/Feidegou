//
//  UIImageView+Helper.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UIImageView+Helper.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@implementation UIImageView (Helper)

- (void)setImagePathListRectangle:(NSString *)strPath{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strPath]] placeholderImage:[UIImage imageNamed:@"img_defult_head"]];
}
- (void)setImagePathListSquare:(NSString *)strPath{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strPath]] placeholderImage:[UIImage imageNamed:@"img_defult_head"]];
}
- (void)setImagePathHead:(NSString *)strPath{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strPath]] placeholderImage:[UIImage imageNamed:@"img_defult_head"]];
    
}
- (void)setImageWebp:(NSString *)strPath{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strPath]] placeholderImage:[UIImage imageNamed:@"img_defult_head"]];
}
- (void)setImageNoHolder:(NSString *)strPath{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strPath]] placeholderImage:[UIImage imageNamed:@""]];
    
};
@end

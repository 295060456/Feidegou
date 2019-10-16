//
//  LayoutMainType.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/27.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "LayoutMainType.h"
@interface LayoutMainType()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end
@implementation LayoutMainType
- (void)prepareLayout
{
    [super prepareLayout];
    // 计算所有cell的布局属性
    self.attrsArray = [NSMutableArray array];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    D_NSLog(@"count is %lu",count);
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
}
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
- (CGSize)collectionViewContentSize{
    if ([self.strType isEqualToString:@"type"]) {
        return CGSizeMake(((self.attrsArray.count-1)/10+1)*SCREEN_WIDTH, SCREEN_WIDTH*160/720);
    }else{
        return CGSizeMake(0, 0);
    }
}
/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    if ([self.strType isEqualToString:@"m2_1"]) {
        w = SCREEN_WIDTH/2;
        h = SCREEN_WIDTH*230/720;
        x = (indexPath.row%2)*w;
        y = (indexPath.row/2)*h;
    }else if ([self.strType isEqualToString:@"m3_1"]) {
        w = SCREEN_WIDTH/3;
        h = SCREEN_WIDTH*276/720;
        x = (indexPath.row%3)*w;
        y = (indexPath.row/3)*h;
    }else if ([self.strType isEqualToString:@"m3_2"]) {
        if (indexPath.row == 0) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*248/720;
            x = 0;
            y = 0;
        }else if (indexPath.row == 1){
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*124/720;
            x = SCREEN_WIDTH/2;
            y = 0;
        }else if (indexPath.row == 2){
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*124/720;
            x = SCREEN_WIDTH/2;
            y = h;
        }
    }else if ([self.strType isEqualToString:@"m4_1"]) {
        w = SCREEN_WIDTH/4;
        h = SCREEN_WIDTH*230/720;
        x = (indexPath.row%4)*w;
        y = (indexPath.row/4)*h;
    }else if ([self.strType isEqualToString:@"m4_2"]) {
        w = SCREEN_WIDTH/2;
        h = SCREEN_WIDTH*230/720;
        x = (indexPath.row%2)*w;
        y = (indexPath.row/2)*h;
    }else if ([self.strType isEqualToString:@"m5_1"]) {
        if (indexPath.row<3) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*230/720;
            x = (indexPath.row%2)*w;
            y = (indexPath.row/2)*h;
        }else{
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row+3)%4)*w;
            y = ((indexPath.row+3)/4)*h;
        }
    }else if ([self.strType isEqualToString:@"m7_1"]) {
        if (indexPath.row<1) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*230/720;
            x = (indexPath.row%2)*w;
            y = (indexPath.row/2)*h;
        }else{
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row+1)%4)*w;
            y = ((indexPath.row+1)/4)*h;
        }
    }else if ([self.strType isEqualToString:@"m8_1"]) {
        if (indexPath.row<4) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*230/720;
            x = (indexPath.row%2)*w;
            y = (indexPath.row/2)*h;
        }else{
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row+4)%4)*w;
            y = ((indexPath.row+4)/4)*h;
        }
    }else if ([self.strType isEqualToString:@"m10_1"]) {
        if (indexPath.row<1) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*230/720;
            x = (indexPath.row%2)*w;
            y = (indexPath.row/2)*h;
        }else if (indexPath.row<3) {
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row+1)%4)*w;
            y = ((indexPath.row+1)/4)*h;
        }else if (indexPath.row<4) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row-1)%2)*w;
            y = ((indexPath.row-1)/2)*h;
        }else{
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH*230/720;
            x = ((indexPath.row+2)%4)*w;
            y = ((indexPath.row+2)/4)*h;
        }
    }else if ([self.strType isEqualToString:@"photo"]) {
        w = SCREEN_WIDTH;
        CGFloat intHeight = [[NSString stringStandardZero:self.arrTypeLayout[0][@"height"]] floatValue];
        CGFloat intWidth = [[NSString stringStandardZero:self.arrTypeLayout[0][@"width"]] floatValue];
        if (intWidth>0&&intHeight>0) {
            h = SCREEN_WIDTH*intHeight/intWidth;
        }else{
            h = SCREEN_WIDTH*76/720;
        }
        x = 0;
        y = 0;
    }else if ([self.strType isEqualToString:@"title"]) {
        w = SCREEN_WIDTH;
        h = SCREEN_WIDTH*76/720;
        x = 0;
        y = 0;
    }else if ([self.strType isEqualToString:@"zixun"]) {
        w = SCREEN_WIDTH;
        h = SCREEN_WIDTH*92/720;
        x = 0;
        y = 0;
    }else if ([self.strType isEqualToString:@"banner1"]) {
        w = SCREEN_WIDTH;
        h = SCREEN_WIDTH*164/720;
        x = 0;
        y = 0;
    }else if ([self.strType isEqualToString:@"banner"]) {
        w = SCREEN_WIDTH;
        h = SCREEN_WIDTH*324/720;
        x = 0;
        y = 0;
    }else if ([self.strType isEqualToString:@"type"]) {
        w = SCREEN_WIDTH/5;
        h = SCREEN_WIDTH*160/720;
        x = (indexPath.row/10)*SCREEN_WIDTH+(indexPath.row%5)*w;
        y = ((indexPath.row%10)/5)*h;
        D_NSLog(@"strType is %lu  [%f,%f,%f,%f]",indexPath.row,x,y,w,h);
    }
//    D_NSLog(@"strType is %@",self.strType);
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
}
@end

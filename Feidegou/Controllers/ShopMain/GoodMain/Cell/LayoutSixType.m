//
//  LayoutSixType.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "LayoutSixType.h"
/** 每一列之间的间距 top, left, bottom, right */
static const UIEdgeInsets JPDefaultInsets = {0, 0, 0, 0};
/** 默认的列数 */
static const int JPDefaultColumsCount = 3;

@interface LayoutSixType()
/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end
@implementation LayoutSixType
#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法
/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + JPDefaultInsets.bottom);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i = 0; i<JPDefaultColumsCount; i++) {
        [self.columnMaxYs addObject:@(JPDefaultInsets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w;
    CGFloat h;
    CGFloat x;
    CGFloat y;
    if (self.intgerType == 5) {
        if (indexPath.row == 0) {
            w = SCREEN_WIDTH/2;
            h = SCREEN_WIDTH/2;
        }else{
            w = SCREEN_WIDTH/4;
            h = SCREEN_WIDTH/4;
        }
        if (indexPath.row == 0) {
            x = 0;
            y = 0;
        }else if (indexPath.row == 1){
            x = SCREEN_WIDTH/2;
            y = 0;
        }else if (indexPath.row == 2){
            x = SCREEN_WIDTH*3/4;
            y = 0;
        }else if (indexPath.row == 3){
            x = SCREEN_WIDTH/2;
            y = SCREEN_WIDTH/4;
        }else{
            x = SCREEN_WIDTH*3/4;
            y = SCREEN_WIDTH/4;
        }
    }else{
        if (indexPath.row == 0||indexPath.row == 3) {
            w = SCREEN_WIDTH/3;
        }else{
            w = SCREEN_WIDTH/3;
        }
        h = SCREEN_WIDTH/3;
        if (indexPath.row == 0) {
            x = 0;
            y = 0;
        }else if (indexPath.row == 1){
            x = SCREEN_WIDTH/3;
            y = 0;
        }else if (indexPath.row == 2){
            x = SCREEN_WIDTH*2/3;
            y = 0;
        }else if (indexPath.row == 3){
            x = 0;
            y = SCREEN_WIDTH/3;
        }else if (indexPath.row == 4){
            x = SCREEN_WIDTH/3;
            y = SCREEN_WIDTH/3;
        }else{
            x = SCREEN_WIDTH*2/3;
            y = SCREEN_WIDTH/3;
        }
    }
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
}
@end

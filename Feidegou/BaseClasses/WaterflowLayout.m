//
//  WaterflowLayout.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "WaterflowLayout.h"
@interface WaterflowLayout();

@property (nonatomic, strong) NSMutableDictionary *maxYDict;/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableArray *attrsArray;/** 存放所有的布局属性 */

@end

@implementation WaterflowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.columnMargin = 0;
        self.rowMargin = 0;
        self.sectionInset = UIEdgeInsetsMake(0,
                                             0,
                                             0,
                                             0);
        self.columnsCount = 3;
    }return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
/**
 *  每次布局之前的准备
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    // 1.清空最大的Y值
    for (int i = 0; i<self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}
/**
 *  返回所有的尺寸
 */
- (CGSize)collectionViewContentSize{
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column,
                                                       NSNumber *maxY,
                                                       BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
}

/**
 *  返回indexPath这个位置Item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column,
                                                       NSNumber *maxY,
                                                       BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin)/self.columnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    
    // 更新这一列的最大Y值
    self.maxYDict[minColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

#pragma mark —— Lazyload
- (NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        self.maxYDict = NSMutableDictionary.dictionary;
    }return _maxYDict;
}

- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        self.attrsArray = NSMutableArray.array;
    }return _attrsArray;
}

@end

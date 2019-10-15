//
//  collectionLandScape.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/5/3.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "collectionLandScape.h"
@interface collectionLandScape()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end
@implementation collectionLandScape

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
    
    return CGSizeMake((self.attrsArray.count/self.intLie*2+1)*SCREEN_WIDTH, SCREEN_WIDTH*self.fHeight*2/720);
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
    w = SCREEN_WIDTH/self.intLie;
    h = SCREEN_WIDTH*self.fHeight/720;
    x = (indexPath.row/(self.intLie*2))*SCREEN_WIDTH+(indexPath.row%self.intLie)*w;
    y = ((indexPath.row%(self.intLie*2))/self.intLie)*h;
    D_NSLog(@"strType is %lu  [%f,%f,%f,%f]",indexPath.row,x,y,w,h);
    //    D_NSLog(@"strType is %@",self.strType);
    attrs.frame = CGRectMake(x, y, w, h);
    return attrs;
}
@end

//
//  WaterflowLayout.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterflowLayout;

@protocol WaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout
            heightForWidth:(CGFloat)width
               atIndexPath:(NSIndexPath *)indexPath;
@end
@interface WaterflowLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat columnMargin;/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;/** 每一行之间的间距 */
@property (nonatomic, assign) int columnsCount;/** 显示多少列 */
@property (nonatomic, assign) id<WaterflowLayoutDelegate> delegate;

@end

//
//  CellTypeMore.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/21.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellTypeMore.h"

@implementation CellTypeMore

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionType setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.collectionType setDelegate:self];
    [self.collectionType setDataSource:self];
    [self.collectionType registerClass:[CLCellUpImgLbl class] forCellWithReuseIdentifier:@"CLCellUpImgLbl"];
    self.layout = [[collectionLandScape alloc] init];
    self.collectionType.collectionViewLayout = self.layout;
    // Initialization code
}

- (void)populateData:(NSArray *)arrType
              andRow:(NSInteger)intRow
              andLie:(NSInteger)intLie{
//    self.intLie = intLie;
//    self.intRow = intRow;
    self.layout.intLie = intLie;
    self.layout.fHeight = 160;
    self.arrType = [NSMutableArray arrayWithArray:arrType];
    [self.collectionType reloadData];
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.arrType.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CLCellUpImgLbl";
    CLCellUpImgLbl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"main_name"]];
    [cell.lblTitle setAdjustsFontSizeToFitWidth:YES];
    [cell.imgUp setImagePathHead:self.arrType[indexPath.row][@"path"]];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(SCREEN_WIDTH/self.intLie,SCREEN_WIDTH/4);
//}
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegete respondsToSelector:@selector(didClickOnlyCollectionViewDictionary:andRow:)]) {
        [self.delegete didClickOnlyCollectionViewDictionary:self.arrType[indexPath.row]
                                                     andRow:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

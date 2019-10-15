//
//  CellImageMore.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/31.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellImageMore.h"

@implementation CellImageMore

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionImage registerClass:[CLCellOneImage class] forCellWithReuseIdentifier:@"CLCellOneImage"];
    [self.collectionImage setDelegate:self];
    [self.collectionImage setDataSource:self];
    // Initialization code
}

- (void)populataData:(NSArray *)array{
    self.arrImage = [NSMutableArray arrayWithArray:array];
    [self.collectionImage reloadData];
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrImage.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellOneImage";
    CLCellOneImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    D_NSLog(@"image is %@",self.arrImage[indexPath.row]);
    [cell.imgContent setImagePathListSquare:self.arrImage[indexPath.row]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70,70);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

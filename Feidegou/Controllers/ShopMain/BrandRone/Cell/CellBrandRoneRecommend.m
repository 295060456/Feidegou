//
//  CellBrandRoneRecommend.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/3.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellBrandRoneRecommend.h"
#import "CLCellRecommend.h"
@interface CellBrandRoneRecommend()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *array;
@end
@implementation CellBrandRoneRecommend

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerClass:[CLCellRecommend class] forCellWithReuseIdentifier:@"CLCellRecommend"];
    [self.collectionView.layer setBorderWidth:0.5];
    [self.collectionView.layer setBorderColor:ColorGary.CGColor];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    // Initialization code
}

- (void)populataData:(NSArray *)array{
    self.array = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellRecommend";
    CLCellRecommend *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.imgHead setImagePathListSquare:self.array[indexPath.row][@"icon"]];
    [cell.lblName setTextNull:self.array[indexPath.row][@"name"]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 40)/3,100);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegete respondsToSelector:@selector(didSelectedBrandDictionary:)]) {
        [self.delegete didSelectedBrandDictionary:self.array[indexPath.row]];
    }
}

@end

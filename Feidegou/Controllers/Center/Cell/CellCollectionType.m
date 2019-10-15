//
//  CellCollectionType.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellCollectionType.h"
#import "CLCellCenterType.h"

@implementation CellCollectionType

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collcectionView setDelegate:self];
    [self.collcectionView setDataSource:self];
    [self.collcectionView registerClass:[CLCellCenterType class] forCellWithReuseIdentifier:@"CLCellCenterType"];
    // Initialization code
}
- (void)populateDataArray:(NSArray *)array andTitle:(NSString *)strTitle andButtonName:(NSString *)strButtonName andIndexPath:(NSIndexPath *)indexPah{
    [self.lblTitle setTextNull:strTitle];
    [self.btnMore removeTarget:self action:@selector(clickButtonHeader:) forControlEvents:UIControlEventTouchUpInside];
    if ([NSString isNullString:strButtonName]) {
        [self.btnMore setHidden:YES];
    }else{
        [self.btnMore setHidden:NO];
        [self.btnMore setTitle:strButtonName forState:UIControlStateNormal];
        [self.btnMore addTarget:self action:@selector(clickButtonHeader:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.arrType = [NSMutableArray arrayWithArray:array];
    [self.collcectionView reloadData];
    self.indxPath = indexPah;
}
- (void)clickButtonHeader:(UIButton *)sender{
    if ([_delegete respondsToSelector:@selector(didClickCollectionViewHeaderSection:)]) {
        [self.delegete didClickCollectionViewHeaderSection:self.indxPath.section];
    }
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrType.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellCenterType";
    CLCellCenterType *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dictionary = self.arrType[indexPath.row];
    [cell.lblTitle setText:dictionary[@"name"]];
    [cell.lblTip setText:dictionary[@"tip"]];
    [cell.imgHEad setImage:ImageNamed(dictionary[@"image"])];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrType.count == 1) {
        return CGSizeMake(SCREEN_WIDTH,60);
    }
    return CGSizeMake(SCREEN_WIDTH/2,60);
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
    if ([_delegete respondsToSelector:@selector(didClickCollectionViewSection:andRow:)]) {
        [self.delegete didClickCollectionViewSection:self.indxPath.section andRow:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

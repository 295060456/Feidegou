//
//  CellSixType.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellSixType.h"
#import "CLCellTypeMiddle.h"
#import "CLCellTypeSmall.h"
#import "LayoutSixType.h"
@interface CellSixType()

@end
@implementation CellSixType

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[CLCellTypeMiddle class] forCellWithReuseIdentifier:@"CLCellTypeMiddle"];
    [self.collectionView registerClass:[CLCellTypeSmall class] forCellWithReuseIdentifier:@"CLCellTypeSmall"];
    LayoutSixType *layout = [[LayoutSixType alloc] init];
    layout.intgerType = 6;
    self.collectionView.collectionViewLayout = layout;
    // Initialization code
}
- (void)populateData:(NSArray *)arrType andRow:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.arrType = [NSMutableArray arrayWithArray:arrType];
    [self.collectionView reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrType.count>6) {
        return 6;
    }
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
    if (indexPath.row == 0||indexPath.row == 3) {
        static NSString *identifier = @"CLCellTypeMiddle";
        CLCellTypeMiddle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"main_name"]];
        [cell.lblTip setTextNull:self.arrType[indexPath.row][@"vice_name"]];
        [cell.imgType setImagePathHead:self.arrType[indexPath.row][@"path"]];
        [cell.lblTitle setTextColor:[NSString getColor:self.arrType[indexPath.row][@"color"]]];
        return cell;
    }
    static NSString *identifier = @"CLCellTypeSmall";
    CLCellTypeSmall *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"main_name"]];
    [cell.lblTip setTextNull:self.arrType[indexPath.row][@"vice_name"]];
    [cell.imgType setImagePathHead:self.arrType[indexPath.row][@"path"]];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0||indexPath.row == 3) {
        D_NSLog(@"w is %f,h is %f",SCREEN_WIDTH/2,SCREEN_WIDTH/4);
        return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/4);
    }
    D_NSLog(@"w is %f,h is %f",SCREEN_WIDTH/4,SCREEN_WIDTH/4);
    return CGSizeMake(SCREEN_WIDTH/4,SCREEN_WIDTH/4);
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
    if ([self.delegete respondsToSelector:@selector(didClickOnlyCollectionViewTypeSixDictionary:andIndexPath:)]) {
        [self.delegete didClickOnlyCollectionViewTypeSixDictionary:self.arrType[indexPath.row] andIndexPath:indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

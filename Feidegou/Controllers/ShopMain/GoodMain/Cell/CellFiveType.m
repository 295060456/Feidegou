//
//  CellFiveType.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellFiveType.h"
#import "CLCellTypeBig.h"
#import "CLCellTypeSmall.h"
#import "LayoutSixType.h"

@implementation CellFiveType

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblTitle setTextColor:ColorGary];
    NSString *string = @"热门专题  太热门啦，要挤爆了";
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:string];
    [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} range:NSMakeRange(4,string.length-4)];
    [atrString addAttributes:@{NSForegroundColorAttributeName:ColorGary} range:NSMakeRange(4,string.length-4)];
    [atrString addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(0,2)];
    [atrString addAttributes:@{NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(2,2)];
    [self.lblTitle setAttributedText:atrString];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[CLCellTypeBig class] forCellWithReuseIdentifier:@"CLCellTypeBig"];
    [self.collectionView registerClass:[CLCellTypeSmall class] forCellWithReuseIdentifier:@"CLCellTypeSmall"];
    LayoutSixType *layout = [[LayoutSixType alloc] init];
    layout.intgerType = 5;
    self.collectionView.collectionViewLayout = layout;
    // Initialization code
}

- (void)populateData:(NSArray *)arrType andRow:(NSIndexPath *)indexPath{
    [self.lblTitle setHidden:!arrType.count];
    self.indexPath = indexPath;
    self.arrType = [NSMutableArray arrayWithArray:arrType];
    [self.collectionView reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrType.count>5) {
        return 5;
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
    static NSString *identifier = @"CLCellTypeSmall";
    CLCellTypeSmall *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"main_name"]];
    [cell.lblTip setTextNull:self.arrType[indexPath.row][@"vice_name"]];
    [cell.imgType setImagePathHead:self.arrType[indexPath.row][@"path"]];
    [cell.lblTitle setTextColor:[NSString getColor:self.arrType[indexPath.row][@"color"]]];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        D_NSLog(@"w is %f,h is %f",SCREEN_WIDTH/2,SCREEN_WIDTH/4);
        return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/2);
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
    if ([self.delegete respondsToSelector:@selector(didClickOnlyCollectionViewTypeFiveDictionary:andIndexPath:)]) {
        [self.delegete didClickOnlyCollectionViewTypeFiveDictionary:self.arrType[indexPath.row] andIndexPath:indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

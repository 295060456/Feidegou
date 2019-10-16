//
//  CellCollection.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellCollection.h"
#import "CLCellUpImgDownLbl.h"

@implementation CellCollection

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[CLCellUpImgDownLbl class] forCellWithReuseIdentifier:@"CLCellUpImgDownLbl"];
    // Initialization code
}

- (void)populateData:(NSIndexPath *)indexPath andModel:(ModelCenter *)model{
    self.arrType = [NSMutableArray array];
    NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:@"img_center_dfk" forKey:@"image"];
    [dic0 setObject:@"待付款" forKey:@"name"];
    [dic0 setObject:[NSString stringStandard:model.waitPay] forKey:@"num"];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"img_center_dfh" forKey:@"image"];
    [dic1 setObject:@"待发货" forKey:@"name"];
    [dic1 setObject:[NSString stringStandard:model.waitShip] forKey:@"num"];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"img_center_dsh" forKey:@"image"];
    [dic2 setObject:@"待收货" forKey:@"name"];
    [dic2 setObject:[NSString stringStandard:model.waitConfirm] forKey:@"num"];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"img_center_dpj" forKey:@"image"];
    [dic3 setObject:@"待评价" forKey:@"name"];
    [dic3 setObject:[NSString stringStandard:model.waitEvaluate] forKey:@"num"];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"img_center_th" forKey:@"image"];
    [dic4 setObject:@"退款售后" forKey:@"name"];
    [dic4 setObject:[NSString stringStandard:model.refundNo] forKey:@"num"];
    [self.arrType addObject:dic0];
    [self.arrType addObject:dic1];
    [self.arrType addObject:dic2];
    [self.arrType addObject:dic3];
    [self.arrType addObject:dic4];
    [self.collectionView reloadData];
    self.indxPath = indexPath;
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
    static NSString *identifier = @"CLCellUpImgDownLbl";
    CLCellUpImgDownLbl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dictionary = self.arrType[indexPath.row];
    [cell.lblType setText:dictionary[@"name"]];
    [cell.imgTip setImage:ImageNamed(dictionary[@"image"])];
    [cell.lblNum setText:dictionary[@"num"]];
    [cell.lblNum setHidden:![dictionary[@"num"] intValue]];
    
    if ([dictionary[@"num"] intValue]<10) {
        cell.constraintWidth.constant = 15;
    }else if ([dictionary[@"num"] intValue]<100) {
        cell.constraintWidth.constant = 20;
    }else{
        cell.constraintWidth.constant = 25;
        [cell.lblNum setText:@"99+"];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/5,CGRectGetHeight(self.frame));
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,
                            0,
                            0,
                            0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegete respondsToSelector:@selector(didClickOnlyCollectionViewIndexPath:andRow:)]) {
        [self.delegete didClickOnlyCollectionViewIndexPath:self.indxPath andRow:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

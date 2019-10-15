//
//  CellGoodMain.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellGoodMain.h"

@implementation CellGoodMain

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collctionView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.collctionView setDelegate:self];
    [self.collctionView setDataSource:self];
    [self.collctionView registerClass:[CLCellGoods class] forCellWithReuseIdentifier:@"CLCellGoods"];
    // Initialization code
}

- (void)populateData:(NSArray *)arrGood andRow:(NSInteger)intRow{
    self.intRow = intRow;
    self.arrGood = [NSMutableArray arrayWithArray:arrGood];
    [self.imgTip setHidden:!self.arrGood.count];
    [self.collctionView reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrGood.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelGood *model = self.arrGood[indexPath.row];
    static NSString *identifier = @"CLCellGoods";
    CLCellGoods *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    [cell.lblTitle setTextNull:model.goods_name];
//    [cell.lblPrice setTextGoodPrice:model.store_price andDB:model.gift_d_coins];
//    [cell.lblExchange setText:StringFormat(@"%@人付款",[NSString stringStandardZero:model.goods_salenum])];
//    [cell.imgGoods setImagePathList:model.path];
//    int intLeave = [model.goods_inventory intValue];
//    if (intLeave<10) {
//        [cell.lblLeave setText:StringFormat(@"仅剩%d件",intLeave)];
//        [cell.lblLeave setHidden:NO];
//    }else{
//        [cell.lblLeave setHidden:YES];
//    }
    [cell populateData:model];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/2+110);
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
    if ([self.delegete respondsToSelector:@selector(didClickOnlyCollectionViewModel:andRow:)]) {
        [self.delegete didClickOnlyCollectionViewModel:self.arrGood[indexPath.row] andRow:self.intRow];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

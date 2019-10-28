//
//  CellVendorGoodType.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/5.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGoodType.h"
#import "CLCellGoodProperty.h"
#import "ReusableViewProperty.h"

@implementation CellVendorGoodType

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[CLCellGoodProperty class] forCellWithReuseIdentifier:@"CLCellGoodProperty"];
    [self.collectionView registerClass:[ReusableViewProperty class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty"];
    // Initialization code
}
- (void)populateDataArray:(NSArray *)array{
    self.arrSelectType = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *arrClasss = [NSArray arrayWithArray:self.arrSelectType[section][@"items"]];
    return arrClasss.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrSelectType.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"CLCellGoodProperty";
    CLCellGoodProperty *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *arrClasss = [NSArray arrayWithArray:self.arrSelectType[indexPath.section][@"items"]];
    [cell populateData:arrClasss[indexPath.row]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section<self.arrSelectType.count) {
        if (kind == UICollectionElementKindSectionHeader){
            
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty" forIndexPath:indexPath];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
            UILabel *lblLine = (UILabel *)[headerView viewWithTag:101];
            [lblLine removeFromSuperview];
            [lblHead removeFromSuperview];
            lblHead = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(headerView.frame), 20)];
            [lblHead setFont:[UIFont systemFontOfSize:15]];
            [lblHead setTextColor:ColorGary];
            [lblHead setTag:100];
            [lblHead setText:TransformString(self.arrSelectType[indexPath.section][@"name"])];
            [headerView addSubview:lblHead];
            reusableview = headerView;
            
        }
    }else{
        if (kind == UICollectionElementKindSectionHeader){
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty" forIndexPath:indexPath];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
            UILabel *lblLine = (UILabel *)[headerView viewWithTag:101];
            [lblLine removeFromSuperview];
            [lblHead removeFromSuperview];
            lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headerView.frame), 0.5)];
            [lblLine setFont:[UIFont systemFontOfSize:15]];
            [lblLine setBackgroundColor:ColorLine];
            [lblLine setTag:101];
            [headerView addSubview:lblLine];
            reusableview = headerView;
        }
    }
    return reusableview;
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 30);
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strClass = self.arrSelectType[indexPath.section][@"items"][indexPath.row][@"value"];
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strClass andWidth:200 andFont:15].width+20;
    return CGSizeMake(fWidth,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectedItemAtIndexPath:indexPath];
}
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<self.arrSelectType.count) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[indexPath.section][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                BOOL select = [dictinary[@"select"] boolValue];
                
                if (i == indexPath.row) {
                    //                当以前未被选中时置1否则不管；
                    if (!select) {
                        [dictinary setObject:@"1" forKey:@"select"];
                        [self isSelectedAll];
                    }else{
                        return;
                    }
                }else{
                    //                当不等于选中的row全部置0
                    [dictinary setObject:@"0" forKey:@"select"];
                    [self isSelectedAll];
                }
                [array replaceObjectAtIndex:i withObject:dictinary];
            }
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:array forKey:@"items"];
        [dic setObject:self.arrSelectType[indexPath.section][@"name"] forKey:@"name"];
        [self.arrSelectType replaceObjectAtIndex:indexPath.section withObject:dic];
        [self.collectionView reloadData];
        [self requestNum];
    }
}
- (BOOL)isSelectedAll{
    BOOL selectedAll = YES;
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            BOOL selectSection = NO;;
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    selectSection = YES;
                }
            }
            if (!selectSection) {
                return NO;
            }
        }
    }
    return selectedAll;
}
- (void)requestNum{
    if ([self.delegete respondsToSelector:@selector(didClickCollectionViewSectionDetail:andGoodsspecpropertyId:andGoodsspecpropertyValueAndName:andIsSelectAll:)]) {
        [self.delegete didClickCollectionViewSectionDetail:self.arrSelectType andGoodsspecpropertyId:[self fetchStringGoodsspecpropertyId] andGoodsspecpropertyValueAndName:[self fetchStringGoodsspecpropertyValueAndName] andIsSelectAll:[self isSelectedAll]];
    }
    
//    if ([self isSelectedAll] && self.arrSelectType.count>0) {
//        NSString *strGoodsspecpropertyId = [self fetchStringGoodsspecpropertyId];
//        D_NSLog(@"已全部选择完毕，可以请求库存%@",strGoodsspecpropertyId);
//        __weak GoodDetialAllController *myself = self;
//        [myself.disposableGoodNum dispose];
//        myself.disposableGoodNum = [[[JJHttpClient new] requestShopGoodGoodNumGoodsspecpropertyId:strGoodsspecpropertyId andGoodsId:[NSString stringStandard:self.strGood_id]] subscribeNext:^(NSDictionary* dictionary) {
//            D_NSLog(@"msg is %@",dictionary[@"msg"]);
//            myself.strGoodPrice = dictionary[@"store_price"];
//            myself.strGoodNum = dictionary[@"goods_inventory"];
//            [myself.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:myself.strGoodPrice])];
//            [myself.collectionSelectType reloadData];
//        }error:^(NSError *error) {
//            [myself failedRequestException:enum_exception_timeout];
//            myself.disposableGoodNum = nil;
//        }completed:^{
//            myself.disposableGoodNum = nil;
//        }];
//        
//    }else{
//        D_NSLog(@"未全部选择完毕，不需请求库存");
//    }
}
- (NSString *)fetchStringGoodsspecpropertyId{
    NSString *strAttribut = @"";
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    strAttribut = StringFormat(@"%@%@_",strAttribut,dictinary[@"goodsspecpropertyId"]);
                }
            }
        }
    }
    return strAttribut;
}
- (NSString *)fetchStringGoodsspecpropertyValueAndName{
    NSString *strAttribut = @"";
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        NSString *strName = self.arrSelectType[i][@"name"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    if (![NSString isNullString:strAttribut]) {
                        strAttribut = StringFormat(@"%@ ",strAttribut);
                    }
                    strAttribut = StringFormat(@"%@%@:%@",strAttribut,strName,dictinary[@"value"]);
                }
            }
        }
    }
    return strAttribut;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

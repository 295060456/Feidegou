//
//  CellMainType.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/27.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellMainType.h"
#import "CLCellTypeSmall.h"
#import "CLCellTypeBig.h"
#import "CLCellUpImgLbl.h"
#import "CLCellOneImage.h"
#import "CLCellTitle.h"
#import "CLCellBanner.h"
#import "LayoutSixType.h"
#import "CLCellTipMsg.h"
@interface CellMainType ()<DidClickDelegeteCollectionViewBanner>


@end
@implementation CellMainType

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.imgBack setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[CLCellTipMsg class] forCellWithReuseIdentifier:@"CLCellTipMsg"];
    [self.collectionView registerClass:[CLCellOneImage class] forCellWithReuseIdentifier:@"CLCellOneImage"];
    [self.collectionView registerClass:[CLCellTitle class] forCellWithReuseIdentifier:@"CLCellTitle"];
    [self.collectionView registerClass:[CLCellTypeSmall class] forCellWithReuseIdentifier:@"CLCellTypeSmall"];
    [self.collectionView registerClass:[CLCellTypeBig class] forCellWithReuseIdentifier:@"CLCellTypeBig"];
    [self.collectionView registerClass:[CLCellUpImgLbl class] forCellWithReuseIdentifier:@"CLCellUpImgLbl"];
    [self.collectionView registerClass:[CLCellBanner class] forCellWithReuseIdentifier:@"CLCellBanner"];
    self.layout = [[LayoutMainType alloc] init];
    self.collectionView.collectionViewLayout = self.layout;
    // Initialization code
}

- (void)populateData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath{
    self.strType = TransformString(array[indexPath.row][@"type"]);
    [self.imgBack setImageNoHolder:array[indexPath.row][@"background"]];
    D_NSLog(@"background is %@",array[indexPath.row][@"background"]);
    [self.imgBack setContentMode:UIViewContentModeScaleAspectFill];
    NSArray *arrayMiddle = array[indexPath.row][@"modeList"];
    if ([array isKindOfClass:[NSArray class]]) {
        self.arrType = [NSMutableArray arrayWithArray:arrayMiddle];
    }
    self.layout.strType = self.strType;
    self.layout.arrTypeLayout = arrayMiddle;
    [self.collectionView reloadData];
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
    
    if ([self.strType isEqualToString:@"type"]) {
        static NSString *identifier = @"CLCellUpImgLbl";
        CLCellUpImgLbl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"title"]];
        [cell.lblTitle setAdjustsFontSizeToFitWidth:YES];
        [cell.lblTitle setTextColor:[NSString getColor:self.arrType[indexPath.row][@"titleColor"] andMoren:ColorGary]];
        [cell.imgUp setImageNoHolder:self.arrType[indexPath.row][@"picture"]];
        return cell;
    }else if ([self.strType isEqualToString:@"m3_1"]||[self.strType isEqualToString:@"m3_2"]||[self.strType isEqualToString:@"photo"]) {
        static NSString *identifier = @"CLCellOneImage";
        CLCellOneImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setBackgroundColor:ColorBackground];
        [cell.imgContent setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imgContent setImageNoHolder:self.arrType[indexPath.row][@"picture"]];
        return cell;
    }else if ([self.strType isEqualToString:@"zixun"]) {
        static NSString *identifier = @"CLCellTipMsg";
        CLCellTipMsg *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        [cell refreshLable:self.arrType];
        return cell;
    }else if ([self.strType isEqualToString:@"banner"]||[self.strType isEqualToString:@"banner1"]) {
        static NSString *identifier = @"CLCellBanner";
        CLCellBanner *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setBackgroundColor:ColorBackground];
        [cell populateData:self.arrType];
        if ([self.strType isEqualToString:@"banner"]) {
            cell.layoutConstraintPre.constant = 0;
            cell.layoutConstraintEnd.constant = 0;
            cell.layoutConstrainUp.constant = 0;
            [cell.cycleScrollView setAutoScrollTimeInterval:5.0];
            [cell.cycleScrollView setAutoScroll:YES];
        }else{
            [cell.cycleScrollView setAutoScroll:NO];
            cell.layoutConstraintPre.constant = 10;
            cell.layoutConstraintEnd.constant = 10;
            cell.layoutConstrainUp.constant = 10;
        }
        [cell setDelegeteBanner:self];
        return cell;
    }else if ([self.strType isEqualToString:@"title"]) {
        static NSString *identifier = @"CLCellTitle";
        CLCellTitle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        [cell.lblTitle setFont:[UIFont fontWithName:@"bold" size:15.0]];
        [cell.lblTitle setTextColor:ColorHeader];
        NSString *strTitle = self.arrType[indexPath.row][@"title"];
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:strTitle];
        if (strTitle.length>2) {
            [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(2, strTitle.length-2)];
        }
        [cell.lblTitle setAttributedText:atrStringPrice];
        
        [cell.lblTitleSamll setTextNull:self.arrType[indexPath.row][@"subTitle"]];
        return cell;
    }else if ([self.strType isEqualToString:@"m2_1"]||[self.strType isEqualToString:@"m4_2"]||([self.strType isEqualToString:@"m5_1"]&&indexPath.row<3)||([self.strType isEqualToString:@"m7_1"]&&indexPath.row<1)||([self.strType isEqualToString:@"m8_1"]&&indexPath.row<4)||([self.strType isEqualToString:@"m10_1"]&&(indexPath.row==0||indexPath.row == 3))) {
        static NSString *identifier = @"CLCellTypeBig";
        CLCellTypeBig *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"title"]];
        [cell.lblTitle setTextColor:[NSString getColor:self.arrType[indexPath.row][@"titleColor"] andMoren:ColorBlack]];
        [cell.lblTip setTextNull:self.arrType[indexPath.row][@"subTitle"]];
        [cell.imgType setImageNoHolder:self.arrType[indexPath.row][@"picture"]];
        double doubleWidth = [[NSString stringStandardZero:self.arrType[indexPath.row][@"subWidth"]] doubleValue];
        double doubleHeight = [[NSString stringStandardZero:self.arrType[indexPath.row][@"subHeight"]] doubleValue];
        if (doubleWidth>0&&doubleHeight>0) {
            cell.layoutWidth.constant = 13*doubleWidth/doubleHeight;
        }
        [cell.imgSmall setImageNoHolder:self.arrType[indexPath.row][@"subPicture"]];
        [cell.imgType setContentMode:UIViewContentModeScaleAspectFit];
        return cell;
    }
    
    static NSString *identifier = @"CLCellTypeSmall";
    CLCellTypeSmall *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.lblTitle setTextNull:self.arrType[indexPath.row][@"title"]];
    [cell.lblTitle setTextColor:[NSString getColor:self.arrType[indexPath.row][@"titleColor"] andMoren:ColorBlack]];
    [cell.lblTip setTextNull:self.arrType[indexPath.row][@"subTitle"]];
    [cell.imgType setImageNoHolder:self.arrType[indexPath.row][@"picture"]];
    double doubleWidth = [[NSString stringStandardZero:self.arrType[indexPath.row][@"subWidth"]] doubleValue];
    double doubleHeight = [[NSString stringStandardZero:self.arrType[indexPath.row][@"subHeight"]] doubleValue];
    if (doubleWidth>0&&doubleHeight>0) {
        cell.layoutWidht.constant = 13*doubleWidth/doubleHeight;
    }
    [cell.imgSmall setImageNoHolder:self.arrType[indexPath.row][@"subPicture"]];
    return cell;
}
- (void)didClickDelegeteCollectionViewBannerDictionary:(NSDictionary *)dicInfo{
    if ([self.delegete respondsToSelector:@selector(didClickDelegeteCollectionViewMainTypeDictionary:)]) {
        [self.delegete didClickDelegeteCollectionViewMainTypeDictionary:dicInfo];
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
////    if (indexPath.row == 0||indexPath.row == 3) {
////        D_NSLog(@"w is %f,h is %f",SCREEN_WIDTH/2,SCREEN_WIDTH/4);
////        return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/4);
////    }
////    D_NSLog(@"w is %f,h is %f",SCREEN_WIDTH/4,SCREEN_WIDTH/4);
//    return CGSizeMake(1,1);
//}
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegete respondsToSelector:@selector(didClickDelegeteCollectionViewMainTypeDictionary:)]) {
        [self.delegete didClickDelegeteCollectionViewMainTypeDictionary:self.arrType[indexPath.row]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

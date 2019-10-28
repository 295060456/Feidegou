//
//  CellVendorGoodType.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/5.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DidClickCollectionViewDelegete<NSObject>
@optional
- (void)didClickCollectionViewSectionDetail:(NSArray *)arrAttribute andGoodsspecpropertyId:(NSString *)GoodsspecpropertyId andGoodsspecpropertyValueAndName:(NSString *)GoodsspecpropertyValueAndName andIsSelectAll:(BOOL)isSelected;
@end

@interface CellVendorGoodType : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) id<DidClickCollectionViewDelegete> delegete;
@property (strong, nonatomic) NSMutableArray *arrSelectType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)populateDataArray:(NSArray *)array;

@end

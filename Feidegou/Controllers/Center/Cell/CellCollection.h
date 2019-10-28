//
//  CellCollection.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelCenter.h"

@protocol DidClickDelegeteOnlyCollectionView<NSObject>
@optional
- (void)didClickOnlyCollectionViewIndexPath:(NSIndexPath *)indexPath andRow:(NSInteger)row;
@end
@interface CellCollection : JJTableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (assign, nonatomic) id<DidClickDelegeteOnlyCollectionView> delegete;
@property (strong, nonatomic) NSIndexPath *indxPath;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)populateData:(NSIndexPath *)indexPath andModel:(ModelCenter *)model;
@end

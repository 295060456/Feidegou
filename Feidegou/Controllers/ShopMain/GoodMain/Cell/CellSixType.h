//
//  CellSixType.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DidClickDelegeteCollectionViewTypeSix<NSObject>
@optional
- (void)didClickOnlyCollectionViewTypeSixDictionary:(NSDictionary *)model andIndexPath:(NSIndexPath *)indexPath;
@end
@interface CellSixType : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (assign, nonatomic) id<DidClickDelegeteCollectionViewTypeSix> delegete;
@property (assign, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)populateData:(NSArray *)arrType andRow:(NSIndexPath *)indexPath;
@end

//
//  CellFiveType.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DidClickDelegeteCollectionViewTypeFive<NSObject>
@optional
- (void)didClickOnlyCollectionViewTypeFiveDictionary:(NSDictionary *)model andIndexPath:(NSIndexPath *)indexPath;
@end
@interface CellFiveType : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (assign, nonatomic) id<DidClickDelegeteCollectionViewTypeFive> delegete;
@property (assign, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)populateData:(NSArray *)arrType andRow:(NSIndexPath *)indexPath;
@end

//
//  CellTypeMore.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/21.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "CLCellUpImgLbl.h"
#import "collectionLandScape.h"

@protocol DidClickDelegeteCollectionViewType<NSObject>

@optional
- (void)didClickOnlyCollectionViewDictionary:(NSDictionary *)model
                                      andRow:(NSInteger)row;
@end

@interface CellTypeMore : JJTableViewCell
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (assign, nonatomic) id<DidClickDelegeteCollectionViewType> delegete;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionType;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (strong, nonatomic) collectionLandScape *layout;
//@property (assign, nonatomic) NSInteger intRow;
//@property (assign, nonatomic) NSInteger intLie;
- (void)populateData:(NSArray *)arrType
              andRow:(NSInteger)intRow
              andLie:(NSInteger)intLie;

@end

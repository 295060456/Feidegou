//
//  CellGoodMain.h
//  Vendor
//
//  Created by 谭自强 on 2017/3/6.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCellGoods.h"

@protocol DidClickDelegeteOnlyCollectionView<NSObject>
@optional
- (void)didClickOnlyCollectionViewModel:(ModelGood *)model andRow:(NSInteger)row;
@end
@interface CellGoodMain : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (assign, nonatomic) id<DidClickDelegeteOnlyCollectionView> delegete;
@property (weak, nonatomic) IBOutlet UIImageView *imgTip;
@property (assign, nonatomic) NSInteger intRow;
@property (weak, nonatomic) IBOutlet UICollectionView *collctionView;
@property (strong, nonatomic) NSMutableArray *arrGood;
- (void)populateData:(NSArray *)arrGood andRow:(NSInteger)intRow;
@end

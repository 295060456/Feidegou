//
//  CellBrandRoneRecommend.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/3.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCellRecommend.h"
@protocol BrandCollectionView<NSObject>

- (void)didSelectedBrandDictionary:(NSDictionary *)dictionary;
@end
@interface CellBrandRoneRecommend : UITableViewCell

@property (strong, nonatomic) id<BrandCollectionView> delegete;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)populataData:(NSArray *)array;
@end

//
//  CellImageMore.h
//  Vendor
//
//  Created by 谭自强 on 2017/3/31.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCellOneImage.h"

@interface CellImageMore : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (strong, nonatomic) NSArray *arrImage;
- (void)populataData:(NSArray *)array;

@end

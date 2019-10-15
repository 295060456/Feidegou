//
//  CellMainType.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/27.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutMainType.h"
@protocol DidClickDelegeteCollectionViewMainType<NSObject>
@optional
- (void)didClickDelegeteCollectionViewMainTypeDictionary:(NSDictionary *)dicInfo;
@end
@interface CellMainType : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) id<DidClickDelegeteCollectionViewMainType> delegete;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (strong, nonatomic) NSString *strType;
@property (strong, nonatomic) LayoutMainType *layout;
- (void)populateData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath;
@end

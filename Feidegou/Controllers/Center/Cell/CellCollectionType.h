//
//  CellCollectionType.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonImgLbl.h"
@protocol DidClickCollectionViewDelegete<NSObject>
@optional
- (void)didClickCollectionViewSection:(NSInteger)section andRow:(NSInteger)row;
- (void)didClickCollectionViewHeaderSection:(NSInteger)section;
@end

@interface CellCollectionType : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrType;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collcectionView;
@property (weak, nonatomic) IBOutlet ButtonImgLbl *btnMore;
@property (assign, nonatomic) id<DidClickCollectionViewDelegete> delegete;
@property (strong, nonatomic) NSIndexPath *indxPath;
- (void)populateDataArray:(NSArray *)array andTitle:(NSString *)strTitle andButtonName:(NSString *)strButtonName andIndexPath:(NSIndexPath *)indexPah;
@end

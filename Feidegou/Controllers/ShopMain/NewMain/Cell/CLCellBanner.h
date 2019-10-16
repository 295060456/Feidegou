//
//  CLCellBanner.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/27.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJCollectionViewCell.h"
#import "SDCycleScrollView.h"

@protocol DidClickDelegeteCollectionViewBanner<NSObject>
@optional
- (void)didClickDelegeteCollectionViewBannerDictionary:(NSDictionary *)dicInfo;
@end
@interface CLCellBanner : JJCollectionViewCell<SDCycleScrollViewDelegate>
@property (assign, nonatomic) id<DidClickDelegeteCollectionViewBanner> delegeteBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintEnd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstrainUp;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSMutableArray *array;
- (void)populateData:(NSArray *)arrPicture;

@end

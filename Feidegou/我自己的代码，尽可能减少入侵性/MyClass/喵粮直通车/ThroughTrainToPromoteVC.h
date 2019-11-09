//
//  ThroughTrainToPromoteVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "StallListVC.h"

NS_ASSUME_NONNULL_BEGIN
@interface ThroughTrainToPromoteTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;
-(void)actionBlock:(DataBlock)block;

@end

@interface ThroughTrainToPromoteVC : BaseVC

@property(nonatomic,copy)__block NSString *quantity;
@property(nonatomic,strong)NSMutableArray <ThroughTrainToPromoteModel *>*dataMutArr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END

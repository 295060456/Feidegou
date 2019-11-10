//
//  StallListVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface StallListTBVCell :TBVCell_style_01

//@property(nonatomic,strong)CountdownView *countdownView;
@property(nonatomic,strong)UIImageView *imgView;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

//-(void)actionAnimationFinishedBlock:(ActionBlock)block;
//-(void)actionTapBlock:(ActionBlock)block;

@end

@interface StallListVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <StallListModel *>*dataMutArr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

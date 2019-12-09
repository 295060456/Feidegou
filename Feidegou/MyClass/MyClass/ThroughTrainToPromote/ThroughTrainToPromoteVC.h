//
//  ThroughTrainToPromoteVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "ThroughTrainListVC.h"

NS_ASSUME_NONNULL_BEGIN
@interface ThroughTrainToPromoteTBVCell : TBVCell_style_01

@property(nonatomic,copy)NSString *dataStr;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;
-(void)actionBlock:(DataBlock)block;

@end
//
@interface ThroughTrainToPromoteVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *openBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *goOnBtn;
@property(nonatomic,strong)UIButton *suspendBtn;
@property(nonatomic,copy)__block NSString *quantity;
@property(nonatomic,assign)__block BOOL train_stop;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END

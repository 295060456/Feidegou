//
//  LookUpContactWayVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/26.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

/*
 业务逻辑：卖家进看自己的联系方式；买家进看上家的联系方式
 */

NS_ASSUME_NONNULL_BEGIN
 
@interface LookUpContactWayTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
-(void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface LookUpContactWayVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSString *>*contentTextMutArr;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END


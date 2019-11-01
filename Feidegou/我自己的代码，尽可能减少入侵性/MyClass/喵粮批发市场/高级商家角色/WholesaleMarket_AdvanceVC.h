//
//  WholesaleMarketVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_AdvancePopView : UIView

- (instancetype)initWithRequestParams:(id)requestParams;
-(void)actionBlock:(ActionBlock)block;
-(void)clickBlock:(DataBlock)block;

@end

@interface WholesaleMarket_AdvanceTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface WholesaleMarket_AdvanceVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

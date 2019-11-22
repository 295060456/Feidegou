//
//  RegisterVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;
-(void)actionBlock:(DataBlock)block;

@end

@interface RegisterVC : BaseVC

@property(nonatomic,strong)RACDisposable *disposable;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;   

@end

NS_ASSUME_NONNULL_END

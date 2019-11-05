//
//  UpLoadCancelReasonVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadCancelReasonTBVCell : TBVCell_style_01

-(void)actionPicBtnBlock:(DataBlock)block;
-(void)actionUpLoadbtnBlock:(DataBlock)block;

@end

@interface UpLoadCancelReasonVC : BaseVC

@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)__block UIImage *pic;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

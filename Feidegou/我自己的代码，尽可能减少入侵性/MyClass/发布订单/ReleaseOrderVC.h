//
//  RealeaseOrderVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/30.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseOrder_viewForHeader : ViewForHeader

@end

@interface ReleaseOrderTBVCell : TBVCell_style_01

@end

@interface ReleaseOrderVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

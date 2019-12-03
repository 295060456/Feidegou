//
//  OrderManagerTBViewForHeader.h
//  Feidegou
//
//  Created by Kite on 2019/12/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ViewForHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManagerTBViewForHeader : ViewForHeader

@property(nonatomic,strong)SearchView *searchView;

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model;
-(void)headerViewWithModel:(id _Nullable)model;
-(void)clickBlock:(DataBlock)block;
       
@end

NS_ASSUME_NONNULL_END

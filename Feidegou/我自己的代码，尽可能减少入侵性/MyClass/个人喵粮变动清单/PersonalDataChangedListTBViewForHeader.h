//
//  PersonalDataChangedListTBViewForHeader.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ViewForHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDataChangedListTBViewForHeader : ViewForHeader

+(CGFloat)headerViewHeightWithModel:(id _Nullable)model;
-(void)headerViewWithModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END

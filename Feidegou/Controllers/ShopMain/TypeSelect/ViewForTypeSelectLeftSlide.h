//
//  ViewForTypeSelectLeftSlide.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/1.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewForTypeSelect.h"

@interface ViewForTypeSelectLeftSlide : UIView

@property (strong, nonatomic) id<TypeSelectDelegete> delegete;

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array;
@end

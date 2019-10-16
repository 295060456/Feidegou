//
//  UITextField+EditChanged.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "UITextField+EditChanged.h"

@implementation UITextField (EditChanged)

static char overviewKey;

- (void)handleTextFieldControlEvent:(UIControlEvents)event
                          withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self,
                             &overviewKey,
                             block,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(callActionBlock:)
   forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end

//
//  UITextField+EditChanged.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)();

@interface UITextField (EditChanged)

/*!
 * Event事件处理
 * @param controlEvent 事件类型
 * @param action action block
 */
- (void) handleTextFieldControlEvent:(UIControlEvents)controlEvent
                           withBlock:(ActionBlock)action;

@end

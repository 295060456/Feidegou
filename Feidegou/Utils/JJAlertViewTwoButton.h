//
//  JJAlertViewTwoButton.h
//  Smartlink
//
//  Created by 谭自强 on 16/4/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJAlertViewTwoButton : NSObject
-(void)showAlertView:(UIViewController *)viewController andTitle:(NSString *)title andMessage:(NSString *)message andCancel:(NSString *)cancelButtonTitle andCanelIsRed:(BOOL)isRed andOherButton:(NSString *)otherButtonTitle andConfirm:(void (^)(void))confirm andCancel:(void (^)(void))cancle;
@end

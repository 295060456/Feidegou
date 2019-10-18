//
//  JJAlertViewOneButton.h
//  Smartlink
//
//  Created by 谭自强 on 16/4/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJAlertViewOneButton : NSObject

-(void)showAlertView:(UIViewController *)controller
            andTitle:(NSString *)title
          andMessage:(NSString *)message
           andCancel:(NSString *)cancel
       andCanelIsRed:(BOOL)isRed
             andBack:(void (^)(void))cancle;
@end

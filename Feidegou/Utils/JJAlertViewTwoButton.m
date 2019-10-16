//
//  JJAlertViewTwoButton.m
//  Smartlink
//
//  Created by 谭自强 on 16/4/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJAlertViewTwoButton.h"

typedef void (^confirm)();
typedef void (^cancle)();

@interface JJAlertViewTwoButton(){
    confirm confirmParam;
    cancle  cancleParam;
}

@end

@implementation JJAlertViewTwoButton

-(void)showAlertView:(UIViewController *)viewController
            andTitle:(NSString *)title
          andMessage:(NSString *)message
           andCancel:(NSString *)cancelButtonTitle
       andCanelIsRed:(BOOL)isRed
       andOherButton:(NSString *)otherButtonTitle
          andConfirm:(void (^)(void))confirm
           andCancel:(void (^)(void))cancle{
    confirmParam=confirm;
    cancleParam=cancle;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        if (cancelButtonTitle) {
            
            UIAlertActionStyle style = UIAlertActionStyleCancel;
            if (isRed) {
                style = UIAlertActionStyleDestructive;
            }
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                   style:style
                                                                 handler:^(UIAlertAction *action) {
                cancle();
            }];
            [alertController addAction:cancelAction];
        }
        if (otherButtonTitle) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                confirm();
            }];
            // Add the actions.
            [alertController addAction:otherAction];
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:otherButtonTitle
                                                   otherButtonTitles:cancelButtonTitle,nil];
        [TitleAlert show];
    }
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else{
        cancleParam();
    }
}

@end

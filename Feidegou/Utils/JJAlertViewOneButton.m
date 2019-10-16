//
//  JJAlertViewOneButton.m
//  Smartlink
//
//  Created by 谭自强 on 16/4/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJAlertViewOneButton.h"

typedef void (^cancle)(void);
@interface JJAlertViewOneButton(){
    cancle  cancleParam;
}
@end
@implementation JJAlertViewOneButton

-(void)showAlertView:(UIViewController *)controller
            andTitle:(NSString *)title
          andMessage:(NSString *)message
           andCancel:(NSString *)cancel
       andCanelIsRed:(BOOL)isRed
             andBack:(void (^)(void))cancle{
    cancleParam=cancle;void
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        if (cancel) {
            UIAlertActionStyle style = UIAlertActionStyleCancel;
            if (isRed) {
                style = UIAlertActionStyleDestructive;
            }
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                                   style:style
                                                                 handler:^(UIAlertAction *action) {
                cancle();
            }];
            [alertController addAction:cancelAction];
        }
        [controller presentViewController:alertController animated:YES
                               completion:nil];
    }else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:cancel
                                                   otherButtonTitles:nil];
        [TitleAlert show];
    }
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    cancleParam();
}

@end

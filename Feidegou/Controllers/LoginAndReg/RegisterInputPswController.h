//
//  RegisterInputPswController.h
//  guanggaobao
//
//  Created by 谭自强 on 15/11/19.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"

@interface RegisterInputPswController : JJBaseViewController

@property (strong, nonatomic) NSString *strPhone;
@property (strong, nonatomic) NSString *strCode;
@property (assign, nonatomic) BOOL isForgetPsw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCodeHeight;
@end

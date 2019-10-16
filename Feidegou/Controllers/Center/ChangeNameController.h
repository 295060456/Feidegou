//
//  ChangeNameController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/3/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
typedef enum {
    enum_personalInfo_phone,//电话
    enum_personalInfo_email,//邮箱
    enum_personalInfo_chongzhi//充值
}enumPersonalInfo;
@interface ChangeNameController : JJBaseViewController
@property (assign,nonatomic) enumPersonalInfo personalInfo;
@end

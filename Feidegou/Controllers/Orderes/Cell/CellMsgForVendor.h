//
//  CellMsgForVendor.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMsgForVendor : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;
@property (assign, nonatomic) NSInteger integerMost;
@end

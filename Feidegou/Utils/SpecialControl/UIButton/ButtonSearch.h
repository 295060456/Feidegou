//
//  ButtonSearch.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Joker.h"
@interface ButtonSearch : UIButton
@property (strong, nonatomic) UIImageView *imageLeft;
@property (strong, nonatomic) UILabel *lblContent;
- (void)setTitle:(NSString *)string;
@end

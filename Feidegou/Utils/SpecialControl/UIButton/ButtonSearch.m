//
//  ButtonSearch.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ButtonSearch.h"

@implementation ButtonSearch

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setAttribute];
    }return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAttribute];
}

- (void)setTitle:(NSString *)string{
    [self.lblContent setText:string];
}

- (void)setAttribute{
    self.imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
    [self.imageLeft setImage:ImageNamed(@"img_search_bai")];
    [self.imageLeft setContentMode:UIViewContentModeCenter];
    [self addSubview:self.imageLeft];
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageLeft.frame), 0, CGRectGetWidth(self.frame)-CGRectGetMaxX(self.imageLeft.frame)-10, CGRectGetHeight(self.frame))];
    [self.lblContent setTextColor:ColorGaryDark];
    [self.lblContent setFont:[UIFont systemFontOfSize:15.0]];
    [self addSubview:self.lblContent];
    
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6]];
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:3.0];
}

@end

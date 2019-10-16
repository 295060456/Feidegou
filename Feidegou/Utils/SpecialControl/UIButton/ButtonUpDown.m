//
//  ButtonUpDown.m
//  Vendor
//
//  Created by 谭自强 on 2017/3/7.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ButtonUpDown.h"
@interface ButtonUpDown()

@property (strong, nonatomic) UILabel *lblNum;

@end

@implementation ButtonUpDown

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setAttribute];
    }return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAttribute];
}

- (void)setAttribute{
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.lblNum = [[UILabel alloc] init];
    [self.lblNum setTextColor:[UIColor whiteColor]];
    [self.lblNum setBackgroundColor:ColorRed];
    [self.lblNum setFont:[UIFont systemFontOfSize:8]];
    [self.lblNum setHidden:YES];
    [self.lblNum setTextAlignment:NSTextAlignmentCenter];
    [self.lblNum setClipsToBounds:YES];
    [self addSubview:self.lblNum];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(0,
                      0.1*fHeight,
                      CGRectGetWidth(self.frame),
                      fHeight*0.5);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(0,
                      fHeight*0.7,
                      CGRectGetWidth(self.frame),
                      fHeight*0.2);
}

- (void)refreshNumber:(NSString *)strNumber{
    if ([strNumber intValue]==0) {
        [self.lblNum setHidden:YES];
    }else{
        [self.lblNum setHidden:NO];
        CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strNumber
                                                       andWidth:30
                                                        andFont:8].width+6;
        [self.lblNum setFrame:CGRectMake(CGRectGetWidth(self.frame)-fWidth-15,
                                         6,
                                         fWidth,
                                         fWidth)];
        [self.lblNum setTextNull:strNumber];
        [self.lblNum.layer setCornerRadius:fWidth/2];
    }
}

@end

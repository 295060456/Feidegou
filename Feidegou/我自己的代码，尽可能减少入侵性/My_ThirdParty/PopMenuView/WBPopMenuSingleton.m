//
//  WBPopMenuSingleton.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuSingleton.h"
#import "WBPopMenuView.h"

@interface WBPopMenuSingleton ()

@property (nonatomic, strong) WBPopMenuView * popMenuView;

@end

@implementation WBPopMenuSingleton

+ (WBPopMenuSingleton *) shareManager {
    static WBPopMenuSingleton *_PopMenuSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _PopMenuSingleton = [[WBPopMenuSingleton alloc]init];
    });
    return _PopMenuSingleton;
}

- (void)showPopMenuSelecteWithFrame:(CGRect)frame
                          menuWidth:(CGFloat)width
                                item:(NSArray *)item
                              action:(void (^)(NSInteger))action {
    @weakify(self)
    if (self.popMenuView != nil) {
        [self_weak_ hideMenu];
    }
    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    self.popMenuView = [[WBPopMenuView alloc]initWithFrame:window.bounds
                                             menuWidth:width
                                                 items:item
                                                action:^(NSInteger index) {
        @strongify(self)
        action(index);
        [self hideMenu];
                                                }];
    self.popMenuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    [window addSubview:self.popMenuView];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
        @strongify(self)
        self.popMenuView.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void) hideMenu {
    @weakify(self)
    [UIView animateWithDuration:0.15
                     animations:^{
        @strongify(self)
        self.popMenuView.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        @strongify(self)
        [self.popMenuView.tableView removeFromSuperview];
        [self.popMenuView removeFromSuperview];
        self.popMenuView.tableView = nil;
        self.popMenuView = nil;
    }];
}



@end

//
//  DefaultLoadMoreView.m
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#define HEIGHT 200
#import "DefaultLoadMoreView.h"

@interface DefaultLoadMoreView()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DefaultLoadMoreView



-(void)resetLayoutSubViews{
    
    UIScrollView *scrollView = (UIScrollView*)self.superview;
    CGFloat height = MAX(scrollView.contentSize.height, scrollView.bounds.size.height);
    self.frame = CGRectMake(0, height,self.superview.frame.size.width, HEIGHT);
}

-(void)beginRefreshing{
    
    self.messageLabel.text = @"努力加载中……";
    self.arrowImageView.hidden = YES;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
}

-(void)endRefreshing{
    
    self.messageLabel.text = @"上拉加载";
    self.arrowImageView.hidden = NO;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform=CGAffineTransformIdentity;
    }];
    
}

-(void)canEngageRefresh{
    
    self.messageLabel.text = @"松手马上加载更多";
    self.arrowImageView.hidden = NO;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform=CGAffineTransformMakeRotation(M_PI);
    }];
}

-(void)didDisengageRefresh{
    
    self.messageLabel.text = @"上拉加载";
    self.arrowImageView.hidden = NO;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform = CGAffineTransformIdentity;
    }];
    
}
-(void)dataLoadingFinished{
    
    self.messageLabel.text = @"数据加载完了";
    self.arrowImageView.hidden = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}
@end

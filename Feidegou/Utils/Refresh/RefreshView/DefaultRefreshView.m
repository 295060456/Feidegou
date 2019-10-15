//
//  DefaultRefreshView.m
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#define HEIGHT 200
#import "DefaultRefreshView.h"

@interface DefaultRefreshView()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end


@implementation DefaultRefreshView

#pragma mark - Public Methods
-(void)resetLayoutSubViews{
    
    self.frame = CGRectMake(0, -HEIGHT, self.superview.frame.size.width, HEIGHT);

}

-(void)beginRefreshing{
    
    self.messageLabel.text = @"努力加载中……";
    self.arrowImageView.hidden = YES;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
}

-(void)endRefreshing{
    
    self.messageLabel.text = @"下拉刷新";
    self.arrowImageView.hidden = NO;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform=CGAffineTransformIdentity;
    }];
    
}

-(void)canEngageRefresh{
    
    self.messageLabel.text = @"松手马上刷新";
    self.arrowImageView.hidden = NO;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform=CGAffineTransformMakeRotation(M_PI);
    }];


}

-(void)didDisengageRefresh{
    
    self.messageLabel.text = @"下拉刷新";
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform=CGAffineTransformIdentity;
    }];
    
}

@end

//
//  BaseTableView.m
//  jandaobao
//
//  Created by 谭自强 on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView()

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation BaseTableView

-(instancetype)init{
    
    if (self = [super init]) {
        [self baseData];
    }return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self baseData];
}

- (void)baseData{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.backgroundView = self.fetchBackgroundView;
}

-(UIView *)fetchBackgroundView{
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.contentMode = UIViewContentModeCenter;
    self.bgImageView.hidden = YES;
    return self.bgImageView;
}

-(void)checkNoData:(NSInteger)count{
    if (count > 0) {
        [self hideNoData];
    }else{
        [self showNoData];
    }
}

-(void)showNoData{
    NSString *imageName = @"img_tabView_nodata";
    self.bgImageView.image = [UIImage imageNamed:imageName];
    self.backgroundView.hidden = NO;
}

-(void)hideNoData{
    self.backgroundView.hidden = YES;
}

@end

//
//  RefreshControl.m
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#define ENABLE_INSET_TOP 50.0f
#define ENABLE_INSET_BOTTOM 50.0f
#define KVO_SCROLLVIEW_CONTENT_SIZE @"contentSize"
#define KVO_SCROLLVIEW_CONTENT_OFFSET @"contentOffset"

#import "RefreshControl.h"
#import "RefreshViewDelegate.h"
#import "DefaultLoadMoreView.h"
#import "DefaultRefreshView.h"

@interface RefreshControl()

@property (nonatomic,assign) RefreshState refreshState;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong) UIView<RefreshViewDelegate> *refreshView;
@property (nonatomic,strong) UIView<RefreshViewDelegate> *loadMoreView;
@property (nonatomic,assign) id<RefreshControlDelegate> delegate;

/*! 是否启用下拉刷新数据(默认启用)*/
@property (nonatomic,assign) BOOL isEnableRefresh;
/*! 是否启用上拉加载数据(默认启用)*/
@property (nonatomic,assign) BOOL isEnableLoadMore;
/*! 下拉刷新改变状态距离 */
@property (nonatomic,assign) CGFloat enableInsetTop;
/*! 上拉加载改变状态距离 */
@property (nonatomic,assign) CGFloat enableInsetBottom;
/*! 数据是否加载完成 */
@property (nonatomic,assign) BOOL isDataLoadingFinished;

@end

@implementation RefreshControl

#pragma mark -
#pragma mark - Public Methods
- (instancetype)initRefreshControlWithScrollView:(UIScrollView*)scrollView
                                        delegate:(id<RefreshControlDelegate>)delegate{
    
    if (self = [super init]) {
        
        self.scrollView = scrollView;
        self.delegate = delegate;
        
        [self.scrollView addObserver:self
                          forKeyPath:KVO_SCROLLVIEW_CONTENT_SIZE
                             options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                             context:NULL];
        
        [self.scrollView addObserver:self
                          forKeyPath:KVO_SCROLLVIEW_CONTENT_OFFSET
                             options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior
                             context:NULL];
        
        
        //创建refreshView
        if (self.isEnableRefresh) {
            if ([self.delegate respondsToSelector:@selector(refreshControlForRefreshView)]) {
                
                self.refreshView = [self.delegate refreshControlForRefreshView];
                
            }
            //如果没有通过代理方法设置refreshView或者代理方法返回nil,那么设置为默认refreshView
            if (self.refreshView == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DefaultRefreshView"
                                                             owner:self
                                                           options:nil];
                self.refreshView = [nib firstObject];
                
            }
            
            [self.scrollView addSubview:self.refreshView];
        }
        
        //创建loadMoreView
        //如果没有通过代理方法设置loadMoreView或者代理方法返回nil,那么设置为默认LoadMoreView
        if(self.isEnableLoadMore){
            
            if ([self.delegate respondsToSelector:@selector(refreshControlForLoadMoreView)]) {
                self.loadMoreView = [self.delegate refreshControlForLoadMoreView];
            }
            if (self.loadMoreView == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DefaultLoadMoreView"
                                                             owner:self
                                                           options:nil];
                self.loadMoreView = [nib firstObject];
            }
            [self.scrollView addSubview:self.loadMoreView];
            
        }
    }
    return self;
    
}

#pragma mark -
#pragma mark - Logic Handle Methods
-(void)handleChange{

    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    //处理刷新
    if(self.isEnableRefresh && contentOffsetY < 0){
        
        if(contentOffsetY < -self.enableInsetTop){
        
            if (self.scrollView.decelerating && self.scrollView.dragging == NO) {

                [self beginRefreshingMethod];
                
            }else{
                
                if ([self.refreshView respondsToSelector:@selector(canEngageRefresh)]) {
                    [self.refreshView canEngageRefresh];
                }
            }
            
        }else{
        
            if ([self.refreshView respondsToSelector:@selector(didDisengageRefresh)]) {
                [self.refreshView didDisengageRefresh];
            }
        
        }
    }
    //处理加载
    else if(self.isEnableLoadMore && contentOffsetY >0 && self.refreshState != RefreshStateFinished){
        
        //当contentSize.height < size.height 时,不显示loadMoreView
        if (self.scrollView.bounds.size.height - self.scrollView.contentSize.height>0) {
            self.loadMoreView.hidden = YES;
            return;
        }
        self.loadMoreView.hidden = NO;
        
        
        contentOffsetY = contentOffsetY+self.scrollView.bounds.size.height - self.scrollView.contentSize.height;
        if (contentOffsetY < 0) {
            return;
        }
        if(contentOffsetY > self.enableInsetBottom){
            
            if (self.scrollView.decelerating && self.scrollView.dragging == NO) {
                
                [self beginLoadMoreingMethod];
                
            }else{
                
                if ([self.loadMoreView respondsToSelector:@selector(canEngageRefresh)]) {
                    [self.loadMoreView canEngageRefresh];
                }
            }
            
        }else{
            
            if ([self.loadMoreView respondsToSelector:@selector(didDisengageRefresh)]) {
                [self.loadMoreView didDisengageRefresh];

            }
            
        }
        
        
    }
    
}

//开始刷新方法
-(void)beginRefreshingMethod{
    
    self.refreshState = RefreshStateRefreshing;
    if ([self.refreshView respondsToSelector:@selector(beginRefreshing)]) {
        [self.refreshView beginRefreshing];
        if (self.loadMoreView) {//正在刷新数据时,隐藏加载控件
            self.loadMoreView.hidden = YES;
        }
    }
    
    [_scrollView setContentOffset:CGPointMake(0, -self.enableInsetTop) animated:YES];
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(self)strongSelf = weakSelf;
        strongSelf.scrollView.contentInset =  UIEdgeInsetsMake(self.enableInsetTop,0,0,0);
        if ([strongSelf.delegate respondsToSelector:@selector(refreshControlForRefreshData)]) {
            [strongSelf.delegate refreshControlForRefreshData];
        }
        
    });
    
}

//结束刷新方法
-(void)endRefreshingMethod{
    
    if ([self.refreshView respondsToSelector:@selector(endRefreshing)]) {
        [self.refreshView endRefreshing];
    }
    

    [UIView animateWithDuration:0.35f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];

    //判断是否还有数据
    if ([self.loadMoreView respondsToSelector:@selector(endRefreshing)]) {
        
        if (self.isDataLoadingFinished) {
            if ([self.loadMoreView respondsToSelector:@selector(dataLoadingFinished)]) {
                self.refreshState = RefreshStateFinished;
                [self.loadMoreView dataLoadingFinished];
                
                //当contentSize.height < size.height 时,不显示loadMoreView
                if (self.scrollView.bounds.size.height - self.scrollView.contentSize.height>0) {
                    self.loadMoreView.hidden = YES;
                    return;
                }
                self.loadMoreView.hidden = NO;
                
                return;
            }
        }
    }
    self.refreshState = RefreshStateNone;
}

//开始加载
-(void)beginLoadMoreingMethod{
    
    self.refreshState = RefreshStateLoadMoreing;
    if ([self.loadMoreView respondsToSelector:@selector(beginRefreshing)]) {
        [self.loadMoreView beginRefreshing];
    }
    
    CGFloat height = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
    CGPoint point = CGPointMake(0, height-self.scrollView.bounds.size.height + self.enableInsetBottom);
    UIEdgeInsets edge = UIEdgeInsetsMake(0,0,self.enableInsetBottom,0);
    
    [_scrollView setContentOffset:point animated:YES];
    __weak typeof(self)weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(self)strongSelf = weakSelf;
        strongSelf.scrollView.contentInset = edge;
        if ([strongSelf.delegate respondsToSelector:@selector(refreshControlForLoadMoreData)]) {
            [strongSelf.delegate refreshControlForLoadMoreData];
        }
    });
}

//结束加载
-(void)endLoadMoreingingMethod{

    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.scrollView.contentInset = UIEdgeInsetsZero;
        
    } completion:^(BOOL finished) {
        
    }];
    
    //判断是否还有数据
    if ([self.loadMoreView respondsToSelector:@selector(endRefreshing)]) {
        
        if (self.isDataLoadingFinished) {
            if ([self.loadMoreView respondsToSelector:@selector(dataLoadingFinished)]) {
                self.refreshState = RefreshStateFinished;
                [self.loadMoreView dataLoadingFinished];
                return;
            }else{
                [self.loadMoreView endRefreshing];
            }
        }else{
            [self.loadMoreView endRefreshing];
        }
    }
    self.refreshState = RefreshStateNone;
}


/*! 结束刷新/加载*/
-(void)endRefreshing{

    if(self.refreshState == RefreshStateRefreshing){
    
        [self endRefreshingMethod];
    
    }else if(self.refreshState == RefreshStateLoadMoreing){
    
        [self endLoadMoreingingMethod];
    
    }

}


#pragma mark -
#pragma mark - Initialize Methods
-(void)setupRefreshView{
    
    if (!self.isEnableRefresh || CGRectIsEmpty(self.scrollView.bounds)) {
        return;
    }
    
    if ([self.refreshView respondsToSelector:@selector(resetLayoutSubViews)]) {
        [self.refreshView resetLayoutSubViews];
    }
    
}

-(void)setupLoadMoreView{

    if (!self.isEnableLoadMore || CGRectIsEmpty(self.scrollView.bounds)) {
        return;
    }
    
    if ([self.loadMoreView respondsToSelector:@selector(resetLayoutSubViews)]) {
        [self.loadMoreView resetLayoutSubViews];
    }
    
}

#pragma mark -
#pragma mark - Getter Methods
-(BOOL)isEnableRefresh{

    if ([self.delegate respondsToSelector:@selector(refreshControlEnableRefresh)]) {
        return [self.delegate refreshControlEnableRefresh];
    }
    return YES;
}

-(BOOL)isEnableLoadMore{
    
    if ([self.delegate respondsToSelector:@selector(refreshControlEnableLoadMore)]) {
        return [self.delegate refreshControlEnableLoadMore];
    }
    return YES;

}

-(CGFloat)enableInsetTop{

    if ([self.delegate respondsToSelector:@selector(refreshControlEnableInsetTop)]) {
        return [self.delegate refreshControlEnableInsetTop];
    }
    return ENABLE_INSET_TOP;
}

-(CGFloat)enableInsetBottom{
    
    if ([self.delegate respondsToSelector:@selector(refreshControlEnableInsetBottom)]) {
        return [self.delegate refreshControlEnableInsetBottom];
    }
    return ENABLE_INSET_BOTTOM;
}

-(BOOL)isDataLoadingFinished{
    
    if ([self.delegate respondsToSelector:@selector(refreshControlForDataLoadingFinished)]) {
        return [self.delegate refreshControlForDataLoadingFinished];
    }
    return NO;
}

#pragma mark -
#pragma mark - KVO Methods
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if([keyPath isEqual:KVO_SCROLLVIEW_CONTENT_SIZE]){
        [self setupRefreshView];
        [self setupLoadMoreView];
        
    }else if([keyPath isEqualToString:KVO_SCROLLVIEW_CONTENT_OFFSET]){
        
        if (self.refreshState != RefreshStateRefreshing
            && self.refreshState != RefreshStateLoadMoreing) {
            [self handleChange];
        }
        
    }
}


#pragma mark - 
#pragma mark - Destroy Methods
-(void)dealloc{

    self.delegate = nil;
    [self.scrollView removeObserver:self forKeyPath:KVO_SCROLLVIEW_CONTENT_SIZE];
    [self.scrollView removeObserver:self forKeyPath:KVO_SCROLLVIEW_CONTENT_OFFSET];

}


@end




























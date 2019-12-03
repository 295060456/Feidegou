//
//  GoodsDetailsVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/27.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GoodsDetailsVC.h"

@interface GoodsDetailsVC ()
<
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)id requestParams;

@end

@implementation GoodsDetailsVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    GoodsDetailsVC *vc = GoodsDetailsVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
//    vc.page = 1;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {

    }
 
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                vc.isFirstComing = YES;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

+(instancetype)initWithrequestParams:(nullable id)requestParams
                             success:(DataBlock)block{
    GoodsDetailsVC *vc = GoodsDetailsVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navBackgroundColor = kClearColor;
    self.gk_navLineHidden = YES;
    self.scrollView.alpha = 1;
    self.imgView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navigationBar.alpha = 0;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.gk_navigationBar.mj_h = SCALING_RATIO(20);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView API_AVAILABLE(ios(3.2)); // any zoom scale changes
//
//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset API_AVAILABLE(ios(5.0));
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;     // return a view that will be scaled. if delegate returns nil, nothing happens
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view API_AVAILABLE(ios(3.2)); // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;      // called when scrolling animation finished. may be called immediately if already at top
//
///* Also see -[UIScrollView adjustedContentInsetDidChange]
// */
//- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0));
#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.delegate = self;
        _scrollView.alpha = 0;
//        _scrollView.mj_header = self.tableViewHeader;
        _scrollView.mj_footer = self.refreshBackNormalFooter;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,
                                             kIMG(@"LongPic").size.height * SCREEN_WIDTH / kIMG(@"LongPic").size.width);
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
        [self.view layoutIfNeeded];
        NSLog(@"");
    }return _scrollView;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = UIImageView.new;
        _imgView.backgroundColor = KYellowColor;
        _imgView.image = kIMG(@"LongPic");
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.height.mas_equalTo(kIMG(@"LongPic").size.height * SCREEN_WIDTH / kIMG(@"LongPic").size.width);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
    }return _imgView;
}

@end

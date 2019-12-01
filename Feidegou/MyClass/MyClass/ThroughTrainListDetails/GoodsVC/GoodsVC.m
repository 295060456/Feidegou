//
//  GoodsVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/27.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GoodsVC.h"

#import "DetailsVC.h"

@interface GoodsVC ()
<
PGBannerDelegate,
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)PGBanner *banner;
@property(nonatomic,strong)UIView *viewr;//承接作用
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)YYLabel *salesLab;
@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;

@end

@implementation GoodsVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    GoodsVC *vc = GoodsVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
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
    GoodsVC *vc = GoodsVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navBarAlpha = 0;
    self.gk_navLineHidden = YES;
    
    self.scrollView.alpha = 1;
    self.banner.alpha = 1;
    self.viewr.alpha = 1;
    
    self.titleLab.alpha = 1;
    self.priceLab.alpha = 1;
    self.str = @"已购买9件";
    self.salesLab.alpha = 1;
    
    self.imgView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navigationBar.alpha = 0;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.gk_navigationBar.mj_h = SCALING_RATIO(20);//因为要重写gk_navigationBar的高度，所以在这里要重写_scrollView的相关属性
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,
                                         self.imgView.mj_h + self.banner.mj_h + SCALING_RATIO(50));
    _scrollView.contentOffset = CGPointMake(0, SCALING_RATIO(20));
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 私有方法
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
//    [self.scrollView setContentOffset:(CGPoint){0,-3}
//                             animated:YES];
////    self.scrollView.mj_footer.hidden = YES;
//    [self.scrollView.mj_header endRefreshing];
//    [self.scrollView.mj_footer endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{//MJRefreshBackNormalFooter
    NSLog(@"上拉加载更多");
    [self.scrollView setContentOffset:(CGPoint){0,SCREEN_HEIGHT - 90}
                             animated:YES];
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
}
#pragma mark —— PGBannerDelegate
- (void)selectAction:(NSInteger)didSelectAtIndex didSelectView:(id)view {
    NSLog(@"index = %ld  view = %@", didSelectAtIndex, view);
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
//        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,
//                                             3000);//SCREEN_HEIGHT + kIMG(@"LongPic").size.height * SCREEN_WIDTH / kIMG(@"LongPic").size.width
//        _scrollView.contentInset = UIEdgeInsetsMake(0,
//                                                    0,
//                                                    0,
//                                                    0);
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
        [self.view layoutIfNeeded];
        NSLog(@"");
    }return _scrollView;
}

-(PGBanner *)banner{
    if (!_banner) {
        _banner = [[PGBanner alloc]initImageViewWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,//    [UIScreen mainScreen].bounds.size.width
                                                                     SCREEN_HEIGHT / 2)//   [UIScreen mainScreen].bounds.size.height
                                                imageList:@[@"1.png",
                                                            @"2.png",
                                                            @"3.png"]
                                             timeInterval:3.0];
        _banner.delegate = self;
        [self.scrollView addSubview:_banner];
    }return _banner;
}

-(UIView *)viewr{
    if (!_viewr) {
        _viewr = UIView.new;
        _viewr.backgroundColor = kWhiteColor;
        [self.scrollView addSubview:_viewr];
        [_viewr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.banner.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALING_RATIO(80));
        }];
    }return _viewr;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = UIImageView.new;
        _imgView.backgroundColor = KYellowColor;
        _imgView.image = kIMG(@"LongPic");
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewr.mas_bottom);
            make.height.mas_equalTo(kIMG(@"LongPic").size.height * SCREEN_WIDTH / kIMG(@"LongPic").size.width);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
    }return _imgView;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"木糖醇红枣燕麦";
        [self.viewr addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.viewr).offset(SCALING_RATIO(10));
            make.right.equalTo(self.viewr).offset(SCALING_RATIO(-10));
            make.height.mas_equalTo(SCALING_RATIO(30));
        }];
    }return _titleLab;
}

-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = UILabel.new;
        _priceLab.text = @"$23.11";
        _priceLab.textColor = kRedColor;
        [self.viewr addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.viewr).offset(SCALING_RATIO(-10));
            make.left.equalTo(self.viewr).offset(SCALING_RATIO(10));
            make.height.mas_equalTo(SCALING_RATIO(30));
        }];
    }return _priceLab;
}

-(YYLabel *)salesLab{
    if (!_salesLab) {
        _salesLab = YYLabel.new;
        _salesLab.textAlignment = NSTextAlignmentCenter;
        _salesLab.numberOfLines = 0;
        _salesLab.attributedText = self.attributedString;
        [_salesLab sizeToFit];
        [self.viewr addSubview:_salesLab];
        [_salesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.priceLab);
            make.right.equalTo(self.viewr).offset(SCALING_RATIO(-10));
        }];
    }return _salesLab;
}

-(NSMutableAttributedString *)attributedString{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineSpacing = 1;//行间距
    paragraphStyle.firstLineHeadIndent = 20;//首行缩进
    
    NSDictionary *attributeDic = @{
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : kRedColor
    };
    if (!_attributedString) {
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];
    }else{
        _attributedString = Nil;
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];
    }
        NSRange selRange_01 = [self.str rangeOfString:@"已购买"];//location=0, length=2
        NSRange selRange_02 = [self.str rangeOfString:@"件"];//location=6, length=2

        //设定可点击文字的的大小
        UIFont *selFont = [UIFont systemFontOfSize:16];
        CTFontRef selFontRef = CTFontCreateWithName((__bridge CFStringRef)selFont.fontName,
                                                    selFont.pointSize,
                                                    NULL);
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_01];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_01];
#warning 打开注释部分会崩，之前都不会崩溃，怀疑是升级Xcode所致
                 //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_01];
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //设置可点击文本的大小
        [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)selFontRef
                                  range:selRange_02];
        //设置可点击文本的颜色
        [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                  value:(id)[[UIColor blueColor] CGColor]
                                  range:selRange_02];
        //设置可点击文本的背景颜色
        //        if (@available(iOS 10.0, *)) {
        //            [text addAttribute:(NSString *)kCTBackgroundColorAttributeName
        //                         value:(__bridge id)selFontRef
        //                         range:selRange_02];
        //        } else {
        //            // Fallback on earlier versions
        //        }
    return _attributedString;
}


@end

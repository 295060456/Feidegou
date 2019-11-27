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
PGBannerDelegate
>

@property(nonatomic,strong)PGBanner *banner;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)id requestParams;

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
    self.view.backgroundColor = RandomColor;
    self.banner.alpha = 1;
}

#pragma mark —— PGBannerDelegate
- (void)selectAction:(NSInteger)didSelectAtIndex didSelectView:(id)view {
    NSLog(@"index = %ld  view = %@", didSelectAtIndex, view);
}

-(PGBanner *)banner{
    if (!_banner) {
        _banner = [[PGBanner alloc]initImageViewWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT * 3 / 4 )
                                                imageList:@[@"1.png",
                                                            @"2.png",
                                                            @"3.png",
                                                            @"4.png"]
                                             timeInterval:3.0];
        _banner.delegate = self;
        [self.view addSubview:_banner];
    }return _banner;
}


@end

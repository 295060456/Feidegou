//
//  samplePicVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SamplePicVC.h"

@interface SamplePicVC ()

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation SamplePicVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    SamplePicVC *vc = SamplePicVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle = @"上传取消凭证";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.imageView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark —— lazyLoad
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.image = kIMG(@"猫和鱼");
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _imageView;
}

@end

//
//  OrderDetailVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC.h"
#pragma mark —— InfoView
@interface InfoView ()

@property(nonatomic,strong)UIButton *A_Btn;
@property(nonatomic,strong)UIButton *B_Btn;
@property(nonatomic,strong)UIButton *directionBtn;

@end

@implementation InfoView

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (instancetype)init{
    if (self = [super init]) {
        
    }return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.A_Btn.alpha = 1;
    self.B_Btn.alpha = 1;
    self.directionBtn.alpha = 1;
}

#pragma mark —— lazyLoad
-(UIButton *)A_Btn{
    if (!_A_Btn) {
        _A_Btn = UIButton.new;
        _A_Btn.titleLabel.text = @"1234567";
        _A_Btn.backgroundColor = kBlueColor;
        [_A_Btn.titleLabel sizeToFit];
        _A_Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_A_Btn];
        [_A_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(SCALING_RATIO(10));
            if (self.mj_h < SCREEN_HEIGHT / 10) {//
                make.top.equalTo(self).offset(SCALING_RATIO(10));
                make.bottom.equalTo(self).offset(SCALING_RATIO(-10));
            }else{
                make.height.mas_equalTo(self.mj_h / 2);
            }
        }];
    }return _A_Btn;
}

-(UIButton *)B_Btn{
    if (!_B_Btn) {
        _B_Btn = UIButton.new;
        _B_Btn.titleLabel.text = @"1234567";
        [_B_Btn.titleLabel sizeToFit];
        _B_Btn.backgroundColor = kRedColor;
        _B_Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_B_Btn];
        [_B_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(SCALING_RATIO(-10));
            if (self.mj_h < SCREEN_HEIGHT / 10) {//
                make.top.equalTo(self).offset(SCALING_RATIO(10));
                make.bottom.equalTo(self).offset(SCALING_RATIO(-10));
            }else{
                make.height.mas_equalTo(self.mj_h / 2);
            }
        }];
    }return _B_Btn;
}

-(UIButton *)directionBtn{
    if (!_directionBtn) {
        _directionBtn = UIButton.new;
        [_directionBtn setImage:kIMG(@"双向箭头")
                       forState:UIControlStateNormal];
        [self addSubview:_directionBtn];
        [_directionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.A_Btn.mas_right).offset(SCALING_RATIO(5));
            make.right.equalTo(self.B_Btn.mas_left).offset(SCALING_RATIO(-5));
            make.height.mas_equalTo(SCALING_RATIO(20));
        }];
    }return _directionBtn;
}

@end
#pragma mark —— OrderDetailVC
@interface OrderDetailVC ()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)InfoView *infoView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation OrderDetailVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderDetailVC *vc = OrderDetailVC.new;
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
    //    self.navigationItem.title = @"订单详情";
    self.gk_navTitle = @"订单详情";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.infoView.alpha = 1;
    self.sureBtn.alpha = 1;
    self.cancelBtn.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}
#pragma mark —— 点击事件
-(void)sureBtnClickEvent:(UIButton *)sender{
    
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    
    
}

#pragma mark —— lazyLoad

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
    }return _tableView;
}

-(InfoView *)infoView{
    if (!_infoView) {
        _infoView = InfoView.new;
        _infoView.backgroundColor = KLightGrayColor;
        [UIView cornerCutToCircleWithView:_infoView
                          AndCornerRadius:5];
        [self.view addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom).offset(SCALING_RATIO(10));
            make.left.equalTo(self.view).offset(SCALING_RATIO(10));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-10));
            make.height.mas_equalTo(SCREEN_HEIGHT / 5);
        }];
    }return _infoView;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        [_sureBtn setTitle:@"确认发货"
                  forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:5];
        [self.view addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(SCALING_RATIO(10));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 5,
                                             SCREEN_HEIGHT / 15));
        }];
    }return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.infoView).offset(SCALING_RATIO(-10));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 5,
                                             SCREEN_HEIGHT / 15));
        }];
    }return _cancelBtn;
}





@end

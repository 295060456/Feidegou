//
//  OrderDetailVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_SellerVC.h"
#import "UpLoadCancelReasonVC.h"
#import "OrderDetail_SellerVC+VM.h"
//#import "math.h"

#pragma mark —— InfoView
@interface OrderDetailTBVCell_02 ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*tempMutArr;

@end

@implementation OrderDetailTBVCell_02
+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_02 *cell = (OrderDetailTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{//大
    return self.titleMutArr.count * [OrderDetailTBVCell_03 cellHeightWithModel:NULL] + SCALING_RATIO(20);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderDetail_SellerModel class]]) {
        OrderDetail_SellerModel *orderDetail_SellerModel = (OrderDetail_SellerModel *)model;
        [self.tempMutArr addObject:[NSString ensureNonnullString:orderDetail_SellerModel.ordercode ReplaceStr:@""]];
        [self.tempMutArr addObject:[NSString stringWithFormat:@"%d",[orderDetail_SellerModel.price intValue]]];
        [self.tempMutArr addObject:[NSString stringWithFormat:@"%d",[orderDetail_SellerModel.rental intValue]]];
        [self.tempMutArr addObject:@"账号"];
        [self.tempMutArr addObject:@"银行卡"];
        [self.tempMutArr addObject:[NSString ensureNonnullString:orderDetail_SellerModel.refer ReplaceStr:@""]];
        [self.tempMutArr addObject:[NSString ensureNonnullString:orderDetail_SellerModel.updateTime ReplaceStr:@""]];
        [self.tableView reloadData];
    }else if ([model isKindOfClass:[StallListModel class]]){
        StallListModel *stallListModel = (StallListModel *)model;
        [self.tempMutArr addObject:[NSString ensureNonnullString:stallListModel.ordercode ReplaceStr:@""]];
        [self.tempMutArr addObject:[NSString ensureNonnullString:stallListModel.price ReplaceStr:@""]];
        [self.tempMutArr addObject:[NSString ensureNonnullString:stallListModel.rental ReplaceStr:@""]];
        [self.tempMutArr addObject:@"账号"];
        [self.tempMutArr addObject:@"银行卡"];
        [self.tempMutArr addObject:[NSString ensureNonnullString:stallListModel.refer ReplaceStr:@""]];
        [self.tempMutArr addObject:[NSString ensureNonnullString:stallListModel.updateTime ReplaceStr:@""]];
        [self.tableView reloadData];
    }
    self.tableView.alpha = 1;
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderDetailTBVCell_03 cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailTBVCell_03 *cell = [OrderDetailTBVCell_03 cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row];
    if (self.tempMutArr.count) {
        cell.detailTextLabel.text = self.tempMutArr[indexPath.row];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"订单:"];
        [_titleMutArr addObject:@"单价:"];
        [_titleMutArr addObject:@"总价:"];
        [_titleMutArr addObject:@"账号:"];
        [_titleMutArr addObject:@"支付方式:"];
        [_titleMutArr addObject:@"参考号:"];
        [_titleMutArr addObject:@"下单时间:"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)tempMutArr{
    if (!_tempMutArr) {
        _tempMutArr = NSMutableArray.array;
    }return _tempMutArr;
}

@end

@interface OrderDetailTBVCell_03 ()
@end

@implementation OrderDetailTBVCell_03

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_03 *cell = (OrderDetailTBVCell_03 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_03 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{//小
    return SCALING_RATIO(40);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

@end

@interface OrderDetailTBVCell_04 ()

@property(nonatomic,strong)YYLabel *titleLab;
@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *attributedString;

@end

@implementation OrderDetailTBVCell_04

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_04 *cell = (OrderDetailTBVCell_04 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_04 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return _titleLab.mj_h + SCALING_RATIO(50);//SCALING_RATIO(50) 为补充值
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderDetail_SellerModel class]]) {
        OrderDetail_SellerModel *orderDetail_SellerModel = (OrderDetail_SellerModel *)model;
        self.str = [NSString stringWithFormat:@"您向%@购买%d",orderDetail_SellerModel.seller_name,[orderDetail_SellerModel.quantity intValue]];
        self.titleLab.attributedText = self.attributedString;
//        上面这句等于下面两句
//        self.attributedString;
//        self.titleLab.alpha = 1;
    }else if ([model isKindOfClass:[StallListModel class]]){
        StallListModel *stallListModel = (StallListModel *)model;
        self.str = [NSString stringWithFormat:@"您向%@购买%@",[NSString ensureNonnullString:stallListModel.seller ReplaceStr:@""],[NSString ensureNonnullString:stallListModel.quantity ReplaceStr:@""]];
//        self.attributedString = [NSString ensureNonnullString:stallListModel.del_reason ReplaceStr:@""];
        self.titleLab.attributedText = self.attributedString;
//        self.titleLab.text = [NSString ensureNonnullString:stallListModel.del_reason ReplaceStr:@""];
    }else{}
}
#pragma mark —— lazyLoad
-(NSMutableAttributedString *)attributedString{
    if (!_attributedString) {
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineSpacing = 1;//行间距
        paragraphStyle.firstLineHeadIndent = 40;//首行缩进
        
        NSDictionary *attributeDic = @{
            NSFontAttributeName : [UIFont systemFontOfSize:24],
            NSParagraphStyleAttributeName : paragraphStyle,
            NSForegroundColorAttributeName : kRedColor
        };
            
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.str
                                                                  attributes:attributeDic];

        NSRange selRange_01 = [self.str rangeOfString:@"您向"];
        NSRange selRange_02 = [self.str rangeOfString:@"购买"];

        //设定可点击文字的的大小
        UIFont *selFont = [UIFont systemFontOfSize:18];
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
    }return _attributedString;
}

-(YYLabel *)titleLab{
    if (!_titleLab) {
        _titleLab = YYLabel.new;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        _titleLab.attributedText = self.attributedString;
//        _titleLab.lineBreakMode = NSLineBreakByCharWrapping;//？？
        [_titleLab sizeToFit];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(20));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-20));
            make.left.right.equalTo(self.contentView);
        }];
    }return _titleLab;
}

@end

@interface OrderDetailTBVCell_05 ()

@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation OrderDetailTBVCell_05

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_05 *cell = (OrderDetailTBVCell_05 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_05 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    
    if ([model isKindOfClass:[OrderDetail_SellerModel class]]) {
        OrderDetail_SellerModel *orderDetail_SellerModel = (OrderDetail_SellerModel *)model;
        switch ([orderDetail_SellerModel.order_status intValue]) {//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
            case 0:{
                self.titleLab.text = @"订单已支付";
            }break;
            case 1:{
                self.titleLab.text = @"订单已发单";
            }break;
            case 2:{
                self.titleLab.text = @"订单已下单";
            }break;
            case 3:{
                self.titleLab.text = @"订单已支付";
            }break;
            case 4:{
                self.titleLab.text = @"订单已作废";
            }break;
            case 5:{
                self.titleLab.text = @"订单已完成";
            }break;
            default:
                break;
        }
    }else if ([model isKindOfClass:[StallListModel class]]){
        StallListModel *stallListModel = (StallListModel *)model;
        self.titleLab.text = [NSString ensureNonnullString:stallListModel.del_reason ReplaceStr:@""];
    }else{
        
    }
}

#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _titleLab;
}

@end

@interface OrderDetailTBVCell_06 ()

@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)VerifyCodeButton *cancelCountDownBtn;//“取消”倒计时按钮
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,copy)DataBlock sureBlock;
@property(nonatomic,copy)DataBlock cancelBlock;

@end

@implementation OrderDetailTBVCell_06

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_06 *cell = (OrderDetailTBVCell_06 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_06 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 5;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderDetail_SellerModel class]]) {
        OrderDetail_SellerModel *orderDetail_SellerModel = (OrderDetail_SellerModel *)model;
        NSLog(@"KKK deal = %d",[orderDetail_SellerModel.deal intValue]);
        NSLog(@"KKK order_type = %d",[orderDetail_SellerModel.order_type intValue]);
        NSLog(@"KKK order_status = %d",[orderDetail_SellerModel.order_status intValue]);
        if ([orderDetail_SellerModel.deal intValue] == 1) {//买家
            NSLog(@"买家");
        }else if ([orderDetail_SellerModel.deal intValue] == 2){//卖家 卖家才有发货
            if (orderDetail_SellerModel.order_status == 0) {//状态 —— 0、已支付;1、已发单;2、已下单;3、已作废;4、已发货;5、已完成
                if ([orderDetail_SellerModel.order_type intValue] == 1 ||
                    [orderDetail_SellerModel.order_type intValue] == 2) {
                    self.sureBtn.alpha = 1;//出现"确认发货"按钮
                }else{
                    self.sureBtn.alpha = 0;
                }
                self.cancelCountDownBtn.alpha = 1;
            }else if ([orderDetail_SellerModel.order_status intValue] == 5) {//5、已完成 都不能撤销
                self.sureBtn.alpha = 0;
                [self.cancelBtn setTitle:@"已完成,不能撤销"
                                forState:UIControlStateNormal];
            }else if ([orderDetail_SellerModel.order_status intValue] == 3){//3、已作废
                self.sureBtn.alpha = 0;
                [self.cancelBtn setTitle:@"已作废"
                forState:UIControlStateNormal];
            }
            
            if ([orderDetail_SellerModel.del_state intValue] == 1){//正在审核
                self.sureBtn.alpha = 0;
                [self.cancelBtn setTitle:@"正在审核"
                                forState:UIControlStateNormal];
            }else if([orderDetail_SellerModel.del_state intValue] == 2){//订单撤销
                self.sureBtn.alpha = 0;
                [self.cancelBtn setTitle:@"订单撤销"
                                forState:UIControlStateNormal];
            }
        }
        
        
//
    }
}

-(void)actionSureBlock:(DataBlock)block{
    self.sureBlock = block;
}

-(void)actionCancelBlock:(DataBlock)block{
    self.cancelBlock = block;
}

-(void)sureBtnClickEvent:(UIButton *)sender{
    NSLog(@"确认发货");
    if (self.sureBlock) {
        self.sureBlock(@1);
    }
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消");
    if (self.cancelBlock) {
        self.cancelBlock(@1);
    }
}

#pragma mark —— lazyload
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        [_sureBtn.titleLabel sizeToFit];
        _sureBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_sureBtn setTitle:@" 确认发货 "
                  forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:5];
        [self.contentView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.centerY.equalTo(self.contentView);
        }];
    }return _sureBtn;
}

-(VerifyCodeButton *)cancelCountDownBtn{
    if (!_cancelCountDownBtn) {
        _cancelCountDownBtn = VerifyCodeButton.new;
        _cancelCountDownBtn.titleBeginStr = @"取消";
        _cancelCountDownBtn.titleEndStr = @"取消";
        _cancelCountDownBtn.titleColor = kWhiteColor;
        _cancelCountDownBtn.bgBeginColor = KLightGrayColor;
        _cancelCountDownBtn.bgEndColor = kOrangeColor;
        _cancelCountDownBtn.layerBorderColor = kWhiteColor;
        _cancelCountDownBtn.layerCornerRadius = 5;
        _cancelCountDownBtn.isClipsToBounds = YES;
//        [_cancelBtn.titleLabel sizeToFit];
        _cancelCountDownBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_cancelCountDownBtn timeFailBeginFrom:3];
        [_cancelCountDownBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelCountDownBtn];
        [_cancelCountDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.sureBtn);
        }];
    }return _cancelCountDownBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5];
        [UIView colourToLayerOfView:_cancelBtn
                         WithColour:kOrangeColor
                     AndBorderWidth:1];
        [_cancelBtn.titleLabel sizeToFit];
        _cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_cancelBtn addTarget:self
//                       action:@selector(cancelBtnClickEvent:)
//             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.sureBtn);
        }];
    }return _cancelBtn;
}

@end

#pragma mark —— OrderDetailVC
#import "StallListVC.h"
#import "OrderListVC.h"
@interface OrderDetail_SellerVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    CGFloat OrderDetailTBVCell_04_Height;
    CGFloat OrderDetailTBVCell_02_Height;
}

@property(nonatomic,strong)BRStringPickerView *stringPickerView;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)id popGestureDelegate; //用来保存系统手势的代理
@property(nonatomic,assign)BOOL isShowViewFinished;

@end

@implementation OrderDetail_SellerVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    OrderDetail_SellerVC *vc = OrderDetail_SellerVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;//OrderListModel StallListModel 
    vc.isShowViewFinished = NO;
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
    self.gk_navTitle = @"订单详情";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    
//我们不能直接将代理置空，需要根据当前栈顶控制器是否是根控制器进行判断。
    //    self.interactivePopGestureRecognizer.delegate = nil;
//第一步，先保存当前的代理
    self.popGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;

//第二步，成为自己的代理，去监听pop的过程，pop之前判断是否为根控制器
    self.navigationController.delegate = self;
    self.isShowViewFinished = YES;
    [self.tableView.mj_header beginRefreshing];//
}
#pragma mark —— UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    if ([viewController isKindOfClass:[StallListVC class]] && self.isShowViewFinished) {
        [navigationController popToViewController:navigationController.viewControllers[navigationController.viewControllers.count - 2]
                                         animated:NO];

    }else if([viewController isKindOfClass:[OrderListVC class]]){
        
    }
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— 私有方法
-(void)ConfirmDelivery{
    NSLog(@"1");
    [self ConfirmDelivery_NetWorking];
}

-(void)CancelDelivery{
    
    //#5 CatfoodRecord_delURL 喵粮订单撤销 order_id reason del_print(pic) order_type
    //#9 CatfoodCO_pay_delURL 喵粮产地购买取消 order_id
    //#18 CatfoodSale_pay_delURL 喵粮批发取消 order_id
    //#22 CatfoodBooth_delURL 喵粮抢摊位取消 order_id
    
    OrderListModel *orderListModel;
    NSDictionary *dictionary;
    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
        dictionary = (NSDictionary *)self.requestParams;//OrderListModel
        orderListModel = dictionary[@"OrderListModel"];
    }

    if ([orderListModel.order_status intValue] == 0) {//#5
        //选择取消发货的原因
        [self.stringPickerView show];
    }else if ([orderListModel.order_status intValue] == 2){
        if ([orderListModel.order_type intValue] == 1) {//#22
            [self netWorkingWithArgumentURL:CatfoodBooth_delURL
                                    ORDERID:[orderListModel.ID intValue]];
        }else if ([orderListModel.order_type intValue] == 2){//#18
            [self netWorkingWithArgumentURL:CatfoodSale_pay_delURL
                                    ORDERID:[orderListModel.ID intValue]];
        }else if ([orderListModel.order_type intValue] == 3){//#9
            [self netWorkingWithArgumentURL:CatfoodCO_pay_delURL
                                    ORDERID:[orderListModel.ID intValue]];
        }
    }
}

-(void)Cancel{
    NSLog(@"3");
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
//    if (self.dataMutArr.count) {
//        [self.dataMutArr removeAllObjects];
//    }
    [self netWorking];
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self netWorking];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return OrderDetailTBVCell_04_Height;
    }else if(indexPath.section == 1 &&
             indexPath.row == 0){
        return OrderDetailTBVCell_02_Height;
    }else if (indexPath.section == 1 &&
              indexPath.row == 1){
        return [OrderDetailTBVCell_05 cellHeightWithModel:NULL];
    }else if (indexPath.section == 1 &&
              indexPath.row == 2){
        return [OrderDetailTBVCell_06 cellHeightWithModel:NULL];
    }else{}
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {

        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        } break;
        case 1:{
            return 3;
        } break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderDetailTBVCell_04 *cell = [OrderDetailTBVCell_04 cellWith:tableView];
            
            if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
                [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                [cell richElementsInCellWithModel:self.requestParams];
            }
            
            OrderDetailTBVCell_04_Height = [cell cellHeightWithModel:NULL];
            return cell;
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            OrderDetailTBVCell_02 *cell = [OrderDetailTBVCell_02 cellWith:tableView];
            OrderDetailTBVCell_02_Height = [cell cellHeightWithModel:NULL];
//            cell.backgroundColor = KGreenColor;
        
            if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
                [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                [cell richElementsInCellWithModel:self.requestParams];
            }
            
            return cell;
        }else if(indexPath.row == 1){
            OrderDetailTBVCell_05 *cell = [OrderDetailTBVCell_05 cellWith:tableView];
//            cell.backgroundColor = KGreenColor;
//            [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            
            if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
                [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                [cell richElementsInCellWithModel:self.requestParams];
            }
            
            return cell;
        }else if(indexPath.row == 2){
            OrderDetailTBVCell_06 *cell = [OrderDetailTBVCell_06 cellWith:tableView];
//            cell.backgroundColor = KGreenColor;
//            [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            
            if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
                [cell richElementsInCellWithModel:self.orderDetail_SellerModel];
            }else if ([self.requestParams isKindOfClass:[StallListModel class]]){
                [cell richElementsInCellWithModel:self.requestParams];
            }
            
            @weakify(self)
            [cell actionSureBlock:^(id data) {
                @strongify(self)
                [self showAlertViewTitle:@"确认发货？"
                                 message:@"确认以后将货款进行拨付"
                             btnTitleArr:@[@"确认发货",
                                           @"取消"]
                          alertBtnAction:@[@"ConfirmDelivery",//确认发货
                                           @"Cancel"]];//取消
            }];
            [cell actionCancelBlock:^(id data) {
                @strongify(self)
                [self showAlertViewTitle:@"取消发货？"
                                 message:@""
                             btnTitleArr:@[@"取消发货",
                                           @"取消"]
                          alertBtnAction:@[@"CancelDelivery",//取消发货
                                           @"Cancel"]];//取消
            }];
            return cell;
        }else{}
    }else{}
    return UITableViewCell.new;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(BRStringPickerView *)stringPickerView{
    if (!_stringPickerView) {
        _stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
        _stringPickerView.title = @"请选择取消原因";
        _stringPickerView.dataSourceArr = @[@"未收到款项",
                                           @"收到了,但是款项不符"];
//        _stringPickerView.selectValue = textField.text;
        @weakify(self)
        _stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            NSLog(@"选择的值：%@", resultModel.selectValue);
            @strongify(self)
            self.resultStr = resultModel.selectValue;
            [UpLoadCancelReasonVC pushFromVC:self_weak_
                               requestParams:@{
                                   @"OrderListModel":self.requestParams,
                                   @"Result":self.resultStr,//撤销理由
                               }
                                     success:^(id data) {}
                                    animated:YES];
        };
    }return _stringPickerView;
}



@end

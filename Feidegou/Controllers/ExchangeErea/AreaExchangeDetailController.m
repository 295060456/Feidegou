//
//  AreaExchangeDetailController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/7.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaExchangeDetailController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellImageOnly.h"
#import "CellGoodDetai.h"
#import "AreaOrderComfilmController.h"

@interface AreaExchangeDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *lblBuyMost;
@property (weak, nonatomic) IBOutlet UITableView *tabDetail;
@property (weak, nonatomic) IBOutlet UIView *viNum;
@property (weak, nonatomic) IBOutlet UILabel *lblLineOne;
@property (weak, nonatomic) IBOutlet UILabel *lblLineTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblNumBuy;
@property (weak, nonatomic) IBOutlet UILabel *lblNumLeave;
@property (weak, nonatomic) IBOutlet UIButton *btnExchage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintScHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTabHegith;
@property (weak, nonatomic) IBOutlet UIScrollView *scBack;
@property (strong, nonatomic) ModelEreaExchangeDetail *modelDetail;
@property (assign, nonatomic) int intNum;

@end

@implementation AreaExchangeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.scBack setBackgroundColor:[UIColor clearColor]];
    [self.viNum.layer setBorderWidth:1];
    [self.viNum.layer setBorderColor:ColorLine.CGColor];
    [self.lblLineOne setBackgroundColor:ColorLine];
    [self.lblLineTwo setBackgroundColor:ColorLine];
    [self.btnExchage setBackgroundColor:ColorHeader];
    self.intNum = 1;
    [self refreshNum];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellImageOnly" bundle:nil] forCellReuseIdentifier:@"CellImageOnly"];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellGoodDetai" bundle:nil] forCellReuseIdentifier:@"CellGoodDetai"];
    self.layoutConstraintTabHegith.constant = SCREEN_WIDTH+95.0;
    [self refreshScHeight];
    [self requestData];
}

- (void)refreshScHeight{
    D_NSLog(@"self.webView.scrollView.contentSize.height is %f",self.webView.scrollView.contentSize.height);
    self.layoutConstraintScHeight.constant = self.layoutConstraintTabHegith.constant + self.webView.scrollView.contentSize.height+150;
}

- (void)requestData{
    [self showException];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodEreaExchangeDetailIg_goods_id:self.model.ig_goods_id] subscribeNext:^(ModelEreaExchangeDetail *model) {
        @strongify(self)
        self.modelDetail = model;
        [self refreshView];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self failedRequestException:enum_exception_timeout];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
        [self hideException];
    }];
}

- (void)refreshView{
    [self.tabDetail reloadData];
    [self.lblNumLeave setText:StringFormat(@"库存%@  限购%@",self.modelDetail.ig_goods_count,self.modelDetail.ig_limit_count)];
    [self.webView loadHTMLString:self.modelDetail.ig_content baseURL:nil];
}

- (void)refreshNum{
    [self.lblNumBuy setText:TransformNSInteger(self.intNum)];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SCREEN_WIDTH;
    }else{
        return 95;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 0) {
            CellImageOnly *cell=[tableView dequeueReusableCellWithIdentifier:@"CellImageOnly"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.imgOnly setImagePathHead:self.modelDetail.img];
            return cell;
        }
        CellGoodDetai *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodDetai"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataAreaExchange:self.modelDetail];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)clickButtonReduce:(UIButton *)sender {
//    if (self.intNum>1) {
//        self.intNum--;
//        [self refreshNum];
//    }
}

- (IBAction)clickButtonAdd:(UIButton *)sender {
//    if (self.intNum<[self.modelDetail.ig_goods_count intValue]) {
//        self.intNum++;
//        [self refreshNum];
//    }
}

- (IBAction)clickButtonCommit:(UIButton *)sender {
    
    if ([[PersonalInfo sharedInstance] isLogined]) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
        AreaOrderComfilmController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaOrderComfilmController"];
        controller.intNum = self.intNum;
        controller.modelDetail = self.modelDetail;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self pushLoginController];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    D_NSLog(@"webViewDidStartLoad");
    [self refreshScHeight];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    D_NSLog(@"webViewDidFinishLoad");
    [self refreshScHeight];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    D_NSLog(@"webViewDidStartLoad");
}


@end

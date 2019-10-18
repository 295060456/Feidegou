//
//  DiscussOrderController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/19.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "DiscussOrderController.h"
#import "CellDiscussOrder.h"
#import "UIButton+Joker.h"
#import "JJHttpClient+FourZero.h"

@interface DiscussOrderController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tabDiscuss;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

@end

@implementation DiscussOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ljwKeyboardHandler];
    [self.lblLine setBackgroundColor:ColorLine];
    [self.btnCommit setBackgroundColor:ColorRed];
    [self.tabDiscuss setBackgroundColor:ColorBackground];
    [self.tabDiscuss registerNib:[UINib nibWithNibName:@"CellDiscussOrder" bundle:nil]
          forCellReuseIdentifier:@"CellDiscussOrder"];
    [self.tabDiscuss checkNoData:self.arrDiscuss.count];
    
    // Do any additional setup after loading the view.
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDiscuss.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 365.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    CellDiscussOrder *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDiscussOrder"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell popuLateData:self.arrDiscuss[indexPath.section]];
    [cell.textView setTag:indexPath.section+10000];
    [cell.textView setDelegate:self];
    for (int i = 100; i<103; i++) {
        UIButton *btnGood = (UIButton *)[cell viewWithTag:i];
        [btnGood handleControlEvent:UIControlEventTouchUpInside
                          withBlock:^{
            @strongify(self)
            [self clickButtonDiscuss:i andIndexPath:indexPath];
        }];
    }
    for (int i = 200; i<205; i++) {
        UIButton *btnMS = (UIButton *)[cell viewWithTag:i];
        [btnMS handleControlEvent:UIControlEventTouchUpInside
                        withBlock:^{
            @strongify(self)
            [self clickButtonDiscuss:i andIndexPath:indexPath];
        }];
    }
    for (int i = 300; i<305; i++) {
        UIButton *btnFH = (UIButton *)[cell viewWithTag:i];
        [btnFH handleControlEvent:UIControlEventTouchUpInside
                        withBlock:^{
            @strongify(self)
            [self clickButtonDiscuss:i andIndexPath:indexPath];
        }];
    }
    for (int i = 400; i<405; i++) {
        UIButton *btnFW = (UIButton *)[cell viewWithTag:i];
        [btnFW handleControlEvent:UIControlEventTouchUpInside
                        withBlock:^{
            @strongify(self)
            [self clickButtonDiscuss:i andIndexPath:indexPath];
        }];
    }return cell;
}

- (void)textViewDidChange:(UITextView *)textView{
    DiscussAttribute *attribute = self.arrDiscuss[textView.tag-10000];
    attribute.strContent = textView.text;
}

- (void)clickButtonDiscuss:(NSInteger)integerTag andIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    DiscussAttribute *attribute = self.arrDiscuss[indexPath.section];
    if (integerTag<200) {
        if (integerTag == 100) {
            attribute.strGood = @"1";
        }
        if (integerTag == 101) {
            attribute.strGood = @"0";
        }
        if (integerTag == 102) {
            attribute.strGood = @"-1";
        }
    }else if (integerTag<300){
        attribute.strMS = StringFormat(@"%d",(int)integerTag-199);
    }else if (integerTag<400){
        attribute.strFH = StringFormat(@"%d",(int)integerTag-299);
    }else if (integerTag<500){
        attribute.strFW = StringFormat(@"%d",(int)integerTag-399);
    }
    D_NSLog(@"self.arrDiscuss is %@",self.arrDiscuss);
    [self.tabDiscuss reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (IBAction)clickButtonCommit:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
    NSMutableArray *arrMiddle = [NSMutableArray array];
    for (int i = 0; i<self.arrDiscuss.count; i++) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        DiscussAttribute *attribute = self.arrDiscuss[i];
        [dictionary setObject:attribute.strContent forKey:@"evaluate_info"];
        [dictionary setObject:attribute.strGood forKey:@"evaluate_good"];
        [dictionary setObject:attribute.strMS forKey:@"evaluate_description"];
        [dictionary setObject:attribute.strFH forKey:@"evaluate_shipments"];
        [dictionary setObject:attribute.strFW forKey:@"evaluate_service"];
        [dictionary setObject:attribute.strGoodsId forKey:@"goodsId"];
        [arrMiddle addObject:dictionary];
    }
    [self.view endEditing:YES];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestFourZeroCommitDiscussOrderID:[NSString stringStandard:self.strOrderId]
                                                                       andOfId:[NSString stringStandard:self.strOfId]
                                                                  andAttribute:arrMiddle
                                                                     andUserID:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]]
                       subscribeNext:^(NSDictionary*dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:dictionary[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDiscussSucceed
                                                                object:self.strOrderId];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
    }];
}

@end

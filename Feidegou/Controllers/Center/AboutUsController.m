//
//  AboutUsController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/18.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AboutUsController.h"
#import "CellTwoLblArrow.h"

@interface AboutUsController ()
@property (weak, nonatomic) IBOutlet UIView *viHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UITableView *tabAboutUs;
@property (strong, nonatomic) NSString *strUrl;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.viHead setBackgroundColor:ColorBackground];
    [self.tabAboutUs setBackgroundColor:ColorBackground];
    self.strUrl = OfficialWebsite;
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    D_NSLog(@"dicInfo is %@",dicInfo);
    [self.lblVersion setText:StringFormat(@"当前版本:v%@",dicInfo[@"CFBundleShortVersionString"])];
    [self.tabAboutUs registerNib:[UINib nibWithNibName:@"CellTwoLblArrow"
                                                bundle:nil]
          forCellReuseIdentifier:@"CellTwoLblArrow"];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        CellTwoLblArrow *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
//        cell.fWidthPre = 10;
//
//        if (indexPath.row == 0) {
//            [cell.lblName setText:@"客服电话"];
//            [cell.lblContent setText:ServicePhone];
//        }
//        return cell;
//    }
    CellTwoLblArrow *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
    cell.fWidthPre = 10;
    
    if (indexPath.row == 1) {
        [cell.lblName setText:@"官方网址"];
        [cell.lblContent setText:self.strUrl];
    }return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.row == 0) {
//        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
//        [alertView showAlertView:self andTitle:nil andMessage:@"是否拨打电话" andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即拨打" andConfirm:^{
//            D_NSLog(@"点击了立即发布");
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:StringFormat(@"tel://%@",ServicePhone)]]; //拨号
//        } andCancel:^{
//            D_NSLog(@"点击了取消");
//        }];
//    }
//    if (indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
        WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
        [controller setTitle:@"官方网站"];
        controller.strWebUrl = self.strUrl;
        [self.navigationController pushViewController:controller animated:YES];
//    }
}

@end

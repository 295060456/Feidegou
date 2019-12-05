//
//  SettingController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "SettingController.h"
#import "CellTwoLblArrow.h"
#import "RegisterViewController.h"
#import "AboutUsController.h"
#import "SDImageCache.h"

@interface SettingController ()
@property (weak, nonatomic) IBOutlet UITableView *tabSet;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.btnLoginOut setBackgroundColor:ColorRed];
    [self.tabSet registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    if ([[PersonalInfo sharedInstance] isLogined]) {
        [self.btnLoginOut setHidden:NO];
    }else{
        [self.btnLoginOut setHidden:YES];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        CellTwoLblArrow *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell.imgArrow setHidden:NO];
    
    if (indexPath.row == 0) {
        cell.fWidthPre = 10;
            [cell.lblName setText:@"清除本地缓存"];
            NSInteger integerSize = [[SDImageCache sharedImageCache] getSize];//[[SDImageCache sharedImageCache] totalDiskSize];
            [cell.lblContent setText:StringFormat(@"%0.2fM",integerSize/1024.0/1024.0)];
        }
        if (indexPath.row == 1) {
            
            cell.fWidthEnd = 0;
            [cell.lblName setText:@"关于我们"];
            [cell.lblContent setText:@""];
        }
        return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self.tabSet reloadData];
        }];
    }
    if (indexPath.row == 1) {
        AboutUsController *controller = [[UIStoryboard storyboardWithName:StoryboardMine bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUsController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonLoginOut:(UIButton *)sender {
    
    JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
    [alertView showAlertView:self andTitle:nil andMessage:@"是否退出登录"  andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即退出" andConfirm:^{
        [[PersonalInfo sharedInstance] deleteLoginUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
    } andCancel:^{
        D_NSLog(@"点击了取消");
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

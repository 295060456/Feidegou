//
//  PersonalInfoController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/3/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "PersonalInfoController.h"
#import "CellTwoLblArrow.h"
#import "CellHeadImg.h"
#import "ChangeHeadImgController.h"
#import "ChangeNameController.h"
#import "OrderesAddressController.h"
#import "PersonalInfoController.h"
#import "JJHttpClient+ShopGood.h"
#import "JJDBHelper+Center.h"
#import "DateSelecet.h"
#import "JJHttpClient+FourZero.h"
#import "AreaSelectController.h"
#import "ChangePswController.h"

@interface PersonalInfoController ()
<datePickerDeleget>

@property (weak, nonatomic) IBOutlet UITableView *tabInfo;
@property (strong, nonatomic) ModelInfo *model;
@property (strong, nonatomic) ModelAddress *modelAddress;
@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabInfo registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    [self.tabInfo registerNib:[UINib nibWithNibName:@"CellHeadImg" bundle:nil] forCellReuseIdentifier:@"CellHeadImg"];
    self.modelAddress = [MTLJSONAdapter modelOfClass:[ModelAddress class] fromJSONDictionary:[NSDictionary dictionary] error:nil];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    __weak PersonalInfoController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodPersonalInfoUserId:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] subscribeNext:^(ModelInfo *model) {
//        把登录信息里面的头像更新
        ModelCenter *modelLogin = [[JJDBHelper sharedInstance] fetchCenterMsg];
        if (![NSString isNullString:model.photoUrl]) {
            modelLogin.head = model.photoUrl;
            [[JJDBHelper sharedInstance] saveCenterMsg:modelLogin];
        }
        [myself refreshView];
    }error:^(NSError *error) {
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshView];
}

- (void)refreshView{
    self.model = [[JJDBHelper sharedInstance] fetchPersonalInfo];
    [self changeArea];
    [self.tabInfo reloadData];
}

- (void)changeArea{
    if ([self.modelAddress.area_id intValue]>0) {
        ModelInfo *model = [[JJDBHelper sharedInstance]  fetchPersonalInfo];
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
        __weak PersonalInfoController *myself = self;
        self.disposable = [[[JJHttpClient new] requestFourZeroChangeInfoUserName:[NSString stringStandard:model.userName]
                                                                    andtelePhone:@""
                                                                      andarea_id:self.modelAddress.area_id
                                                                          andsex:@""
                                                                     andbirthday:@""
                                                                        andemail:@""]
                           subscribeNext:^(NSDictionary*dictionry) {
            if ([dictionry[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                model.region = myself.modelAddress.area;
                [[JJDBHelper sharedInstance] savePersonalInfo:model];
            }else{
                [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
            }
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            myself.modelAddress = [MTLJSONAdapter modelOfClass:[ModelAddress class]
                                            fromJSONDictionary:[NSDictionary dictionary]
                                                         error:nil];
            [myself refreshView];
        }completed:^{
            myself.disposable = nil;
            myself.modelAddress = [MTLJSONAdapter modelOfClass:[ModelAddress class]
                                            fromJSONDictionary:[NSDictionary dictionary]
                                                         error:nil];
            [myself refreshView];
        }];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 0) {
        return 70;
    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 0) {
        CellHeadImg *cell = [tableView dequeueReusableCellWithIdentifier:@"CellHeadImg"];
        [cell.lblName setText:@"头像"];
        cell.fWidthPre = 10;
        cell.fWidthEnd = 10;
        ModelCenter *modelLogin = [[JJDBHelper sharedInstance] fetchCenterMsg];
        [cell.imgHead setImagePathHead:modelLogin.head];
        return cell;
    }else{
        CellTwoLblArrow *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell.imgArrow setHidden:NO];
        cell.fWidthPre = 10;
        cell.fWidthEnd = 10;
        if (indexPath.section == 0) {
            if (indexPath.row ==1) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblName setText:@"用户名称"];
                [cell.lblContent setText:[NSString stringStandard:self.model.userName]];
                [cell.imgArrow setHidden:YES];
            }
            if (indexPath.row == 2) {
                [cell.lblName setText:@"手机号码"];
                NSString *strPhone = self.model.mobile;
                if ([NSString isNullString:strPhone]) {
                    [cell.imgArrow setHidden:NO];
                }else{
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.imgArrow setHidden:YES];
                }
                [cell.lblContent setText:self.model.mobile andTip:@"去绑定"];
            }
            
            if (indexPath.row == 3) {
                [cell.lblName setText:@"所在地区"];
                [cell.lblContent setText:self.model.region andTip:@"未填写"];
            }
            if (indexPath.row == 4) {
                [cell.lblName setText:@"性别"];
                if ([NSString isNullString:self.model.sex]) {
                    [cell.lblContent setText:@"未选择"];
                }else{
                    if ([self.model.sex intValue]==1) {
                        [cell.lblContent setText:@"男"];
                    }else if([self.model.sex intValue]==2){
                        [cell.lblContent setText:@"保密"];
                    }else{
                        [cell.lblContent setText:@"女"];
                    }
                }
            }
            if (indexPath.row == 5) {
                [cell.lblName setText:@"出生日期"];
                [cell.lblContent setText:self.model.birthday_gai andTip:@"未填写"];
            }
        }
        if (indexPath.section == 1) {
            [cell.lblName setText:@"用户邮箱"];
            [cell.lblContent setText:self.model.email andTip:@"未填写"];
        }
        if (indexPath.section == 2) {
            [cell.lblName setText:@"收货地址管理"];
            [cell.lblContent setText:@""];
        }
        if (indexPath.section == 3) {
            [cell.lblName setText:@"账户安全"];
            [cell.lblContent setText:@"" andTip:@"可修改密码"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ChangeHeadImgController *controller = [[UIStoryboard storyboardWithName:StoryboardMine
                                                                             bundle:nil]
                                                   instantiateViewControllerWithIdentifier:@"ChangeHeadImgController"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row == 2) {
            if ([NSString isNullString:self.model.mobile]) {
                ChangeNameController *controller = [[UIStoryboard storyboardWithName:StoryboardMine
                                                                              bundle:nil]
                                                    instantiateViewControllerWithIdentifier:@"ChangeNameController"];
                controller.personalInfo = enum_personalInfo_phone;
                [self.navigationController pushViewController:controller
                                                     animated:YES];
            }
        }
        if (indexPath.row == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder
                                                                 bundle:nil];
            AreaSelectController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaSelectController"];
            controller.model = self.modelAddress;
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }
        if (indexPath.row == 4) {
            [self initSelectSex];
        }
        if (indexPath.row == 5) {
            DateSelecet *viDate = [[DateSelecet alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                SCREEN_WIDTH,
                                                                                SCREEN_HEIGHT)];
            [viDate setDelegate:self];
            NSDate*nowDate = [NSDate date];
            viDate.maximumDate = nowDate;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            ModelInfo *model = [[JJDBHelper sharedInstance] fetchPersonalInfo];
            NSDate *date = [dateFormatter dateFromString:model.birthday_gai];
            if (date != nil) {
                NSComparisonResult result = [nowDate compare:date];
                if (result == NSOrderedDescending) {
                    [viDate setDate:nowDate];
                }else{
                    [viDate setDate:date];
                }
            }
            [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:viDate];
        }
    }
    if (indexPath.section == 1) {
        ChangeNameController *controller = [[UIStoryboard storyboardWithName:StoryboardMine bundle:nil]
                                            instantiateViewControllerWithIdentifier:@"ChangeNameController"];
        controller.personalInfo = enum_personalInfo_email;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    if (indexPath.section == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        OrderesAddressController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderesAddressController"];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    if (indexPath.section == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
        ChangePswController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChangePswController"];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

- (void)dateSelected:(NSString *)strData{
    ModelInfo *model = [[JJDBHelper sharedInstance] fetchPersonalInfo];
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak PersonalInfoController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroChangeInfoUserName:[NSString stringStandard:model.userName]
                                                                andtelePhone:@""
                                                                  andarea_id:@""
                                                                      andsex:@""
                                                                 andbirthday:strData
                                                                    andemail:@""]
                       subscribeNext:^(NSDictionary*dictionry) {
        if ([dictionry[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            model.birthday_gai = strData;
            [[JJDBHelper sharedInstance] savePersonalInfo:model];
            [myself refreshView];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)initSelectSex{
    UIAlertController *alert;
    if (isIPhone) {
        alert = [UIAlertController alertControllerWithTitle:@"性别"
                                                    message:nil
                                             preferredStyle:UIAlertControllerStyleActionSheet];
    }else{
        alert = [UIAlertController alertControllerWithTitle:@"性别"
                                                    message:nil
                                             preferredStyle:UIAlertControllerStyleAlert];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction *actionMan = [UIAlertAction actionWithTitle:@"男"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
        [self requestSex:@"1"];
    }];
    UIAlertAction *actionWoman = [UIAlertAction actionWithTitle:@"女"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action){
        [self requestSex:@"0"];
    }];
    UIAlertAction *actionSecrecy = [UIAlertAction actionWithTitle:@"保密"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
        [self requestSex:@"2"];
    }];
    UIAlertAction *actionCancell = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    [alert addAction:actionMan];
    [alert addAction:actionWoman];
    [alert addAction:actionSecrecy];
    [alert addAction:actionCancell];
}

- (void)requestSex:(NSString *)strSex{
    
    ModelInfo *model = [[JJDBHelper sharedInstance] fetchPersonalInfo];
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak PersonalInfoController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroChangeInfoUserName:[NSString stringStandard:model.userName]
                                                                andtelePhone:@""
                                                                  andarea_id:@""
                                                                      andsex:strSex
                                                                 andbirthday:@""
                                                                    andemail:@""]
                       subscribeNext:^(NSDictionary*dictionry) {
        if ([dictionry[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            model.sex = strSex;
            [[JJDBHelper sharedInstance] savePersonalInfo:model];
            [myself refreshView];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionry[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}


@end

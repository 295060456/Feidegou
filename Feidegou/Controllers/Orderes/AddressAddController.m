//
//  AddressAddController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AddressAddController.h"
#import "AreaSelectController.h"
#import "JJHttpClient+FourZero.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddressAddController ()
<
ABPeoplePickerNavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtNum;
@property (weak, nonatomic) IBOutlet UITextField *txtArea;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressDetail;

@end

@implementation AddressAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self registerLJWKeyboardHandler];
    [self.btnSaveAddress setBackgroundColor:ColorRed];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!self.model) {
        self.model = [[ModelAddress alloc] init];
    }else{
        [self.txtName setText:self.model.trueName];
        [self.txtNum setText:self.model.mobile];
        [self.txtAddressDetail setText:self.model.area_info];
    }
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData{
    [self.txtArea setText:self.model.area];
}

- (IBAction)clickScrollEndEditing:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)clickButtonSaveAddress:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *strName = self.txtName.text;
    if ([NSString isNullString:strName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
        return;
    }
    NSString *strNum = self.txtNum.text;
    if ([NSString isNullString:strNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    NSString *strArea = self.txtArea.text;
    if ([NSString isNullString:strArea]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在区域"];
        return;
    }
    NSString *strDetail = self.txtAddressDetail.text;
    if ([NSString isNullString:strDetail]) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在提交数据..."
                         maskType:SVProgressHUDMaskTypeBlack];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestFourZeroID:self.model.ID
                                                   andDelete:@""
                                                andArea_info:strDetail
                                                   andMobile:strNum
                                                andTelephone:@""
                                                 andTrueName:strName
                                                      andZip:@""
                                                  andArea_id:self.model.area_id
                                                  andUser_id:[[PersonalInfo sharedInstance]
                                                              fetchLoginUserInfo].userId]
                       subscribeNext:^(NSDictionary*dictinary) {
        @strongify(self)
        D_NSLog(@"msg is %@",dictinary[@"msg"]);
        if ([dictinary[@"code"] intValue] == 1) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
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

- (IBAction)clickButtonSelectArea:(UIButton *)sender {
    [self.view endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    AreaSelectController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaSelectController"];
    controller.model = self.model;
    [self.navigationController pushViewController:controller
                                         animated:YES];
}
#pragma mark - <ABPeoplePickerNavigationControllerDelegate>
// 当用户选中某一个联系人时会执行该方法,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person{
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // (__bridge NSString *) : 将对象交给Foundation框架的引用来使用,但是内存不交给它来管理
    // (__bridge_transfer NSString *) : 将对象所有权直接交给Foundation框架的应用,并且内存也交给它来管理
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    
    NSLog(@"%@ %@", lastname, firstname);
    
    [self.txtName setText:StringFormat(@"%@%@",[NSString stringStandard:(__bridge NSString *)lastName],[NSString stringStandard:(__bridge NSString *)firstName])];
    
    // 2.获取选中联系人的电话号码
    // 2.1.获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    // 2.2.遍历拿到每一个电话号码
    if (phoneCount>0) {
        // 2.2.1.获取电话对应的key
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, 0);
        
        // 2.2.2.获取电话号码
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
        [self.txtNum setText:phoneValue];
    }
    
    // 注意:管理内存
    CFRelease(phones);
}

- (IBAction)clickButtonPhone:(UIButton *)sender {
    [self.view endEditing:YES];
    // 1.创建选择联系人的控制器
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    
    // 2.设置代理
    ppnc.peoplePickerDelegate = self;
    
    // 3.弹出控制器
    [self presentViewController:ppnc animated:YES completion:nil];
}

@end

//
//  ApplyForVenderController.m
//  Vendor
//
//  Created by 谭自强 on 2017/4/13.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "ApplyForVenderController.h"
#import "CellTextField.h"
#import "CellTip.h"
#import "CellTwoImg.h"
#import "CellTwoLblArrow.h"
#import "ApplyForVenderAttribute.h"
#import "AreaSelectController.h"
#import "ApplyForTypeController.h"
#import "JJHttpClient+FourZero.h"
#import "JJDBHelper+Center.h"
#import "CellProtocol.h"

@interface ApplyForVenderController ()
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet BaseTableView *tabApplyForVender;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (strong, nonatomic) ApplyForVenderAttribute *attribute;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL isSelected;

@end

@implementation ApplyForVenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = YES;
    self.attribute = [[ApplyForVenderAttribute alloc] init];
    [self.tabApplyForVender registerNib:[UINib nibWithNibName:@"CellTip" bundle:nil]
                 forCellReuseIdentifier:@"CellTip"];
    [self.tabApplyForVender registerNib:[UINib nibWithNibName:@"CellProtocol" bundle:nil]
                 forCellReuseIdentifier:@"CellProtocol"];
    [self.tabApplyForVender registerNib:[UINib nibWithNibName:@"CellTextField" bundle:nil]
                 forCellReuseIdentifier:@"CellTextField"];
    [self.tabApplyForVender registerNib:[UINib nibWithNibName:@"CellTwoImg" bundle:nil]
                 forCellReuseIdentifier:@"CellTwoImg"];
    [self.tabApplyForVender registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil]
                 forCellReuseIdentifier:@"CellTwoLblArrow"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabApplyForVender reloadData];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 8;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30.0f;
    }else if (indexPath.section == 1){
        return 40.0f;
    }else if (indexPath.section == 2){
        return 40.0f;
    }
//    else if (indexPath.section == 3){
//        return 170.0f;
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 1) {
        if (indexPath.row == 3||
            indexPath.row == 4) {
            CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
            NSString *strTip = @"";
            NSString *strPlaceholder = @"";
            NSString *strText = @"";
            if (indexPath.row == 3) {
                strTip = @"店铺分类:";
                strPlaceholder = @"请选择店铺的分类";
                strText = self.attribute.strVendorTypeName;
            }
            if (indexPath.row == 4) {
                strTip = @"所在地区:";
                strPlaceholder = @"请选择店铺的地区";
                strText = self.attribute.strAreaName;
            }
            [cell.lblName setText:strTip];
            if ([NSString isNullString:strText]) {
                [cell.lblContent setText:strPlaceholder];
            }else{
                [cell.lblContent setText:strText];
            }return cell;
        }
        CellTextField *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSString *strTip = @"";
        NSString *strPlaceholder = @"";
        NSString *strText = @"";
        if (indexPath.row == 0) {
            strTip = @"店主姓名:";
            strPlaceholder = @"请输入您的姓名";
            strText = self.attribute.strName;
        }
        if (indexPath.row == 1) {
            strTip = @"身份证号:";
            strPlaceholder = @"请输入您的身份证号码";
            strText = self.attribute.strMemberNum;
        }
        if (indexPath.row == 2) {
            strTip = @"店铺名称:";
            strPlaceholder = @"请输入您的店铺名称";
            strText = self.attribute.strVendorName;
        }
        if (indexPath.row == 5) {
            strTip = @"详细地址:";
            strPlaceholder = @"请输入店铺的详细地址";
            strText = self.attribute.strAddressDetail;
        }
        if (indexPath.row == 6) {
            strTip = @"邮政编码:";
            strPlaceholder = @"请输入店铺所在地邮政编码";
            strText = self.attribute.strZIPCode;
        }
        if (indexPath.row == 7) {
            strTip = @"联系电话:";
            strPlaceholder = @"请输入您的联系电话";
            strText = self.attribute.strPhone;
        }
        [cell.lblTip setText:strTip];
        [cell.txtContent setPlaceholder:strPlaceholder];
        [cell.txtContent setText:strText];
        [cell.txtContent handleTextFieldControlEvent:UIControlEventEditingChanged
                                           withBlock:^{
            @strongify(self)
            NSLog(@"content is %@",cell.txtContent.text);
            
            NSString *strTextChange = cell.txtContent.text;
            if (indexPath.row == 0) {
                self.attribute.strName = strTextChange;
            }
            if (indexPath.row == 1) {
                self.attribute.strMemberNum = strTextChange;
            }
            if (indexPath.row == 2) {
                self.attribute.strVendorName = strTextChange;
            }
            if (indexPath.row == 5) {
                self.attribute.strAddressDetail = strTextChange;
            }
            if (indexPath.row == 6) {
                self.attribute.strZIPCode = strTextChange;
            }
            if (indexPath.row == 7) {
                self.attribute.strPhone = strTextChange;
            }
        }];return cell;
    }
    if (indexPath.section == 2) {
        
        CellProtocol *cell=[tableView dequeueReusableCellWithIdentifier:@"CellProtocol"];
        [cell.btnSelect setSelected:self.isSelected];
        [cell.btnSelect handleControlEvent:UIControlEventTouchUpInside
                                 withBlock:^{
            @strongify(self)
            self.isSelected = !self.isSelected;
            [self.tabApplyForVender reloadData];
        }];
        [cell.lblContent setText:@"商家入驻协议"];
        return cell;
    }
//    if (indexPath.section == 2) {
//        CellTwoImg *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoImg"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.btnRight setHidden:YES];
//        UIImage *img = ImageNamed(@"img_realName_sfzzm");
//        if (indexPath.row == 0) {
//            [cell.lblTip setText:@"上传身份证:"];
//            if (self.attribute.imgMemberCard) {
//                img = self.attribute.imgMemberCard;
//            }
//        }
//        if (indexPath.row == 1) {
//            [cell.lblTip setText:@"上传营业执照:"];
//            if (self.attribute.imgBusiness) {
//                img = self.attribute.imgBusiness;
//            }
//        }
//        [cell.btnLeft setBackgroundImage:img forState:UIControlStateNormal];
//        [cell.btnLeft handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self clickButtonPic:indexPath];
//        }];
//        return cell;
//    }
    CellTip *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTip"];
    [cell.lblTip setTextColor:ColorGary];
    [cell.lblTip setText:@"请填写您的真实信息,通过后将不能修改"];
    [cell setBackgroundColor:ColorFromRGB(254, 248, 241)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||
        section == 1) {
        return 0;
    }else return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                SCREEN_WIDTH,
                                                                10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardApplyForVender bundle:nil];
            ApplyForTypeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ApplyForTypeController"];
            controller.applyForVenderAttribute = self.attribute;
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }
        if (indexPath.row == 4) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
            AreaSelectController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AreaSelectController"];
            controller.applyForVenderAttribute = self.attribute;
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        }
    }
    if (indexPath.section == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
        WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
        [controller setTitle:@"商家入驻协议"];
        controller.strWebUrl = @"http://feidegou.com/doc_store.htm";
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

- (void)clickButtonPic:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    if (IOS_VERSION>=8.0) {
        UIAlertController *alert;
        if (isIPhone) {
            alert = [UIAlertController alertControllerWithTitle:@"上传头像"
                                                        message:nil
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        }else{
            alert = [UIAlertController alertControllerWithTitle:@"上传头像"
                                                        message:nil
                                                 preferredStyle:UIAlertControllerStyleAlert];
        }
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        @weakify(self)
        UIAlertAction *actionZX = [UIAlertAction actionWithTitle:@"马上照一张"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action){
            @strongify(self)
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;//自定义照片样式
            [self presentViewController:pickerImage
                               animated:YES
                             completion:nil];
        }];
        UIAlertAction *actionXC = [UIAlertAction actionWithTitle:@"从相册中选择一张"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
            @strongify(self)
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                pickerImage.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;;
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerImage
                               animated:YES
                             completion:^{}];
        }];
        UIAlertAction *actionCancell = [UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil];
        [alert addAction:actionZX];
        [alert addAction:actionXC];
        [alert addAction:actionCancell];
    }else{
        
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"上传头像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"马上照一张"
                                              otherButtonTitles:@"从相册中选择一张",
                             nil];
        [as showInView:[[[UIApplication sharedApplication] delegate] window]];
    }
}

#pragma mark ------------UIActionSheetDelegate-------------
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *pickerImage;
    switch (buttonIndex) {
        case 0:{
            // for iphone
            pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
            pickerImage.delegate =self;
            pickerImage.allowsEditing =YES;//自定义照片样式
            [self presentViewController:pickerImage animated:YES completion:nil];
            break;
        }
        case 1:{
            pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                pickerImage.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;;
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerImage
                               animated:YES
                             completion:^{}];
            break;
        }
        default:
            break;
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];//获取图
    D_NSLog(@"-----------image is %@ ; image.size.width is %d;image.size.height is %d",image,(int)image.size.width,(int)image.size.height);
    NSData * imageData = UIImageJPEGRepresentation(image,0.2);
    NSUInteger length = [imageData length]/1000;
    D_NSLog(@"length is %ld",length);
    if (self.indexPath.row == 0) {
        self.attribute.imgMemberCard = image;
    }else{
        self.attribute.imgBusiness = image;
    }
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (IBAction)clickButtonCommit:(UIButton *)sender {
    
    if ([NSString isNullString:self.attribute.strName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if (![NSString isCardNum:self.attribute.strMemberNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return;
    }
    if ([NSString isNullString:self.attribute.strVendorName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺名称"];
        return;
    }
    if ([NSString isNullString:self.attribute.strVendorTypeID]) {
        [SVProgressHUD showErrorWithStatus:@"请选择店铺分类"];
        return;
    }
    if ([NSString isNullString:self.attribute.strAreaID]) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
        return;
    }
    if ([NSString isNullString:self.attribute.strAddressDetail]) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺详细地址"];
        return;
    }
    if ([NSString isNullString:self.attribute.strZIPCode]) {
        [SVProgressHUD showErrorWithStatus:@"请输入店铺所在地邮政编码"];
        return;
    }
    if ([NSString isNullString:self.attribute.strPhone]) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话"];
        return;
    }
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"同意商家入驻协议才能继续"];
        return;
    }
//    if (!self.attribute.imgMemberCard) {
//        [SVProgressHUD showErrorWithStatus:@"请上传身份证正面照片"];
//        return;
//    }
//    if (!self.attribute.imgBusiness) {
//        [SVProgressHUD showErrorWithStatus:@"请上传营业执照照片"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestFourZeroApplyForVenderuser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId
                                                                  andstore_ower:self.attribute.strName
                                                             andstore_ower_card:self.attribute.strMemberNum
                                                                  andstore_name:self.attribute.strVendorName
                                                                       andsc_id:self.attribute.strVendorTypeID
                                                                     andarea_id:self.attribute.strAreaID
                                                               andstore_address:self.attribute.strAddressDetail
                                                                   andstore_zip:self.attribute.strZIPCode
                                                              andstore_telphone:self.attribute.strPhone
                                                                   andcard_file:self.attribute.imgMemberCard
                                                                andlicense_file:self.attribute.imgBusiness]
                       subscribeNext:^(NSDictionary*dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            ModelCenter *modelCenter = [[JJDBHelper sharedInstance] fetchCenterMsg];
            modelCenter.store_status = @"1";
            [[JJDBHelper sharedInstance] saveCenterMsg:modelCenter];
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

//
//  ChangeHeadImgController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/3/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ChangeHeadImgController.h"
#import "CellTwoImgOneLbl.h"
#import "JJHttpClient+TwoZero.h"
#import "JJDBHelper+Center.h"

@interface ChangeHeadImgController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tabHeadImag;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (strong, nonatomic) ModelCenter*model;

@end

@implementation ChangeHeadImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[JJDBHelper sharedInstance] fetchCenterMsg];
    [self.imgHead setImagePathHead:self.model.head];
    [self.tabHeadImag registerNib:[UINib nibWithNibName:@"CellTwoImgOneLbl"
                                                 bundle:nil]
           forCellReuseIdentifier:@"CellTwoImgOneLbl"];
    // Do any additional setup after loading the view.
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTwoImgOneLbl *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoImgOneLbl"];
    cell.fWidthPre = 10;
    cell.fWidthEnd = 10;
    [cell.imgSelect setHidden:YES];
    [cell.imgRecommend setHidden:YES];
    if (indexPath.row == 0) {
        [cell.imgHead setImage:ImageNamed(@"img_info_pic")];
        [cell.lblTitle setText:@"从相册选一张"];
    }else{
        [cell.imgHead setImage:ImageNamed(@"img_info_ca")];
        [cell.lblTitle setText:@"拍一张照片"];
    }return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            pickerImage.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;;
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerImage animated:YES completion:^{}];
    }else{
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        [pickerImage setVideoQuality:UIImagePickerControllerQualityTypeLow];
        pickerImage.delegate =self;
        pickerImage.allowsEditing =YES;//自定义照片样式
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];//获取图
    D_NSLog(@"-----------image is %@ ; image.size.width is %d;image.size.height is %d",image,(int)image.size.width,(int)image.size.height);
    NSData * imageData = UIImageJPEGRepresentation(image,0.2);
    NSUInteger length = [imageData length]/1000;
    D_NSLog(@"image size is %ld",(long)length);
    if (imageData) {
        [self requestPostHeadImage:imageData];
    }
    [self.imgHead setImage:[UIImage imageWithData:imageData]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPostHeadImage:(NSData *)data{
    [SVProgressHUD showWithStatus:@"正在上传头像..."];
    ModelCenter *model = [[JJDBHelper sharedInstance] fetchCenterMsg];
    __weak ChangeHeadImgController *myself = self;
    self.disposable = [[[JJHttpClient new] requestHeadImageHead:data
                                                      andUserid:@""]
                       subscribeNext:^(NSDictionary*dictionry) {
        if ([dictionry[@"code"] intValue]==1) {
            model.head = dictionry[@"path"];
            [[JJDBHelper sharedInstance] saveCenterMsg:model];
            [SVProgressHUD showSuccessWithStatus:dictionry[@"msg"]];
            [myself.navigationController popViewControllerAnimated:YES];
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

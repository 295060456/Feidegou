//
//  UpLoadHavePaidVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadHavePaidVC.h"
#import "UpLoadHavePaidVC+VM.h"

@interface UpLoadHavePaidVC ()
<
TZImagePickerControllerDelegate
>

//@property(nonatomic,strong)id requestParams;//父类有
@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation UpLoadHavePaidVC

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    UpLoadHavePaidVC *vc = UpLoadHavePaidVC.new;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navTitle = @"上传已付款凭证";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)upLoadbtnClickEvent:(UIButton *)sender{
    NSLog(@"1234");
    if (self.pic) {
//        [self uploadPic_netWorking:self.pic];
        [self showAlertViewTitle:@"是否确定上传此张图片？"
                         message:@"请再三核对不要选错啦"
                     btnTitleArr:@[@"继续上传",
                                   @"我选错啦"]
                  alertBtnAction:@[@"GoUploadPic",
                                   @"sorry"]];
    }else{
        Toast(@"请点选图片");
    }
}

-(void)GoUploadPic{
    [self uploadPic_netWorking:self.pic];
}

-(TZImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                        delegate:self];
        @weakify(self)
        [_imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,
                                                          NSArray *assets,
                                                          BOOL isSelectOriginalPhoto) {
            @strongify(self)
            if (photos.count == 1) {
                [self.cell reloadPicBtnIMG:photos.lastObject];
                self.pic = photos.lastObject;
            }else{
                [self showAlertViewTitle:@"选择一张相片就够啦"
                                 message:@"不要画蛇添足"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }
        }];
    }return _imagePickerVC;
}

@end

//
//  SiginShowAdverController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/11/5.
//  Copyright © 2018 朝花夕拾. All rights reserved.
//

#import "SiginShowAdverController.h"


#import "GoodsListController.h"
#import "VendorShopTypeController.h"
#import "GoodOtherListController.h"
#import "GoodDetialAllController.h"
#import "VendorDetailShopController.h"
#import "AreaExchangeListController.h"
#import "AchievementController.h"


@interface SiginShowAdverController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAdver;

@end

@implementation SiginShowAdverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imgAdver setImageNoHolder:self.dicShare[@"ad"][@"photo_url"]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)clickButtonAdver:(UIButton *)sender {
    //    <option value="1">专题</option>
    //    <option value="2">分类</option>
    //    <option value="3">网页</option>
    //    <option value="4">线下店</option>
    //    <option value="6">商品</option>
    //    <option value="7">VIP专区</option>
    //    <option value="8">店铺商品列表</option>
    //    <option value="9">店铺详情</option>
    NSString *strType = self.dicShare[@"ad"][@"clickType"];
    if ([NSString isNullString:strType]) {
        return;
    }
    int intType = [strType intValue];
    NSString *strValue = self.dicShare[@"da"][@"clickValue"];
    if (intType == 1) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
        controller.goodActivity = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 2){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
        controller.goodsType_id = strValue;
        controller.isShow = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 3){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
        WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
        [controller setTitle:@"详情"];
        controller.strWebUrl = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 4){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorShopTypeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorShopTypeController"];
        controller.strClas = strValue;
        controller.strTitle = self.dicShare[@"ad"][@"title"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 6){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
        controller.strGood_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 7){
        if ([strValue intValue]==3) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardExchageArea bundle:nil];
            AreaExchangeListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"AreaExchangeListController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
            controller.good_area = strValue;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else if (intType == 8){
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
        controller.strGoods_store_id = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 9){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
        controller.strStoreID = strValue;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (intType == 11){
        if ([[PersonalInfo sharedInstance] isLogined]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMine bundle:nil];
            AchievementController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AchievementController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self pushLoginController];
        }
    }else{
//        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
//        [alertView showAlertView:self andTitle:@"提示" andMessage:@"请更新到最新版本" andCancel:@"确定" andCanelIsRed:YES andBack:^{
//            
//        }];
    }
}


@end

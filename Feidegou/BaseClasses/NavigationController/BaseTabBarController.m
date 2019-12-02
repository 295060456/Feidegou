//
//  BaseTabBarController.m
//  fastdriveVendor
//
//  Created by 谭自强 on 15/10/13.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "BaseTabBarController.h"
//十六进制
#define ColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//Color
#define COLOR_DEFAULT ColorFromHexRGB(0x666666)
#define COLOR_SELECT ColorFromHexRGB(0xf22a2a)

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self dropShadowWithOffset:CGSizeMake(5.0, 5.0) radius:10.0 color:ColorBlack opacity:0.5];
    //设置tabbar字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_DEFAULT,                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_SELECT,                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //首页
    UIViewController *controller_ShopMain = [self controllerWithStoryboardName:StoryboardShopMain
                                                                        title:@"首页"
                                                              normalImageName:@"img_tabbar_main_n"
                                                                   identifier:nil
                                                            selectedImageName:@"img_tabbar_main_s"];
    UIViewController *controller_ShopType = [self controllerWithStoryboardName:StoryboardShopType
                                                                         title:@"分类"
                                                               normalImageName:@"img_tabbar_type"
                                                                    identifier:nil
                                                             selectedImageName:@"img_tabbar_type_s"];
    
    //线下店
//    UIViewController *controller_ShopStore = [self controllerWithStoryboardName:StoryboardVendorDetail
//                                                                         title:@"线下店"
//                                                               normalImageName:@"img_tabbar_vendor_n"
//                                                                    identifier:nil
//                                                             selectedImageName:@"img_tabbar_vendor_s"];

    UIViewController *controller_ShopStore = UIViewController.new;
//    controller_ShopStore.view.backgroundColor = kWhiteColor;
    controller_ShopStore.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    controller_ShopStore.tabBarItem.title = @"线下店";
    controller_ShopStore.tabBarItem.image = [kIMG(@"img_tabbar_vendor_n") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller_ShopStore.tabBarItem.selectedImage = [kIMG(@"img_tabbar_vendor_s") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imgv = UIImageView.new;
    imgv.image = kIMG(@"StayTuned");
    [controller_ShopStore.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2));
//        make.center.equalTo(controller_ShopStore.view);
        make.top.left.right.equalTo(controller_ShopStore.view);
        make.bottom.equalTo(controller_ShopStore.view).offset(-SCALING_RATIO(50));
    }];
    //购物车
    UIViewController *controller_ShopCart = [self controllerWithStoryboardName:StoryboardShopCart
                                                                        title:@"购物车"
                                                              normalImageName:@"img_tabbar_cart_n"
                                                                   identifier:nil
                                                             selectedImageName:@"img_tabbar_cart_s"];
    //个人中心
    UIViewController *controller_Mine = [self controllerWithStoryboardName:StoryboardMine
                                                                         title:@"我的"
                                                               normalImageName:@"img_tabbar_mine_n"
                                                                    identifier:nil
                                                             selectedImageName:@"img_tabbar_mine_s"];
    
    
    self.viewControllers = @[controller_ShopMain,
                             controller_ShopType,
                             controller_ShopStore,
                             controller_ShopCart,
                             controller_Mine];
    [self setSelectedIndex:0];
}

/**
 *  创建TabBarController子viewController
 *
 *  @param name              storyboard Name
 *  @param title             tabBarItem title
 *  @param normalImageName   正常状态下图标名称
 *  @param selectedImageName 选中状态下图标名称
 *
 *  @return UIViewController
 */
-(UIViewController*)controllerWithStoryboardName:(NSString*)name
                                           title:(NSString*)title
                                 normalImageName:(NSString*)normalImageName
                                      identifier:(NSString*)identifier
                               selectedImageName:(NSString*)selectedImageName
{
    
    UIStoryboard *storyboard            = [UIStoryboard storyboardWithName:name bundle:nil];
    
    UIViewController *controller;
    if (identifier) {
        controller        = [storyboard instantiateViewControllerWithIdentifier:identifier];
    }else{
        controller        = [storyboard instantiateInitialViewController];
        
    }
    
    controller.tabBarItem.title         = title;
    controller.tabBarItem.image         = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return controller;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
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

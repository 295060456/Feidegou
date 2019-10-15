//
//  HeaderForURl.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/29.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#ifndef JiandaobaoVendor_HeaderForURl_h
#define JiandaobaoVendor_HeaderForURl_h
//正式
#define Alipay_url_add_money [NSString stringWithFormat:@"%@/alipay/pay_notify.do", BASE_URL]
#define Alipay_url_add_time [NSString stringWithFormat:@"%@/alipay/adServiceMoney.do", BASE_URL]
#define Alipay_url_invite_code [NSString stringWithFormat:@"%@/alipay/inviteCode.do", BASE_URL]
//商城服务器正式地址
//#define BASE_URL @"http://feidegou.com"
#define BASE_URL @"http://116.62.46.26"
#define RELATIVE_PATH_QUERY @"APP/appShop7/query.do?"
#define RELATIVE_PATH_WRITE @"APP/appShop7/write.do?"


//商城服务器测试地址
//#define BASE_URL @"http://feidegou.com:8081"
//#define RELATIVE_PATH_QUERY @"APP/appShop7/query.do?"
//#define RELATIVE_PATH_WRITE @"APP/appShop7/write.do?"



//sotryBoradName
#define StoryboardExchageArea @"ExhangeArea"
#define StoryboardWebService @"WebService"
#define StoryboardMyOrder @"MyOrder"
#define StoryboardLoginAndRegister @"LoginAndRegister"
#define StoryboardShopMain @"ShopMain"
#define StoryboardShopType @"ShopType"
#define StoryboardShopCart @"ShopCart"
#define StoryboardMine @"Mine"
#define StoryboardWithdrawDeposit @"WithdrawDeposit"
#define StoryboardRankingList @"RankingList"
#define StoryboardApplyForVender @"ApplyForVender"
#define StoryboardVendorDetail @"VendorDetail"

//支付宝的返回URL
#define AlipayScheme @"alisdkHaoMei"
//服务电话
#define ServicePhone @"10086"
//官方网址
#define OfficialWebsite BASE_URL
//通知的名字

#define NotificationNameSelectCourse @"NotificationNameSelectCourse"
#define NotificationNameFitlerConfilm @"NotificationNameFitlerConfilm"
#define NotificationNamePaySucceedChangeData @"NotificationNamePaySucceedChangeData"
#define NotificationNameDiscussSucceed @"NotificationNameDiscussSucceed"
#define NotificationNameOrderDelete @"NotificationNameOrderDelete"
#define NotificationNameOrderGetSucceed @"NotificationNameOrderGetSucceed"
#define NotificationNamePaySucceedChangeData @"NotificationNamePaySucceedChangeData"
#define NotificationNamePaySucceed @"NotificationNamePaySucceed"
#define NotificationNameDrawbackMoneySucceed @"NotificationNameDrawbackMoneySucceed"

#define ColorBackground ColorFromHexRGB(0xf5f4fa)
#define ColorCellBack ColorFromHexRGB(0xf5f5f5)
#define ColorGary ColorFromHexRGB(0x666666)
#define ColorGaryDark ColorFromHexRGB(0x8a8a8a)
#define ColorGaryButtom ColorFromHexRGB(0xe1e1e3)
#define ColorLine ColorFromHexRGB(0xe3e4e4)
#define ColorBlack ColorFromHexRGB(0x131313)
#define ColorHeader ColorFromHexRGB(0xf22a2a)
#define ColorRed ColorFromRGB(216, 59, 51)
#define ColorButton ColorHeader
#define ColorGreen ColorFromHexRGB(0x4dc273)
#define ColorYellow ColorFromHexRGB(0xfa9426)



#pragma mark - ===================获取设备大小=====================
//获取屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//获取屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#pragma mark - ===================系统版本========================

//当前设备系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//获取设备当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark - ===================UIImage图片=====================
//读取本地图片
#define LoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type]]

//定义UIImage对象
#define ImageNamed(imageName) [UIImage imageNamed:imageName]

#pragma mark - ===================错误描述信息===========================

#define ERROR_Description(error) [error.userInfo objectForKey:NSLocalizedDescriptionKey]


#pragma mark - ===================颜色类===========================

//清除背景色
#define CLEARCOLOR [UIColor clearColor]
//RGB的颜色
#define ColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//RGB的颜色
#define ColorFromRGBSame(r) [UIColor colorWithRed:r/255.0 green:r/255.0 blue:r/255.0 alpha:1.0]
//十六进制
#define ColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorFromHexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#pragma mark - ===================UserDefaults===========================
//UserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


#pragma mark - ===================GCD===========================

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - ===================打印日志===========================
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"=====> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define D_NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define D_NSLog(FORMAT, ...) nil
#endif

//#ifdef DEBUG
//#define D_NSLog(format, ...) NSLog((@"=====> " format), ## __VA_ARGS__)
//#else
//#define D_NSLog(format, ...)
//#endif



#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)
#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])
#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)


#pragma mark - ===================其它===========================
//
#define StringValue(object) [NSString stringWithFormat:@"%@",object]
#define StringFormat(format,...) [NSString stringWithFormat:format, ##__VA_ARGS__]

#define TransformString(stringChange) [NSString stringWithFormat:@"%@", stringChange]
#define TransformFloat(floatChange) [NSString stringWithFormat:@"%f", floatChange]
#define TransformNSInteger(integerChange) [NSString stringWithFormat:@"%d", integerChange]

//由角度获取弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
//有弧度获取角度
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

#define Tel(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])
//判断是否为手机
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#endif

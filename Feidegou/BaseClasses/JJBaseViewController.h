//
//  JJBaseViewController.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/15.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.


//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG


#import <UIKit/UIKit.h>
#import "JJHttpClient.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
typedef enum {
    enum_exception_timeout
    
}enumException;

@interface JJBaseViewController : UIViewController

@property (nonatomic,strong) RACDisposable *disposable;
@property (nonatomic,strong) UIButton *btnBack;
//返回
-(void)clickButtonBack:(UIButton *)sender;
//添加控件
-(void)locationControls;
//初始化数据源
- (void)initData;
//添加数据
-(void)populateData;
-(void)pushLoginAlert;
-(void)pushLoginController;
-(void)showException;
-(void)hideException;
-(void)showExceptionNoHead;
-(void)failedRequestException:(enumException)exception;

@end

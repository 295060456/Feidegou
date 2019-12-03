//
//  TimeManager.h
//  Feidegou
//
//  Created by Kite on 2019/12/2.
//  Copyright © 2019 朝花夕拾. All rights reserved.
// https://www.jianshu.com/p/b7fab0d6a388

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NSTimer_scheduledTimerWithTimeInterval = 0,
    NSTimer_timerWithTimeInterval
} NSTimerStyle;

NS_ASSUME_NONNULL_BEGIN

@interface TimeManager : NSObject

//+ (instancetype)sharedInstance;
#pragma mark —— GCD
-(void)GCDTimer:(SEL)wantToDo
         caller:(id)caller
       interval:(uint64_t)intervalTime;
//暂停定时器
-(void)suspendGCDTimer;
//取消定时器
-(void)endGCDTimer;
//开启定时器
-(void)startGCDTimer;

#pragma mark —— CAD
-(void)CADTimer:(SEL)wantToDo
         caller:(id)caller
       interval:(uint64_t)intervalTime;
//开启定时器
-(void)startCADTimer;
//取消定时器
-(void)endCADTimer;
//暂停定时器
-(void)suspendCADTimer;

#pragma mark —— NSTimer
-(void)CADTimer:(SEL)wantToDo
     timerStyle:(NSTimerStyle)TimerStyle
         target:(id)aTarget
       userInfo:(nullable id)userInfo
       interval:(NSTimeInterval)interval
        repeats:(BOOL)repeats
         caller:(id)caller
     invocation:(NSInvocation *)invocation
          block:(void (^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
/*
 
1、在某些情况下需要在viewWillDisappear进行释放，而非dealloc 否则会崩，比如在框架JXCategoryView之下
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timeManager endGCDTimer];
    self.timeManager = nil;/Users/whiskey_on_the_rocks/Documents/GitHub管理文件/My_BaseProj_Carthage/MyBaseProj_Carthage/🔨Manual_Add_ThirdParty /Timer/TimeManager.h
}
 
2、一般不用suspend暂停 一般直接end移除timer,用的时候直接本类属性化懒加载start，suspend可能会出现一些问题，在进出界面的时候

3、本类属性化一定要被强硬用，否则其他类进行挂载的时候是为nil
 
 */


//
//  BRStringPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "BRResultModel.h"

typedef NS_ENUM(NSInteger, BRStringPickerMode) {
    /** 单列字符串选择 */
    BRStringPickerComponentSingle = 1,
    /** 多列字符串选择（两列及两列以上） */
    BRStringPickerComponentMulti
};

typedef void(^BRStringResultBlock)(id selectValue);

typedef void(^BRStringResultModelBlock)(BRResultModel *resultModel);

typedef void(^BRStringResultModelArrayBlock)(NSArray <BRResultModel *>*resultModelArr);

@interface BRStringPickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///   【使用方式一】：传统的创建对象设置属性方式，好处是避免使用方式二导致方法参数过多
 ///    1. 初始化选择器（使用 initWithDataSource: 方法）
 ///    2. 设置相关属性；一些公共的属性参见基类文件 BRBaseView.h
 ///    3. 显示选择器（使用 show 方法）
 ////////////////////////////////////////////////////////////////////////*/

/**
 *  1.设置数据源
 *    单列：@[@"男", @"女", @"其他"]
 *    两列：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好", @"及格"]]
 *    多列：... ...
 */
@property (nonatomic, strong) NSArray *dataSourceArr;

/**
 *  2.设置数据源
 *    直接传plist文件名：NSString类型（如：@"sex.plist"），要带后缀名
 *    场景：可以将数据源数据（数组类型）放到plist文件中，直接传plist文件名更加简单
 */
@property (nonatomic, strong) NSString *plistName;

/** 单列设置默认选择的值 */
@property (nonatomic, strong) NSString *selectValue;

/** 多列设置默认选择的值 */
@property (nonatomic, strong) NSArray <NSString *>* selectValueArr;

/** 是否自动选择，即选择完(滚动完)执行结果回调，默认为NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 单列选择结果的回调 */
@property (nonatomic, copy) BRStringResultModelBlock resultModelBlock;

/** 多列选择结果的回调 */
@property (nonatomic, copy) BRStringResultModelArrayBlock resultModelArrayBlock;

/// 初始化字符串选择器
/// @param pickerMode 字符串选择器类型
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;

/// 添加选择器到指定容器视图上
/// @param view 容器视图
- (void)addPickerToView:(UIView *)view;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(UIView *)view;



/**
//////////////////////////////////////////////////////////////////
///   【使用方式二】：快捷使用，直接选择下面其中的一个方法进行使用
////////////////////////////////////////////////////////////////*/

/**
 *  1.显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  2.显示自定义字符串选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

/**
 *  3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");


@end

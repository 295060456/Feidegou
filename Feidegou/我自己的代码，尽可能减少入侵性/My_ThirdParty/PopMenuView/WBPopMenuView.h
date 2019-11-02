//
//  WBPopMenuView.h
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPopMenuView : UIView

@property(nonatomic,assign)CGFloat menuWidth;
@property(nonatomic,assign)CGFloat menuCellHeight;
@property(nonatomic,copy)void(^action)(NSInteger index);
@property(nonatomic,copy)NSArray *menuItem;
@property(nonatomic,strong)UITableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame//悬浮宠物的frame
                    menuWidth:(CGFloat)menuWidth
               menuCellHeight:(CGFloat)menuCellHeight
                        items:(NSArray *)items
                       action:(void(^)(NSInteger index))action;

@end

//
//  WBPopMenuView.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuView.h"
#import "WBTableViewDataSource.h"
#import "WBTableViewDelegate.h"
#import "WBTableViewCell.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

@interface WBPopMenuView ()

@property(nonatomic,strong)WBTableViewDataSource *tableViewDataSource;
@property(nonatomic,strong)WBTableViewDelegate   *tableViewDelegate;
@property(nonatomic,assign)CGRect framer;

@end

@implementation WBPopMenuView

- (instancetype)initWithFrame:(CGRect)frame//悬浮宠物的frame
                    menuWidth:(CGFloat)menuWidth
               menuCellHeight:(CGFloat)menuCellHeight
                        items:(NSArray *)items
                       action:(void(^)(NSInteger index))action{
    if (self = [super init]) {
        self.framer = frame;
        self.menuWidth = menuWidth;
        self.menuCellHeight = menuCellHeight;
        self.menuItem = items;
        self.action = action;
    }return self;
}

-(void)drawRect:(CGRect)rect{
    self.tableView.alpha = 1;
}

- (CGRect)menuFrame {//KKK
    //因为是靠边停靠模式，所以x只有两个值
    CGFloat menuX = 0.f;
    CGFloat menuY = 0.f;
    CGFloat width = self.menuWidth;
    CGFloat heigh = self.menuCellHeight * self.menuItem.count;
    if (self.framer.origin.x == 0) {//Q宠在左边
        menuX = self.menuWidth;
        if (self.framer.origin.y < SCREEN_HEIGHT / 2) {//菜单出现在下边 OK
            menuY = self.framer.size.height;
        }else{//菜单出现在上边
            menuY = self.framer.origin.y - self.framer.size.height - self.menuItem.count * self.menuCellHeight;
        }
    }else{//Q宠在右边
        menuX = SCREEN_WIDTH - self.menuWidth;
        if (self.framer.origin.y < SCREEN_HEIGHT / 2) {//菜单出现在下边
            menuY = self.framer.size.height;
        }else{//菜单出现在上边
            menuY = self.framer.origin.y - self.framer.size.height - self.menuItem.count * self.menuCellHeight;
        }
    }return (CGRect){
        menuX,
        menuY,
        width,
        heigh
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    
    [[WBPopMenuSingleton shareManager] hideMenu];
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[self menuFrame]
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self.tableViewDataSource;
        _tableView.delegate = self.tableViewDelegate;
        _tableView.layer.cornerRadius = 10.0f;
        _tableView.layer.anchorPoint = CGPointMake(1.0, 0);
        _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        _tableView.rowHeight = 40;
        [self addSubview:_tableView];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }return _tableView;
}

-(WBTableViewDataSource *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource = [[WBTableViewDataSource alloc]initWithItems:self.menuItem
                                                                 cellClass:[WBTableViewCell class]
                                                        configureCellBlock:^(WBTableViewCell *cell,
                                                                             WBPopMenuModel *model) {
            WBTableViewCell *tableViewCell = (WBTableViewCell *)cell;
            tableViewCell.textLabel.text = model.title;
            tableViewCell.imageView.image = [UIImage imageNamed:model.image];
        }];
    }return _tableViewDataSource;
}

-(WBTableViewDelegate *)tableViewDelegate{
    if (!_tableViewDelegate) {
        @weakify(self)
        _tableViewDelegate = [[WBTableViewDelegate alloc] initWithDidSelectRowAtIndexPath:^(NSInteger indexRow) {
            @strongify(self)
            if (self.action) {
                self.action(indexRow);
            }
        }];
    }return _tableViewDelegate;
}

@end

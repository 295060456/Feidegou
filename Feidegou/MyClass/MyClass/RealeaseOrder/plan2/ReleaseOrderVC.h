//
//  RealeaseOrderVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/30.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

typedef enum : NSUInteger {
    ReleaseOrderTBVCellType_Textfield = 0,
    ReleaseOrderTBVCellType_Lab,
    ReleaseOrderTBVCellType_Btn,
    ReleaseOrderTBVCellType_TextfieldOnly
} ReleaseOrderTBVCellType;

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseOrder_viewForHeader : ViewForHeader

@end

@interface ReleaseOrderTBVCell : TBVCell_style_01

@property(nonatomic,strong)HistoryDataListTBV *historyDataListTBV;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UITextField *textfield;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model
            ReleaseOrderTBVCellType:(ReleaseOrderTBVCellType)type;
-(void)actionBlock:(DataBlock)block;
-(void)btnClickEventBlock:(ThreeDataBlock)block;
-(void)dataBlock:(DataBlock)block;

@end

@interface ReleaseOrderVC : BaseVC

@property(nonatomic,copy)__block NSString *str_1;//数量
@property(nonatomic,copy)__block NSString *str_2;//最低限额
@property(nonatomic,copy)__block NSString *str_3;//最高限额
@property(nonatomic,copy)__block NSString *str_4;//收款方式
@property(nonatomic,copy)__block NSString *str_5;//微信账号
@property(nonatomic,copy)__block NSString *str_6;//支付宝账号
@property(nonatomic,copy)__block NSString *str_7;//银行卡账号
@property(nonatomic,copy)__block NSString *str_8;//姓名
@property(nonatomic,copy)__block NSString *str_9;//银行类型
@property(nonatomic,copy)__block NSString *str_10;//支行信息
@property(nonatomic,copy)__block NSString *str_11;//单价
@property(nonatomic,strong)id requestParams;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
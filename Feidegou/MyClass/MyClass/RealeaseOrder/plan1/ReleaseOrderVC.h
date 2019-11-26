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

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model
            ReleaseOrderTBVCellType:(ReleaseOrderTBVCellType)type;

-(void)dataBlock:(DataBlock)block;
-(void)actionBlock:(DataBlock)block;

@end

@interface ReleaseOrderVC : BaseVC

@property(nonatomic,strong)BaseTableViewer *tableView;

@property(nonatomic,copy)__block NSString *str_1;//数量
@property(nonatomic,copy)__block NSString *str_2;//最低限额
@property(nonatomic,copy)__block NSString *str_3;//最高限额
@property(nonatomic,copy)__block NSString *str_4;//收款方式
@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)__block ReleaseOrderModel *releaseOrderModel;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

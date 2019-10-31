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
+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model
            ReleaseOrderTBVCellType:(ReleaseOrderTBVCellType)type;
-(void)actionBlock:(DataBlock)block;
-(void)btnClickEventBlock:(ThreeDataBlock)block;

@end

@interface ReleaseOrderVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

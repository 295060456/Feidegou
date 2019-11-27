//
//  CreateTeamVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

//CreateTeamVC
@interface InvitationCodeTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
-(void)richElementsInCellWithModel:(id _Nullable)model;
-(void)actionBlock:(DataBlock)block;

@end

@interface CreateTeamVC : BaseVC

@property(nonatomic,weak)LoginViewController *loginVC;
@property(nonatomic,strong)UIButton *sendBtn;

@property(nonatomic,copy)__block NSString *telePhoneStr;
@property(nonatomic,copy)__block NSString *QQStr;
@property(nonatomic,copy)__block NSString *wechatStr;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

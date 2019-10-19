//
//  ViewForTypeSelectLeftSlide.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/1.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ViewForTypeSelectLeftSlide.h"
#import "CLCellGoodTypeHead.h"
#import "TypeSelectFunction.h"
#import "UIButton+Joker.h"
@interface ViewForTypeSelectLeftSlide()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (strong, nonatomic) UIView *viBack;
@property (strong, nonatomic) UIView *viContent;
@property (strong, nonatomic) UIView *viHead;
@property (strong, nonatomic) UILabel *lblPrice;
@property (strong, nonatomic) UITextField *txtPriceBegin;
@property (strong, nonatomic) UITextField *txtPriceEnd;
@property (strong, nonatomic) UICollectionView *collectionViewType;
@property (strong, nonatomic) NSMutableArray *arrSelectedIsHidden;
//@property (strong, nonatomic) NSMutableArray *arrType;

@end


extern NSMutableArray *arrTypeSelected;
extern NSString *strPriceStart;
extern NSString *strPriceEnd;
@implementation ViewForTypeSelectLeftSlide

- (instancetype)initWithFrame:(CGRect)frame
                     andArray:(NSArray *)array{
    
    if (self = [super initWithFrame:frame]) {
//        隐藏按钮
        self.viBack = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT)];
        [self.viBack setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [self addSubview:self.viBack];
        
        UIButton *btnHidden = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT)];
        [btnHidden addTarget:self action:@selector(clickButtonHidden:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHidden];
        [self setClipsToBounds:YES];
        self.viContent = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,
                                                                  0,
                                                                  SCREEN_WIDTH-40,
                                                                  SCREEN_HEIGHT)];
        [self.viContent setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.viContent];
        
        self.viHead = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               20,
                                                               CGRectGetWidth(self.viContent.frame),
                                                               110)];
        [self.viHead setBackgroundColor:[UIColor whiteColor]];
        [self.viContent addSubview:self.viHead];
        UIButton *btnEndEditing = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             CGRectGetWidth(self.viHead.frame),
                                                                             CGRectGetHeight(self.viHead.frame))];
        [btnEndEditing addTarget:self action:@selector(clickButtonEndEditing:) forControlEvents:UIControlEventTouchUpInside];
        [self.viHead addSubview:btnEndEditing];
        
        self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                  0,
                                                                  105,
                                                                  30)];
        [self.lblPrice setFont:[UIFont systemFontOfSize:15]];
        [self.lblPrice setText:@"价格区间"];
        [self.viHead addSubview:self.lblPrice];
        self.txtPriceBegin = [[UITextField alloc] initWithFrame:CGRectMake(30,
                                                                           CGRectGetMaxY(_lblPrice.frame)+10,
                                                                           (CGRectGetWidth(self.viHead.frame)-60-10)/2,
                                                                           30)];
        [self.txtPriceBegin setFont:[UIFont systemFontOfSize:15.0]];
        [self.txtPriceBegin setBackgroundColor:ColorBackground];
        [self.txtPriceBegin setPlaceholder:@"最低价格"];
        [self.txtPriceBegin setTextAlignment:NSTextAlignmentCenter];
        [self.txtPriceBegin setBorderStyle:UITextBorderStyleRoundedRect];
        [self.txtPriceBegin setText:strPriceStart];
        [self.viHead addSubview:self.txtPriceBegin];
        
        self.txtPriceEnd = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.txtPriceBegin.frame)+10,
                                                                         CGRectGetMinY(self.txtPriceBegin.frame),
                                                                         CGRectGetWidth(self.txtPriceBegin.frame),
                                                                         CGRectGetHeight(self.txtPriceBegin.frame))];
        [self.txtPriceEnd setPlaceholder:@"最高价格"];
        [self.txtPriceEnd setFont:[UIFont systemFontOfSize:15.0]];
        [self.txtPriceEnd setBackgroundColor:ColorBackground];
        [self.txtPriceEnd setTextAlignment:NSTextAlignmentCenter];
        [self.txtPriceEnd setBorderStyle:UITextBorderStyleRoundedRect];
        [self.txtPriceEnd setText:strPriceEnd];
        [self.viHead addSubview:self.txtPriceEnd];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.viContent.frame)/3, 40);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
        layout.sectionInset = UIEdgeInsetsMake(0.f,
                                               0,
                                               0.f,
                                               0);
        layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.viContent.frame), 30);
        self.collectionViewType = [[UICollectionView alloc]initWithFrame:CGRectMake(0,
                                                                                    CGRectGetMaxY(self.viHead.frame),
                                                                                    CGRectGetWidth(self.viContent.frame),
                                                                                    SCREEN_HEIGHT-CGRectGetMaxY(self.viHead.frame)-40)
                                                    collectionViewLayout:layout];
        self.collectionViewType.delegate = self;
        self.collectionViewType.dataSource =self;
        self.collectionViewType.backgroundColor = [UIColor whiteColor];
        [self.viContent addSubview:self.collectionViewType];
        [self.collectionViewType registerClass:[CLCellGoodTypeHead class]
                    forCellWithReuseIdentifier:@"CLCellGoodTypeHead"];
        [self.collectionViewType registerClass:[UICollectionReusableView class]
                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                           withReuseIdentifier:@"reusableView"];

        UIView *viButton = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMaxY(self.collectionViewType.frame),
                                                                    CGRectGetWidth(self.viContent.frame),
                                                                    40)];
        
        UIButton *btnReset = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        CGRectGetWidth(viButton.frame)/2,
                                                                        CGRectGetHeight(viButton.frame))];
        [btnReset addTarget:self action:@selector(clickButtonReset:) forControlEvents:UIControlEventTouchUpInside];
        [btnReset.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btnReset setTitle:@"重置" forState:UIControlStateNormal];
        [btnReset setTitleColor:ColorBlack forState:UIControlStateNormal];
        [btnReset setBackgroundColor:[UIColor whiteColor]];
        [viButton addSubview:btnReset];
        
        UIButton *btnConfilm = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnReset.frame),
                                                                          0,
                                                                          CGRectGetWidth(viButton.frame)/2,
                                                                          CGRectGetHeight(viButton.frame))];
        [btnConfilm addTarget:self
                       action:@selector(clickButtonConfilm:)
             forControlEvents:UIControlEventTouchUpInside];
        [btnConfilm.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btnConfilm setTitle:@"确定" forState:UIControlStateNormal];
        [btnConfilm setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [btnConfilm setBackgroundColor:ColorRed];
        [viButton addSubview:btnConfilm];
        
        UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     0.5)];
        [lblLine setBackgroundColor:ColorLine];
        [viButton addSubview:lblLine];
        
        [self.viContent addSubview:viButton];
        [self showViewAnimaiton];
    }return self;
}

- (void)clickButtonEndEditing:(UIButton *)sender{
    [self endEditing:YES];
}

- (void)clickButtonReset:(UIButton *)sender{
    for (int i = 0; i<arrTypeSelected.count; i++) {
        //    选择的第几个大类
        NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[i]];
        //    大类里面的数组
        NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
        //    数组里面的最细分类
        
        for (int j = 0; j<arrValue.count; j++) {
            NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[j]];
            if ([dicMiddle[IsSelected] intValue]==2) {
                [dicMiddle setObject:@"0" forKey:IsSelected];
            }else if ([dicMiddle[IsSelected] intValue]==1) {
                [dicMiddle setObject:@"3" forKey:IsSelected];
            }
            [arrValue replaceObjectAtIndex:j withObject:dicMiddle];
        }
        [dicType setObject:arrValue forKey:@"value"];
        [arrTypeSelected replaceObjectAtIndex:i withObject:dicType];
    }
    [self.collectionViewType reloadData];
}

- (void)clickButtonConfilm:(UIButton *)sender{
    strPriceStart = self.txtPriceBegin.text;
    strPriceEnd = self.txtPriceEnd.text;
    [self transToCollectConfilm];
    [self sendNewType];
    [self clickButtonHidden:nil];
}

- (void)sendNewType{
    if ([self.delegete respondsToSelector:@selector(clickConfilmAndTheResult)]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameFitlerConfilm object:nil];
        [self.delegete clickConfilmAndTheResult];
    }
}
#pragma mark --- 恢复所选择的
- (void)transToCollectConfilmNot{
    for (int i = 0; i<arrTypeSelected.count; i++) {
        
        //    选择的第几个大类
        NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[i]];
        //    大类里面的数组
        NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
        //    数组里面的最细分类
        
        for (int j = 0; j<arrValue.count; j++) {
            NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[j]];
            if ([dicMiddle[IsSelected] intValue]==2) {
                [dicMiddle setObject:@"0" forKey:IsSelected];
            }else if ([dicMiddle[IsSelected] intValue]==3) {
                [dicMiddle setObject:@"1" forKey:IsSelected];
            }
            [arrValue replaceObjectAtIndex:j withObject:dicMiddle];
        }
        [dicType setObject:arrValue forKey:@"value"];
        [arrTypeSelected replaceObjectAtIndex:i withObject:dicType];
    }
    [self.collectionViewType reloadData];
}
#pragma mark --- 确定所选择的
- (void)transToCollectConfilm{
    for (int i = 0; i<arrTypeSelected.count; i++) {
        //    选择的第几个大类
        NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[i]];
        //    大类里面的数组
        NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
        //    数组里面的最细分类
        
        for (int j = 0; j<arrValue.count; j++) {
            NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[j]];
            if ([dicMiddle[IsSelected] intValue]==2) {
                [dicMiddle setObject:@"1" forKey:IsSelected];
            }else if ([dicMiddle[IsSelected] intValue]==3) {
                [dicMiddle setObject:@"0" forKey:IsSelected];
            }
            [arrValue replaceObjectAtIndex:j withObject:dicMiddle];
        }
        [dicType setObject:arrValue forKey:@"value"];
        [arrTypeSelected replaceObjectAtIndex:i withObject:dicType];
    }
    [self.collectionViewType reloadData];
}
- (void)showViewAnimaiton{
    CGRect rect = self.viContent.frame;
    rect.origin.x = 40;
    @weakify(self)
    [UIView animateWithDuration:0.27
                     animations:^{
        @strongify(self)
        [self.viContent setFrame:rect];
        [self.viBack setAlpha:1.0];
    }completion:^(BOOL finished){
    }];
    [self reloadCollectionView];
}
- (void)clickButtonHidden:(UIButton *)sender{
    [self endEditing:YES];
    CGRect rect = self.viContent.frame;
    rect.origin.x = SCREEN_WIDTH;
    @weakify(self)
    [UIView animateWithDuration:0.27
                     animations:^{
        @strongify(self)
        [self.viContent setFrame:rect];
        [self.viBack setAlpha:0.0];
    }completion:^(BOOL finished){
        @strongify(self)
        [self transToCollectConfilmNot];
        [self reloadCollectionView];
        [self removeFromSuperview];
    }];
}

- (void)reloadCollectionView{
    [self.collectionViewType reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    NSArray *arrNum = arrTypeSelected[section][@"value"];
    
    BOOL isShowAll = [arrTypeSelected[section][IsAll] boolValue];
    if (!isShowAll) {
        NSInteger integerMax= 3;
        if (arrNum.count>integerMax) {
            return integerMax;
        }
    }return arrNum.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return arrTypeSelected.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicInfo = arrTypeSelected[indexPath.section][@"value"][indexPath.row];
    
    static NSString *identifier = @"CLCellGoodTypeHead";
    CLCellGoodTypeHead *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.viLbel.layer setBorderWidth:0.5];
    [cell.lblLine setHidden:YES];
    [cell.viBack setHidden:YES];
    if ([dicInfo[IsSelected] intValue]== 1||[dicInfo[IsSelected] intValue]== 2) {
        [cell.lblContent setTextNull:StringFormat(@"√ %@",dicInfo[TypeName])];
        [cell.lblContent setTextColor:ColorRed];
        [cell.viLbel setBackgroundColor:[UIColor whiteColor]];
        [cell.viLbel.layer setBorderColor:ColorRed.CGColor];
    }else{
        [cell.lblContent setTextNull:dicInfo[TypeName]];
        [cell.lblContent setTextColor:ColorBlack];
        [cell.viLbel setBackgroundColor:ColorBackground];
        [cell.viLbel.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(self.viContent.frame)/3,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,
                            0,
                            10,
                            0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"reusableView"
                                                                                         forIndexPath:indexPath];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
        UILabel *lblAll = (UILabel *)[headerView viewWithTag:101];
        UIImageView *imgAll = (UIImageView *)[headerView viewWithTag:102];
        UIButton *btnAll = (UIButton *)[headerView viewWithTag:103];
        [lblHead removeFromSuperview];
        [lblAll removeFromSuperview];
        [imgAll removeFromSuperview];
        [btnAll removeFromSuperview];
        lblHead = nil;
        lblAll = nil;
        imgAll = nil;
        btnAll = nil;
        if (!lblHead) {
            lblHead = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, CGRectGetHeight(headerView.frame))];
            [lblHead setFont:[UIFont systemFontOfSize:15]];
            [lblHead setTag:100];
            imgAll = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.viContent.frame)-10-14,
                                                                   0,
                                                                   14,
                                                                   CGRectGetHeight(headerView.frame))];
            [imgAll setContentMode:UIViewContentModeScaleAspectFit];
            [imgAll setTag:102];
            lblAll = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblHead.frame)+5,
                                                               0,
                                                               CGRectGetMinX(imgAll.frame)-5-CGRectGetMaxX(lblHead.frame)-5,
                                                               CGRectGetHeight(headerView.frame))];
            [lblAll setFont:[UIFont systemFontOfSize:13]];
            [lblAll setTextAlignment:NSTextAlignmentRight];
            [lblAll setTag:101];
            btnAll = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblAll.frame),
                                                                0,
                                                                CGRectGetMaxX(imgAll.frame)-CGRectGetMinX(lblAll.frame),
                                                                CGRectGetHeight(headerView.frame))];
            [headerView addSubview:lblHead];
            [headerView addSubview:lblAll];
            [headerView addSubview:imgAll];
            [headerView addSubview:btnAll];
        }
        [btnAll handleControlEvent:UIControlEventTouchUpInside
                         withBlock:^{
            @strongify(self)
            [self refreshDataIndexPath:indexPath];
        }];
        BOOL isShowAll = [arrTypeSelected[indexPath.section][IsAll] boolValue];
        if (isShowAll) {
            [imgAll setImage:ImageNamed(@"img_arrow_up")];
        }else{
            [imgAll setImage:ImageNamed(@"img_arrow_down")];
        }
        NSString *strType = [self getNameByIndexPath:indexPath];
        if ([NSString isNullString:strType]) {
            [lblAll setText:@"全部"];
            [lblAll setTextColor:ColorGary];
        }else{
            [lblAll setText:strType];
            [lblAll setTextColor:ColorRed];
        }
        [lblHead setText:TransformString(arrTypeSelected[indexPath.section][@"name"])];
        reusableview = headerView;
    }return reusableview;
}

- (NSString *)getNameByIndexPath:(NSIndexPath *)indexPath{
    NSString *strName = arrTypeSelected[indexPath.section][@"name"];
    NSMutableArray *arrMiddle = [NSMutableArray array];
    
    NSArray *arrValue = [NSArray arrayWithArray:arrTypeSelected[indexPath.section][@"value"]];
    for (int j = 0; j<arrValue.count; j++) {
        if ([arrValue[j][IsSelected] intValue] == 1||[arrValue[j][IsSelected] intValue] == 2) {
            [arrMiddle addObject:arrValue[j][TypeName]];
        }
    }
    NSString *strValue = @"";
    if (arrMiddle.count>0) {
        strValue = [arrMiddle componentsJoinedByString:@","];
        D_NSLog(@"name is %@,value is %@",strName,strValue);
        
    }return strValue;
}

- (void)refreshDataIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    D_NSLog(@"indexPath section is %ld,row is %ld",(long)indexPath.section,(long)indexPath.row);
    NSMutableDictionary *dicSection = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[indexPath.section]];
    if ([dicSection[IsAll] boolValue]) {
        [dicSection setObject:@"0" forKey:IsAll];
    }else{
        [dicSection setObject:@"1" forKey:IsAll];
    }
    [arrTypeSelected replaceObjectAtIndex:indexPath.section withObject:dicSection];
    [self.collectionViewType reloadData];
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    //    选择的第几个大类
    NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[indexPath.section]];
    //    大类里面的数组
    NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
    //    数组里面的最细分类
    NSMutableDictionary *dicTypeSelected = [NSMutableDictionary dictionaryWithDictionary:arrValue[indexPath.row]];
    //        不等于0 则变成2，结束时如果确定，则2变成1，否则2变成0
    if ([dicTypeSelected[IsSelected] intValue]==0) {
        if ([self isCanSelectMore:arrValue]) {
            [dicTypeSelected setObject:@"2" forKey:IsSelected];
        }
    }else if ([dicTypeSelected[IsSelected] intValue]==1) {
        [dicTypeSelected setObject:@"3" forKey:IsSelected];
    }else if ([dicTypeSelected[IsSelected] intValue]==2) {
        [dicTypeSelected setObject:@"0" forKey:IsSelected];
    }else if([dicTypeSelected[IsSelected] intValue]==3) {
        if ([self isCanSelectMore:arrValue]) {
            [dicTypeSelected setObject:@"1" forKey:IsSelected];
        }
    }
    [arrValue replaceObjectAtIndex:indexPath.row withObject:dicTypeSelected];
    [dicType setObject:arrValue forKey:@"value"];
    [arrTypeSelected replaceObjectAtIndex:indexPath.section withObject:dicType];
    [self.collectionViewType reloadData];
}
#pragma mark -- 查看是否还能选择更多
- (BOOL)isCanSelectMore:(NSArray *)array{
    int intNum = 0;
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        if ([dicMiddle[IsSelected] intValue] == 1||
            [dicMiddle[IsSelected] intValue] == 2) {
            intNum++;
        }
    }
    if (intNum>=5) {
        [SVProgressHUD showErrorWithStatus:@"最多只能选择五个哦"];
        return NO;
    }return YES;
}

- (NSString *)getTheStringOfTypeSelected:(NSInteger)integer{
    NSString *strName = @"";
    NSArray *arrType = [NSArray arrayWithArray:arrTypeSelected[integer][@"value"]];
    for (int i = 0; i<arrType.count; i++) {
        if ([arrType[i][IsSelected] intValue] == 1) {
            if ([NSString isNullString:strName]) {
                strName = StringFormat(@"%@",arrType[i][TypeName]);
            }else{
                strName = StringFormat(@"%@,%@",strName,arrType[i][TypeName]);
            }
        }
    }return strName;
}

@end

//
//  ViewForTypeSelect.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ViewForTypeSelect.h"
#import "CLCellTypeSelected.h"
#import "CLCellSelectedNo.h"
#import "CLCellGoodTypeHead.h"
#define IsSelected @"isSelected"
#define TypeName @"typeName"
@interface ViewForTypeSelect()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIView *viHead;
@property (assign, nonatomic) CGRect rectSelf;
@property (strong, nonatomic) UICollectionView *collectionViewType;
@property (strong, nonatomic) UICollectionView *collectionViewTypeHead;
//@property (strong, nonatomic) NSMutableArray *arrType;
@property (assign, nonatomic) NSInteger integerTypeBig;
@property (assign, nonatomic) BOOL isShow;
@end
extern NSMutableArray *arrTypeSelected;
@implementation ViewForTypeSelect

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btnHidden = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [btnHidden addTarget:self action:@selector(clickButtonHidden:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHidden];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        self.rectSelf = frame;
        self.viHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self.viHead setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.viHead];
        UIButton *btnShow = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [btnShow addTarget:self action:@selector(clickButtonShow:) forControlEvents:UIControlEventTouchUpInside];
        [self.viHead addSubview:btnShow];
        
//        self.arrType = [NSMutableArray array];
//        for (int i = 0; i<array.count; i++) {
//            NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:array[i]];
//            
//            NSString *strName = dicMiddle[@"name"];
//            NSString *strValue = dicMiddle[@"value"];
//            NSArray *arrValue = [strValue componentsSeparatedByString:@","];
//            
//            NSMutableArray *arrSelected = [NSMutableArray array];
//            for (int j = 0; j<arrValue.count; j++) {
//                NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
//                [dicValue setObject:arrValue[j] forKey:TypeName];
//                [dicValue setObject:@"" forKey:IsSelected];
//                [arrSelected addObject:dicValue];
//            }
//            [dicMiddle setObject:strName forKey:@"name"];
//            [dicMiddle setObject:arrSelected forKey:@"value"];
//            [self.arrType addObject:dicMiddle];
//        }
//        D_NSLog(@"arrType is %@",self.arrType);
//        arrTypeSelected = [NSMutableArray arrayWithArray:self.arrType];
        
        self.integerTypeBig = 0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 40);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
        layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
        
        self.collectionViewType = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.viHead.frame), SCREEN_WIDTH, 200) collectionViewLayout:layout];
        self.collectionViewType.delegate = self;
        self.collectionViewType.dataSource =self;
        self.collectionViewType.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionViewType];
        [self.collectionViewType registerClass:[CLCellTypeSelected class] forCellWithReuseIdentifier:@"CLCellTypeSelected"];
        [self.collectionViewType registerClass:[CLCellSelectedNo class] forCellWithReuseIdentifier:@"CLCellSelectedNo"];
        
        
        UICollectionViewFlowLayout *layoutHead = [[UICollectionViewFlowLayout alloc]init];
        layoutHead.itemSize = CGSizeMake(SCREEN_WIDTH/4, 40);
        layoutHead.minimumInteritemSpacing = 0;
        layoutHead.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
        [layoutHead setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layoutHead.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
        self.collectionViewTypeHead = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) collectionViewLayout:layoutHead];
        self.collectionViewTypeHead.delegate = self;
        self.collectionViewTypeHead.dataSource =self;
        self.collectionViewTypeHead.backgroundColor = [UIColor whiteColor];
        [self.viHead addSubview:self.collectionViewTypeHead];
        [self.collectionViewTypeHead registerClass:[CLCellGoodTypeHead class] forCellWithReuseIdentifier:@"CLCellGoodTypeHead"];
        
        UIView *viButton = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionViewType.frame), SCREEN_WIDTH, 40)];
        
        UIButton *btnReset = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, CGRectGetHeight(viButton.frame))];
        [btnReset addTarget:self action:@selector(clickButtonReset:) forControlEvents:UIControlEventTouchUpInside];
        [btnReset.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btnReset setTitle:@"重置" forState:UIControlStateNormal];
        [btnReset setTitleColor:ColorBlack forState:UIControlStateNormal];
        [btnReset setBackgroundColor:[UIColor whiteColor]];
        [viButton addSubview:btnReset];
        
        UIButton *btnConfilm = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnReset.frame), 0, SCREEN_WIDTH/2, CGRectGetHeight(viButton.frame))];
        [btnConfilm addTarget:self action:@selector(clickButtonConfilm:) forControlEvents:UIControlEventTouchUpInside];
        [btnConfilm.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btnConfilm setTitle:@"确定" forState:UIControlStateNormal];
        [btnConfilm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnConfilm setBackgroundColor:ColorRed];
        [viButton addSubview:btnConfilm];
        
        UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [lblLine setBackgroundColor:ColorLine];
        [viButton addSubview:lblLine];
        
        [self addSubview:viButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationFitlerConfilm:) name:NotificationNameFitlerConfilm object:nil];
    }
    return self;
}
- (void)NotificationFitlerConfilm:(NSNotification *)notifacation{
    [self reloadCollectionView];
}
- (void)clickButtonReset:(UIButton *)sender{
    //    选择的第几个大类
    NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[self.integerTypeBig]];
    //    大类里面的数组
    NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
    //    数组里面的最细分类
    
    for (int i = 0; i<arrValue.count; i++) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[i]];
        if ([dicMiddle[IsSelected] intValue]==2) {
            [dicMiddle setObject:@"0" forKey:IsSelected];
        }else if ([dicMiddle[IsSelected] intValue]==1) {
            [dicMiddle setObject:@"3" forKey:IsSelected];
        }
        [arrValue replaceObjectAtIndex:i withObject:dicMiddle];
    }
    [dicType setObject:arrValue forKey:@"value"];
    [arrTypeSelected replaceObjectAtIndex:self.integerTypeBig withObject:dicType];
    [self.collectionViewType reloadData];
}
- (void)clickButtonConfilm:(UIButton *)sender{
    [self transToCollectConfilm];
    [self sendNewType];
    [self clickButtonHidden:nil];
}
- (void)sendNewType{
    if ([self.delegete respondsToSelector:@selector(clickConfilmAndTheResult)]) {
        [self.delegete clickConfilmAndTheResult];
    }
}
#pragma mark --- 恢复所选择的
- (void)transToCollectConfilmNot{
    //    选择的第几个大类
    NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[self.integerTypeBig]];
    //    大类里面的数组
    NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
    //    数组里面的最细分类
    
    for (int i = 0; i<arrValue.count; i++) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[i]];
        if ([dicMiddle[IsSelected] intValue]==2) {
            [dicMiddle setObject:@"0" forKey:IsSelected];
        }else if ([dicMiddle[IsSelected] intValue]==3) {
            [dicMiddle setObject:@"1" forKey:IsSelected];
        }
        [arrValue replaceObjectAtIndex:i withObject:dicMiddle];
    }
    [dicType setObject:arrValue forKey:@"value"];
    [arrTypeSelected replaceObjectAtIndex:self.integerTypeBig withObject:dicType];
    [self.collectionViewType reloadData];
}
#pragma mark --- 确定所选择的
- (void)transToCollectConfilm{
    //    选择的第几个大类
    NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[self.integerTypeBig]];
    //    大类里面的数组
    NSMutableArray *arrValue = [NSMutableArray arrayWithArray:dicType[@"value"]];
    //    数组里面的最细分类
    
    for (int i = 0; i<arrValue.count; i++) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:arrValue[i]];
        if ([dicMiddle[IsSelected] intValue]==2) {
            [dicMiddle setObject:@"1" forKey:IsSelected];
        }else if ([dicMiddle[IsSelected] intValue]==3) {
            [dicMiddle setObject:@"0" forKey:IsSelected];
        }
        [arrValue replaceObjectAtIndex:i withObject:dicMiddle];
    }
    [dicType setObject:arrValue forKey:@"value"];
    [arrTypeSelected replaceObjectAtIndex:self.integerTypeBig withObject:dicType];
    [self.collectionViewType reloadData];
}
- (void)clickButtonShow:(UIButton *)sender{
    CGRect rect = self.rectSelf;
    rect.size.height = SCREEN_HEIGHT-rect.origin.y;
    [self setFrame:rect];
    self.isShow = YES;
    [self reloadCollectionView];
}
- (void)clickButtonHidden:(UIButton *)sender{
    CGRect rect = self.rectSelf;
    rect.size.height = 40;
    [self setFrame:rect];
    self.isShow = NO;
    [self transToCollectConfilmNot];
    [self reloadCollectionView];
}
- (void)reloadCollectionView{
    [self.collectionViewType reloadData];
    [self.collectionViewTypeHead reloadData];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionViewTypeHead) {
//        if (arrTypeSelected.count>4) {
//            return 4;
//        }
//        return arrTypeSelected.count;
        return 4;
    }
    NSArray *arrNum = arrTypeSelected[self.integerTypeBig][@"value"];
    return arrNum.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewTypeHead) {
        static NSString *identifier = @"CLCellGoodTypeHead";
        CLCellGoodTypeHead *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.row<arrTypeSelected.count) {
            [cell.viLbel.layer setBorderWidth:0.5];
            NSString *strArrow = @"";
            NSString *strTitle = [self getTheStringOfTypeSelected:indexPath.row];
            //        如果是选中的类型
            if (self.integerTypeBig == indexPath.row && self.isShow) {
                [cell.viBack setHidden:NO];
                strArrow = @"▲";
                [cell.viLbel.layer setBorderColor:[UIColor clearColor].CGColor];
                [cell.viLbel setBackgroundColor:[UIColor clearColor]];
            }else{
                strArrow = @"▼";
                [cell.viBack setHidden:YES];
                //            如果未选中的，有选中数据，则边框为红，背景无色，
                //            否则边框无色，背景灰色
                
                if ([NSString isNullString:strTitle]) {
                    [cell.viLbel.layer setBorderColor:[UIColor clearColor].CGColor];
                    [cell.viLbel setBackgroundColor:ColorFromHexRGB(0xf1f2f6)];
                }else{
                    [cell.viLbel.layer setBorderColor:[UIColor redColor].CGColor];
                    [cell.viLbel setBackgroundColor:[UIColor clearColor]];
                }
            }
            if ([NSString isNullString:strTitle]) {
                NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@ %@",arrTypeSelected[indexPath.row][@"name"],strArrow)];
                [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0]} range:NSMakeRange(atrString.length-1, 1)];
                [cell.lblContent setAttributedText:atrString];
                [cell.lblContent setTextColor:ColorBlack];
            }else{
                [cell.lblContent setTextColor:ColorRed];
                [cell.lblContent setTextNull:strTitle];
            }
            [cell.viLbel setHidden:NO];
        }else{
            [cell.viLbel setHidden:YES];
            [cell.viBack setHidden:YES];
        }
        return cell;
    }
    NSDictionary *dicInfo = arrTypeSelected[self.integerTypeBig][@"value"][indexPath.row];
    if ([dicInfo[IsSelected] intValue]== 1||[dicInfo[IsSelected] intValue]== 2) {
        static NSString *identifier = @"CLCellTypeSelected";
        CLCellTypeSelected *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTitle setTextNull:dicInfo[TypeName]];
        return cell;
    }else{
        static NSString *identifier = @"CLCellSelectedNo";
        CLCellSelectedNo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTitle setTextNull:dicInfo[TypeName]];
        return cell;
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewTypeHead) {
        return CGSizeMake(SCREEN_WIDTH/4,40);
    }
    return CGSizeMake(SCREEN_WIDTH/2,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewTypeHead) {
        
        if (self.integerTypeBig!=indexPath.row||self.isShow == NO) {
//            恢复所选择的，再刷新数据表，显示数据表
            
            if (indexPath.row<arrTypeSelected.count) {
                [self transToCollectConfilmNot];
                self.integerTypeBig = indexPath.row;
                [self reloadCollectionView];
                [self clickButtonShow:nil];
            }
        }
    }else{
        //    选择的第几个大类
        NSMutableDictionary *dicType = [NSMutableDictionary dictionaryWithDictionary:arrTypeSelected[self.integerTypeBig]];
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
        [arrTypeSelected replaceObjectAtIndex:self.integerTypeBig withObject:dicType];
        [self.collectionViewType reloadData];
    }
}
#pragma mark -- 查看是否还能选择更多
- (BOOL)isCanSelectMore:(NSArray *)array{
    int intNum = 0;
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        if ([dicMiddle[IsSelected] intValue]==1||[dicMiddle[IsSelected] intValue]==2) {
            intNum++;
        }
    }
    if (intNum>=5) {
        [SVProgressHUD showErrorWithStatus:@"最多只能选择五个哦"];
        return NO;
    }
    return YES;
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
    }
    
    
    return strName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

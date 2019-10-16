//
//  CellSendWay.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/21.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSendWay : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viImg;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIView *viOne;
@property (weak, nonatomic) IBOutlet UIView *viTwo;
@property (weak, nonatomic) IBOutlet UIView *viThree;
@property (weak, nonatomic) IBOutlet UILabel *lblOne;
@property (weak, nonatomic) IBOutlet UILabel *lblTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblThree;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgThree;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (strong, nonatomic) NSArray *arrImage;
- (void)populataData:(NSArray *)array;
@end

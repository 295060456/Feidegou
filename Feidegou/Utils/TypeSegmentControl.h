//
//  TypeSegmentControl.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectionBlock)(NSUInteger segmentIndex, BOOL select);
typedef enum {
    IconPositionRight,
    IconPositionLeft,
} IconPosition;
typedef enum {
    IconStateNo,
    IconStateNomer,
    IconStateOther
} IconState;

@interface TypeSegmentControl : UIView

@property (nonatomic,strong) NSMutableArray *arrImage;
@property (nonatomic,strong) NSMutableArray *arrButton;
@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,copy) SelectionBlock selectionBlock;
- (id)initWithFrame:(CGRect)frame
              items:(NSArray*)items
       iconPosition:(IconPosition)position
  andSelectionBlock:(SelectionBlock)block;

@end

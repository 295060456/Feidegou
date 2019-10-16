//
//  TypeSegmentControl.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "TypeSegmentControl.h"

@implementation TypeSegmentControl

- (id)initWithFrame:(CGRect)frame
              items:(NSArray *)items
       iconPosition:(IconPosition)position
  andSelectionBlock:(SelectionBlock)block{

    if (self = [super initWithFrame:frame]){
        //Selection block
        self.selectionBlock=block;
        
        //Default selected 0
        _currentSelected=0;
        //Background Color
        self.backgroundColor=[UIColor clearColor];
        self.arrImage = [NSMutableArray array];
        self.arrButton = [NSMutableArray array];
        //Generating segments
        float buttonWith=frame.size.width/items.count;
        int i=0;
        for(NSDictionary *item in items){
            NSString *text=item[@"text"];
            NSString *icon=item[@"icon"];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0+buttonWith*i,
                                                                          0,
                                                                          buttonWith,
                                                                          frame.size.height)];
            [button setTag:i];
            if ([NSString isNullString:icon]) {
//                没图片
            }else{
                //                    显示默认
                if (position == IconPositionRight) {
                    text = StringFormat(@"%@ ",text);
                }else{
                    text = StringFormat(@" %@",text);
                }
            }
            [button setTitle:text forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(segmentSelected:)
             forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            //Adding to self view
            [self addSubview:button];
            [self.arrButton addObject:button];
            [self.arrImage addObject:[NSString stringStandard:icon]];
            
            
            i++;
            UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      frame.size.height-0.5,
                                                                      frame.size.width,
                                                                      0.5)];
            [viLine setBackgroundColor:ColorLine];
            [self addSubview:viLine];
        }
        UIButton *button = (UIButton *)self.arrButton[_currentSelected];
        [self refreshButtonImage:button];
    }
    return self;
}

- (void)refreshButtonImage:(UIButton *)sender{
    for (int i = 0; i<self.arrButton.count; i++) {
        IconState state = [self getStateOfImage:self.arrImage[i]];
        UIButton *button = (UIButton *)self.arrButton[i];
        if (_currentSelected == button.tag) {
            
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:ColorBlack forState:UIControlStateNormal];
            [button setSelected:YES];
        }
        if (state == IconStateNomer) {
            if (button.tag == _currentSelected) {
                [button setImage:ImageNamed(@"img_select_s")
                        forState:UIControlStateNormal];
                [button setImage:ImageNamed(@"img_select_x")
                        forState:UIControlStateSelected];
            }else{
                [button setImage:ImageNamed(@"img_select_n")
                        forState:UIControlStateNormal];
                [button setImage:ImageNamed(@"img_select_n")
                        forState:UIControlStateSelected];
            }
        }else{
            [button setImage:ImageNamed(self.arrImage[i])
                    forState:UIControlStateNormal];
        }
    }
}

- (IconState)getStateOfImage:(NSString *)string{
    if ([NSString isNullString:string]) {
        //                没图片
        return IconStateNo;
    }else{
        if ([TransformString(string) isEqualToString:@"yes"]) {
            return IconStateNomer;
        }else{
            return IconStateOther;
        }
    }
}
#pragma mark - Actions
-(void)segmentSelected:(UIButton *)sender{
    if (sender.tag != 3) {
        _currentSelected = sender.tag;
        [self refreshButtonImage:sender];
        if(sender.selected){
            [sender setSelected:NO];
        }else{
            [sender setSelected:YES];
        }
        if(self.selectionBlock){
            self.selectionBlock(_currentSelected,sender.selected);
        }
    }else{
        if(self.selectionBlock){
            self.selectionBlock(3,sender.selected);
        }
    }
}

@end

//
//  TypeSelectFunction.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/1.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IsSelected @"isSelected"
#define IsAll @"isAll"
#define TypeName @"typeName"
@interface TypeSelectFunction : UIView

//isSelect的状态有四种：0（未选），1（已选），2（待已选），3（待未选）；0为未选，1为已选；
//当0变为已选时为2，当1变为未选时，为3；
//当确定所选时已选2变为1，未选3变为0
//如果不确定，直接隐藏，则还原，2变为0，3变为1
//当重置时，待已选2变为0，待已选1变为3
@end

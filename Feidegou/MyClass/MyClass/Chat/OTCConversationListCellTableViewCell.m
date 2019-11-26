//
//  OTCConversationListCellTableViewCell.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OTCConversationListCellTableViewCell.h"

@interface OTCConversationListCellTableViewCell ()

@end

@implementation OTCConversationListCellTableViewCell

+(instancetype)cellWith:(UITableView *)tableView{
    OTCConversationListCellTableViewCell *cell = (OTCConversationListCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OTCConversationListCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                           reuseIdentifier:ReuseIdentifier];
        
        cell.backgroundColor = [UIColor yellowColor];//[UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper")];

//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{

}

@end

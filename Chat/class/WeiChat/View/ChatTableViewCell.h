//
//  ChatTableViewCell.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/27.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"


@interface ChatTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel *_usernameLabel;
    __weak IBOutlet UILabel *_lastmsgLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_countLabel;

}
@property (nonatomic, retain) EMConversation *conversation;
@end

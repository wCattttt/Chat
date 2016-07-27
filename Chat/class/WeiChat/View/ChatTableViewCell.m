//
//  ChatTableViewCell.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/27.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "EaseUI.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 8;
    
    _countLabel.layer.masksToBounds = YES;
    _countLabel.layer.cornerRadius = 8;
}

- (void)setConversation:(EMConversation *)conversation{
    _conversation = conversation;
    if(conversation.type == EMConversationTypeGroupChat){
        // 群组会话
    }else if(conversation.type == EMConversationTypeChat){
        // 单聊
        _usernameLabel.text = conversation.conversationId;
        EMMessage *lastMessage = conversation.latestMessage;
        NSString *latestMessageTitle = @"";
        switch (lastMessage.body.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)lastMessage.body).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
        _lastmsgLabel.text = latestMessageTitle;
        
        NSString *latestMessageTime = @"";
        if (lastMessage) {
            latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
        }
        _timeLabel.text = latestMessageTime;
        
        if(conversation.unreadMessagesCount > 0){
            _countLabel.hidden = NO;
            _countLabel.text = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
        }else{
            _countLabel.hidden = YES;
        }
    }
    
}


@end

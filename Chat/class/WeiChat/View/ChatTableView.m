//
//  ChatTableView.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/27.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "ChatTableView.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "GroupViewController.h"
#import "ChatTableViewCell.h"

@interface ChatTableView()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_identify;
}
@end

@implementation ChatTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        [self _initTableView];
    }
    return self;
}

- (void)_initTableView{
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    _identify = @"ChatTableView";
    [self registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:_identify];
    
}

#pragma mark UITableView Datasource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chatData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    EMConversation *conversation = _chatData[indexPath.row];
    cell.conversation = conversation;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *conversation = _chatData[indexPath.row];
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:EMConversationTypeChat];
    chatController.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:chatController animated:YES];
}

// tableView编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除事件
    if(editingStyle == UITableViewCellEditingStyleDelete){
        EMConversation *conversation = _chatData[indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:YES];
        [_chatData removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

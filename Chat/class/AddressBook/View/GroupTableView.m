//
//  GroupTableView.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/28.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "GroupTableView.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "CreateGroupViewController.h"

@interface GroupTableView()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_identify;
}
@end
@implementation GroupTableView

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
    
    _identify = @"GroupTableView";
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:_identify];
}

#pragma mark UITableView DataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _groupData.count;
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if(indexPath.section == 0 && indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"group"];
        cell.textLabel.text = @"新建群组";
    }else{
        EMGroup *group = _groupData[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"group"];
        cell.textLabel.text = group.subject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CreateGroupViewController *createVC = [[CreateGroupViewController alloc] init];
        [[self viewController].navigationController pushViewController:createVC animated:YES];
    }else{
        // 聊天
        EMGroup *group = _groupData[indexPath.row];
        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        [[self viewController].navigationController pushViewController:chatController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




@end

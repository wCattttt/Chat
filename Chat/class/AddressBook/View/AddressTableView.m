//
//  AddressTableView.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "AddressTableView.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "GroupViewController.h"

@interface AddressTableView()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_identify;
}
@end

@implementation AddressTableView

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
    
    _identify = @"AddressTableView";
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
            return _userData.count;
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
        cell.textLabel.text = @"群聊";
    }else{
        id<IUserModel> model = nil;
        model = [[EaseUserModel alloc] initWithBuddy:_userData[indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:@"user"];
        cell.textLabel.text = model.buddy;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        // 群聊
        GroupViewController *groupVC = [[GroupViewController alloc] init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:groupVC animated:YES];
    }else{
        // 单聊 聊天
        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:_userData[indexPath.row] conversationType:EMConversationTypeChat];
        chatController.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:chatController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 1){
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //事件
        NSLog(@"删除");
        // 删除好友
//        EMError *error = [[EMClient sharedClient].contactManager deleteContact:_userData[indexPath.row]];
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:@"1111111"];
        if (!error) {
            [[self viewController] showHint:@"删除成功"];
            [_userData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }];
    
    UITableViewRowAction *noDeleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"不删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //事件
        NSLog(@"不删除");
    }];
    
    noDeleAction.backgroundColor = [UIColor purpleColor];
    return @[deleAction,noDeleAction];
}


@end

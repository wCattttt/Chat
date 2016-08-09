//
//  AddGroupUserViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/29.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "AddGroupUserViewController.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "CreateGroupModel.h"

@interface AddGroupUserViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_identifity;
    
    NSMutableArray *_userData;
    NSMutableArray *_selectUser;
}
@end

@implementation AddGroupUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userData = @[].mutableCopy;
    _selectUser = @[].mutableCopy;
    _identifity = @"AddGroupUserTableView";
    
    [self _createView];
}

- (void)_createView{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_identifity];
    
    _userData = [[EMClient sharedClient].contactManager getContactsFromDB];
    [_tableView reloadData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50);
    [button setTitle:@"创建群组" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:1];
    [button addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifity];
    cell.imageView.image = [UIImage imageNamed:@"user"];
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:_userData[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:@"user"];
    cell.textLabel.text = model.buddy;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block BOOL include;
    [_selectUser enumerateObjectsUsingBlock:^(NSString *username, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_userData[indexPath.row] isEqualToString:username]){
            include = YES;
        }
    }];
    if(include){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectUser removeObject:_userData[indexPath.row]];
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectUser addObject:_userData[indexPath.row]];
    }
}

- (void)createGroup{
    // 新建群组
    EMError *error = nil;
    
    [[EMClient sharedClient].groupManager asyncCreateGroupWithSubject:_createGroupModel.groupTitle description:_createGroupModel.description invitees:_selectUser message:_createGroupModel.groupMessage setting:_createGroupModel.setting success:^(EMGroup *aGroup) {
        [self showHint:[NSString stringWithFormat:@"创建群%@成功", _createGroupModel.groupTitle]];
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateGroupComplete" object:nil];
    } failure:^(EMError *aError) {
        
    }];
    
//    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:_createGroupModel.groupTitle description:_createGroupModel.description invitees:_selectUser message:_createGroupModel.groupMessage setting:_createGroupModel.setting error:&error];
//    if(!error){
//        [self showHint:[NSString stringWithFormat:@"创建群%@成功", _createGroupModel.groupTitle]];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateGroupComplete" object:nil];
//    }else{
//        [self showHint:error.errorDescription];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
